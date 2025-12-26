import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:tactile_feedback/tactile_feedback.dart';

// The update animation curve.
const Cubic _kUpdateAnimationCurve = Curves.easeInOut;

// The duration of update animation.
const _kUpdateAnimationDuration = Duration(milliseconds: 250);

// The short duration of update animation.
const _kUpdateAnimationShortDuration = Duration(milliseconds: 50);

// The height of the ruler.
const _kRulerHeight = 48.0;

// The width of the pointer mark.
const _kPointerMarkWidth = 3.0;

// The size of the pointer mark.
const _kPointerMarkSize = Size(_kPointerMarkWidth, 24);

/// The width of the mark.
@visibleForTesting
const kMarkWidth = 1.5;

// The size of the small mark.
const _kSmallMarkSize = Size(kMarkWidth, 8);

// The size of the large mark.
const _kLargeMarkSize = Size(kMarkWidth, 18);

/// The width of gap between marks.
@visibleForTesting
const double kGapWidth = GyverLampSpacings.sm;

// The corner radius of the ruler.
const _kBorderRadius = Radius.circular(8);

/// Calculates the offset for ruler depending on the item index.
double _getOffsetFromIndex({
  required int index,
  required double itemExtent,
  required double gapExtent,
}) {
  return index * gapExtent + index * itemExtent + itemExtent / 2;
}

/// Calculates the index of the ruler item depending on the offset.
int _getIndexFromOffset({
  required double offset,
  required double itemExtent,
  required double gapExtent,
  required double minScrollExtent,
  required double maxScrollExtent,
}) {
  final o = math.min(math.max(offset, minScrollExtent), maxScrollExtent);

  final i = (o - itemExtent / 2) / (itemExtent + gapExtent);

  return i < 0 ? 0 : i.round().abs();
}

/// A snapping physics that always lands directly on items instead of anywhere
/// within the scroll extent.
///
/// Must be used with a scrollable that uses a [_RulerScrollController].
class _RulerScrollPhysics extends ScrollPhysics {
  const _RulerScrollPhysics()
    // coverage:ignore-start
    : super(
        // coverage:ignore-end
        parent: const BouncingScrollPhysics(
          parent: RangeMaintainingScrollPhysics(),
        ),
      );

  @override
  _RulerScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return const _RulerScrollPhysics();
  }

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 1,
    stiffness: 180,
    damping: 28,
  );

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    assert(
      position is _RulerScrollPosition,
      'RulerScrollPhysics can only be used with scrollables that uses '
      'the RulerScrollController',
    );

    final metrics = position as _RulerScrollPosition;

    // Scenario 1:
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at the scrollable's
    // boundary.
    if ((velocity <= 0.0 && metrics.pixels <= metrics.minScrollExtent) ||
        (velocity >= 0.0 && metrics.pixels >= metrics.maxScrollExtent)) {
      return super.createBallisticSimulation(metrics, velocity);
    }

    // Create a test simulation to see where it would have ballistically fallen
    // naturally without settling onto items.
    final testFrictionSimulation = super.createBallisticSimulation(
      metrics,
      velocity,
    );

    // Scenario 2:
    // If it was going to end up past the scroll extent, defer back to the
    // parent physics' ballistics again which should put us on the scrollable's
    // boundary.
    if (testFrictionSimulation != null &&
        (testFrictionSimulation.x(double.infinity) <= metrics.minScrollExtent ||
            testFrictionSimulation.x(double.infinity) >=
                metrics.maxScrollExtent)) {
      return super.createBallisticSimulation(metrics, velocity);
    }

    // From the natural final position, find the nearest item it should have
    // settled to.
    final settlingItemIndex = _getIndexFromOffset(
      offset: velocity.abs() > 100
          ? (testFrictionSimulation?.x(double.infinity) ?? metrics.pixels)
          : metrics.pixels,
      itemExtent: metrics.itemExtent,
      gapExtent: metrics.gapExtent,
      minScrollExtent: metrics.minScrollExtent,
      maxScrollExtent: metrics.maxScrollExtent,
    );

    final settlingPixels = _getOffsetFromIndex(
      index: settlingItemIndex,
      itemExtent: metrics.itemExtent,
      gapExtent: metrics.gapExtent,
    );

    // Scenario 3:
    // If there's no velocity and we're already at where we intend to land,
    // do nothing.
    if (velocity.abs() < toleranceFor(position).velocity &&
        (settlingPixels - metrics.pixels).abs() <
            toleranceFor(position).distance * 2) {
      return null;
    }

    // Scenario 4:
    // If we're going to end back at the same item because initial velocity
    // is too low to break past it, use a spring simulation to get back.
    if (settlingItemIndex == metrics.itemIndex) {
      return SpringSimulation(
        spring,
        metrics.pixels,
        settlingPixels,
        0,
        tolerance: toleranceFor(position),
      );
    }

    // Scenario 5:
    // Create a new friction simulation except the drag will be tweaked to land
    // exactly on the item closest to the natural stopping point.
    return FrictionSimulation.through(
      metrics.pixels,
      settlingPixels,
      velocity,
      toleranceFor(position).velocity * velocity.sign,
    );
  }
}

/// A scroll controller for [Ruler] widget.
///
/// Similar to a standard [ScrollController] but with the added convenience
/// mechanisms to read and go to item indices rather than a raw pixel scroll
/// offset.
class _RulerScrollController extends ScrollController {
  _RulerScrollController({
    required this.itemExtent,
    required this.gapExtent,
    this.initialItem = 0,
  });

  /// Size of each item in the main axis.
  final double itemExtent;

  /// Size of each gap in the main axis.
  final double gapExtent;

  /// The page to show when first creating the scroll view.
  final int initialItem;

  /// Animates the ruler to the given item index.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// The `duration` and `curve` arguments must not be null.
  Future<void> animateToItem(
    int itemIndex, {
    required Duration duration,
    required Curve curve,
  }) async {
    if (!hasClients) {
      return;
    }

    await Future.wait<void>(<Future<void>>[
      for (final position in positions.cast<_RulerScrollPosition>())
        position.animateTo(
          _getOffsetFromIndex(
            index: itemIndex,
            itemExtent: position.itemExtent,
            gapExtent: position.gapExtent,
          ),
          duration: duration,
          curve: curve,
        ),
    ]);
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _RulerScrollPosition(
      physics: physics,
      context: context,
      itemExtent: itemExtent,
      gapExtent: gapExtent,
      initialItem: initialItem,
      oldPosition: oldPosition,
    );
  }
}

/// Metrics for a ruler [ScrollPosition].
class _RulerScrollMetrics extends FixedScrollMetrics {
  _RulerScrollMetrics({
    required super.minScrollExtent,
    required super.maxScrollExtent,
    required super.pixels,
    required super.viewportDimension,
    required super.axisDirection,
    required super.devicePixelRatio,
    required this.itemIndex,
  });

  /// The currently selected item index.
  final int itemIndex;

  // coverage:ignore-start
  @override
  _RulerScrollMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    double? devicePixelRatio,
    int? itemIndex,
  }) {
    return _RulerScrollMetrics(
      minScrollExtent:
          minScrollExtent ??
          (hasContentDimensions ? this.minScrollExtent : null),
      maxScrollExtent:
          maxScrollExtent ??
          (hasContentDimensions ? this.maxScrollExtent : null),
      pixels: pixels ?? (hasPixels ? this.pixels : null),
      viewportDimension:
          viewportDimension ??
          (hasViewportDimension ? this.viewportDimension : null),
      axisDirection: axisDirection ?? this.axisDirection,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      itemIndex: itemIndex ?? this.itemIndex,
    );
  }

  // coverage:ignore-end
}

/// A [ScrollPosition] that is used by [_RulerScrollController].
class _RulerScrollPosition extends ScrollPositionWithSingleContext
    implements _RulerScrollMetrics {
  _RulerScrollPosition({
    required super.physics,
    required super.context,
    required this.itemExtent,
    required this.gapExtent,
    required int initialItem,
    super.oldPosition,
  }) : super(
         initialPixels: _getOffsetFromIndex(
           index: initialItem,
           itemExtent: itemExtent,
           gapExtent: gapExtent,
         ),
       );

  final double itemExtent;

  final double gapExtent;

  @override
  int get itemIndex {
    return _getIndexFromOffset(
      offset: pixels,
      itemExtent: itemExtent,
      gapExtent: gapExtent,
      minScrollExtent: minScrollExtent,
      maxScrollExtent: maxScrollExtent,
    );
  }

  @override
  _RulerScrollMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    double? devicePixelRatio,
    int? itemIndex,
  }) {
    return _RulerScrollMetrics(
      minScrollExtent:
          minScrollExtent ??
          (hasContentDimensions ? this.minScrollExtent : null),
      maxScrollExtent:
          maxScrollExtent ??
          (hasContentDimensions ? this.maxScrollExtent : null),
      pixels: pixels ?? (hasPixels ? this.pixels : null),
      viewportDimension:
          viewportDimension ??
          (hasViewportDimension ? this.viewportDimension : null),
      axisDirection: axisDirection ?? this.axisDirection,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
      itemIndex: itemIndex ?? this.itemIndex,
    );
  }
}

/// A widget which draws mark for [Ruler].
class _Mark extends StatelessWidget {
  const _Mark({
    required this.color,
    required this.size,
  });

  final Color color;

  final Size size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MarkPainter(color: color),
      size: size,
    );
  }
}

/// A [CustomPainter] for [_Mark] widget.
class _MarkPainter extends CustomPainter {
  const _MarkPainter({
    required this.color,
  });

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromLTRBR(
      0,
      0,
      size.width,
      size.height,
      Radius.circular(size.width),
    );

    canvas.drawRRect(
      rect,
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_MarkPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

/// An [ImplicitlyAnimatedWidget] for integer value represented as [Text].
class _AnimatedValueText extends ImplicitlyAnimatedWidget {
  const _AnimatedValueText({
    required this.value,
    required super.duration,
    required super.curve,
  });

  final int value;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedValueTextState();
}

class _AnimatedValueTextState
    extends AnimatedWidgetBaseState<_AnimatedValueText> {
  IntTween? _valueTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _valueTween =
        visitor(
              _valueTween,
              widget.value,
              (value) => IntTween(begin: value as int),
            )!
            as IntTween;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return Text(
      _valueTween!.evaluate(animation).toString(),
      style: GyverLampTextStyles.captionBold.copyWith(
        color: theme.textPrimary,
      ),
      textAlign: TextAlign.left,
    );
  }
}

/// Custom scroll behavior for [Ruler] widget.
class _RulerScrollBehavior extends ScrollBehavior {
  const _RulerScrollBehavior();

  @override
  GestureVelocityTrackerBuilder velocityTrackerBuilder(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return (PointerEvent event) =>
            IOSScrollViewFlingVelocityTracker(event.kind);

      case TargetPlatform.macOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return (PointerEvent event) => VelocityTracker.withKind(event.kind);
    }
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}

/// {@template ruler}
/// Gyver Lamp Ruler.
/// {@endtemplate}
class Ruler extends StatefulWidget {
  /// {@macro ruler}
  const Ruler({
    required this.value,
    required this.maxValue,
    required this.onChanged,
    super.key,
  }) : assert(
         value > 0 && value <= maxValue,
         'value have to be in range [1, maxValue]',
       );

  /// The current value of the ruler.
  final int value;

  /// The maximum available value in the ruler.
  final int maxValue;

  /// The callback that is called when a new value is selected.
  final ValueChanged<int> onChanged;

  @override
  State<Ruler> createState() => _RulerState();
}

class _RulerState extends State<Ruler> {
  late final _RulerScrollController _scrollController;

  int _currentIndex = 0;

  int _lastReportedItemIndex = 0;

  bool _isDragging = false;

  bool _isScrolling = false;

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.value - 1;
    _lastReportedItemIndex = _currentIndex;

    _scrollController = _RulerScrollController(
      itemExtent: kMarkWidth,
      gapExtent: kGapWidth,
      initialItem: _currentIndex,
    );
  }

  @override
  void didUpdateWidget(Ruler oldWidget) {
    super.didUpdateWidget(oldWidget);

    _currentIndex = widget.value - 1;

    if (oldWidget.value != widget.value && !_isDragging && !_isScrolling) {
      _isAnimating = true;

      _scrollController
          .animateToItem(
            _currentIndex,
            duration: _kUpdateAnimationDuration,
            curve: _kUpdateAnimationCurve,
          )
          .then((_) => _isAnimating = false)
          .ignore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _isScrolling = true;
      return true;
    }

    if (notification is ScrollEndNotification) {
      _isScrolling = false;
      return true;
    }

    if (notification is ScrollUpdateNotification &&
        notification.metrics is _RulerScrollMetrics) {
      final metrics = notification.metrics as _RulerScrollMetrics;

      final currentItemIndex = metrics.itemIndex;

      if (currentItemIndex != _lastReportedItemIndex) {
        TactileFeedback.impact();

        _lastReportedItemIndex = currentItemIndex;

        if (!_isAnimating) {
          widget.onChanged(currentItemIndex + 1);
        }
      }

      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return RepaintBoundary(
      child: ScrollConfiguration(
        behavior: const _RulerScrollBehavior(),
        child: Listener(
          onPointerDown: (_) {
            _isDragging = true;
          },
          onPointerUp: (_) {
            _isDragging = false;
          },
          child: NotificationListener<ScrollNotification>(
            onNotification: _handleScrollNotification,
            child: SizedBox(
              height: _kRulerHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.surfacePrimary,
                  boxShadow: [theme.shadows.shadow1],
                  borderRadius: const BorderRadius.all(_kBorderRadius),
                  border: Border.all(color: theme.borderPrimary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GyverLampSpacings.lg,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return ListView.separated(
                                  addRepaintBoundaries: false,
                                  addAutomaticKeepAlives: false,
                                  cacheExtent: 100,
                                  itemCount: widget.maxValue,
                                  physics: const _RulerScrollPhysics(),
                                  controller: _scrollController,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: constraints.biggest.width / 2,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(width: kGapWidth);
                                  },
                                  itemBuilder: (context, index) {
                                    if (index.isOdd) {
                                      return Center(
                                        child: _Mark(
                                          color: theme.textSecondary,
                                          size: _kSmallMarkSize,
                                        ),
                                      );
                                    }

                                    return Center(
                                      child: _Mark(
                                        color: theme.textSecondary,
                                        size: _kLargeMarkSize,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            IgnorePointer(
                              child: _Mark(
                                color: theme.pointer,
                                size: _kPointerMarkSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: GyverLampSpacings.md,
                          bottom: GyverLampSpacings.md,
                          left: GyverLampSpacings.sm,
                        ),
                        child: SizedBox(
                          height: GyverLampSpacings.xlg,
                          width: GyverLampSpacings.xlg + GyverLampSpacings.xs,
                          child: Align(
                            alignment: AlignmentDirectional.center,
                            child: _AnimatedValueText(
                              value: widget.value,
                              duration: _lastReportedItemIndex == _currentIndex
                                  ? _kUpdateAnimationShortDuration
                                  : _kUpdateAnimationDuration,
                              curve: _kUpdateAnimationCurve,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
