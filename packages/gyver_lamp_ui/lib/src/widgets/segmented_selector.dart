import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:tactile_feedback/tactile_feedback.dart';

const Duration _kScaleAnimationDuration = Duration(milliseconds: 500);
const Duration _kHighlightAnimationDuration = Duration(milliseconds: 200);
const Duration _kSpringAnimationDuration = Duration(milliseconds: 420);

// The minimum scale factor of the thumb, when being pressed on for a sufficient
// amount of time.
const double _kMinThumbScale = 0.95;

// The threshold value used in hasDraggedTooFar, for checking against the square
// L2 distance from the location of the current drag pointer, to the closest
// vertex of the SegmentedSelector's Rect.
const double _kTouchYDistanceThreshold = 50.0 * 50.0;

// Width of the separator between segments.
const double _kSeparatorWidth = GyverLampSpacings.xs;

// The corner radius of the thumb.
const Radius _kThumbRadius = Radius.circular(8);

// The spring animation used when the thumb changes its rect.
final SpringSimulation _kThumbSpringAnimationSimulation = SpringSimulation(
  const SpringDescription(mass: 1, stiffness: 503.551, damping: 44.8799),
  0,
  1,
  0, // Every time a new spring animation starts the previous animation stops.
);

/// {@template selector_segment}
/// Data describing a segment of a [SegmentedSelector].
/// {@endtemplate}
class SelectorSegment<T extends Object> {
  /// {@macro selector_segment}
  const SelectorSegment({
    required this.value,
    required this.label,
  });

  /// Value used to identify the segment.
  ///
  /// This value must be unique across all segments in a [SegmentedSelector].
  final T value;

  /// Label of the segment.
  final String label;
}

class _Segment<T extends Object> extends StatefulWidget {
  const _Segment({
    required ValueKey<T> key,
    required this.segment,
    required this.pressed,
    required this.highlighted,
    required this.isDragging,
  }) : super(key: key);

  final SelectorSegment<T> segment;

  final bool pressed;

  final bool highlighted;

  /// Whether the thumb of the parent widget [SegmentedSelector]
  /// is currently being dragged.
  final bool isDragging;

  bool get shouldScaleContent =>
      (pressed && highlighted && isDragging) || (pressed && !highlighted);

  @override
  _SegmentState<T> createState() => _SegmentState<T>();
}

class _SegmentState<T extends Object> extends State<_Segment<T>>
    with TickerProviderStateMixin<_Segment<T>> {
  late final AnimationController _scaleController;

  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: _kScaleAnimationDuration,
      value: widget.shouldScaleContent ? 1 : 0,
      vsync: this,
    );

    _scaleAnimation = _scaleController.drive(
      Tween<double>(begin: 1, end: 1),
    );
  }

  @override
  void didUpdateWidget(_Segment<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.shouldScaleContent != widget.shouldScaleContent) {
      _scaleAnimation = _scaleController.drive(
        Tween<double>(
          begin: _scaleAnimation.value,
          end: widget.shouldScaleContent ? _kMinThumbScale : 1.0,
        ),
      );

      _scaleController.animateWith(_kThumbSpringAnimationSimulation);
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return ScaleTransition(
      scale: _scaleAnimation,
      filterQuality: FilterQuality.low,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: GyverLampSpacings.sm,
          horizontal: GyverLampSpacings.sm,
        ),
        child: AnimatedDefaultTextStyle(
          style: GyverLampTextStyles.subtitle1.copyWith(
            color: widget.highlighted ? theme.textPrimary : theme.textSecondary,
          ),
          duration: _kHighlightAnimationDuration,
          curve: Curves.ease,
          child: Text(
            widget.segment.label,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

/// {@template segmented_selector}
/// Gyver Lamp Segmented Selector.
/// {@endtemplate}
class SegmentedSelector<T extends Object> extends StatefulWidget {
  /// {@macro segmented_selector}
  const SegmentedSelector({
    required this.segments,
    required this.selected,
    required this.onChanged,
    super.key,
  }) : assert(
         segments.length >= 2,
         'Not enough segments. Please provide at least 2 segments.',
       );

  /// Descriptions of the segments in the selector.
  final List<SelectorSegment<T>> segments;

  /// The selected segment.
  final T selected;

  /// The callback that is called when a new segment is selected.
  final ValueChanged<T> onChanged;

  @override
  State<SegmentedSelector<T>> createState() => _SegmentedSelectorState<T>();
}

class _SegmentedSelectorState<T extends Object>
    extends State<SegmentedSelector<T>>
    with TickerProviderStateMixin {
  late final _thumbController = AnimationController(
    duration: _kSpringAnimationDuration,
    value: 0,
    vsync: this,
  );
  Animatable<Rect?>? _thumbAnimatable;

  late final _thumbScaleController = AnimationController(
    duration: _kSpringAnimationDuration,
    value: 0,
    vsync: this,
  );
  late Animation<double> _thumbScaleAnimation = _thumbScaleController.drive(
    Tween<double>(begin: 1, end: _kMinThumbScale),
  );

  final _tap = TapGestureRecognizer();
  final _drag = HorizontalDragGestureRecognizer();
  final _longPress = LongPressGestureRecognizer();

  // The segment the sliding thumb is currently located at, or animating to. It
  // may have a different value from widget.groupValue, since this widget does
  // not report a selection change via `onValueChanged` until the user stops
  // interacting with the widget (onTapUp). For example, the user can drag the
  // thumb around, and the `onValueChanged` callback will not be invoked until
  // the thumb is let go.
  late T _highlighted;

  // The segment the user is currently pressing.
  T? _pressed;

  // Whether the current drag gesture started on a selected segment. When this
  // flag is false, the `onUpdate` method does not update `highlighted`.
  // Otherwise the thumb can be dragged around in an ongoing drag gesture.
  bool? _startedOnSelectedSegment;

  // Whether an ongoing horizontal drag gesture that started on the thumb is
  // present. When true, defer/ignore changes to the `highlighted` variable
  // from other sources (except for semantics) until the gesture ends,
  // preventing them from interfering with the active drag gesture.
  bool get _isThumbDragging => _startedOnSelectedSegment ?? false;

  late T _feedbackValue = widget.selected;

  @override
  void initState() {
    super.initState();

    _highlighted = widget.selected;

    // If the long press or horizontal drag recognizer gets accepted, we know
    // for sure the gesture is meant for the segmented control. Hand everything
    // to the drag gesture recognizer.
    final team = GestureArenaTeam();
    _longPress.team = team;
    _drag.team = team;
    team.captain = _drag;

    _drag
      ..onDown = _onDown
      ..onUpdate = _onUpdate
      ..onEnd = _onEnd
      ..onCancel = _onCancel;

    _tap.onTapUp = _onTapUp;

    // Empty callback to enable the long press recognizer.
    _longPress.onLongPress = () {};
  }

  @override
  void didUpdateWidget(SegmentedSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Temporarily ignore highlight changes from the widget when the thumb is
    // being dragged. When the drag gesture finishes the widget will be forced
    // to build (see the onEnd method), and didUpdateWidget will be called
    // again.
    if (!_isThumbDragging && _highlighted != widget.selected) {
      _thumbController.animateWith(_kThumbSpringAnimationSimulation);
      _thumbAnimatable = null;
      _highlighted = widget.selected;
    }
  }

  @override
  void dispose() {
    _thumbScaleController.dispose();
    _thumbController.dispose();

    _drag.dispose();
    _tap.dispose();
    _longPress.dispose();

    super.dispose();
  }

  // Converts local coordinate to segments. This method assumes each segment has
  // the same width.
  T _segmentForXPosition(double dx) {
    final renderBox = context.findRenderObject()! as RenderBox;
    final numOfChildren = widget.segments.length;

    var index = (dx ~/ (renderBox.size.width / numOfChildren)).clamp(
      0,
      numOfChildren - 1,
    );

    switch (Directionality.of(context)) {
      case TextDirection.ltr:
        break;
      case TextDirection.rtl:
        index = numOfChildren - 1 - index;
    }

    return widget.segments.elementAt(index).value;
  }

  bool _hasDraggedTooFar(DragUpdateDetails details) {
    final renderBox = context.findRenderObject()! as RenderBox;

    final size = renderBox.size;
    final offCenter =
        details.localPosition - Offset(size.width / 2, size.height / 2);
    final l2 =
        math.pow(math.max(0.0, offCenter.dx.abs() - size.width / 2), 2) +
                math.pow(math.max(0.0, offCenter.dy.abs() - size.height / 2), 2)
            as double;

    return l2 > _kTouchYDistanceThreshold;
  }

  // The thumb shrinks when the user presses on it, and starts expanding when
  // the user lets go.
  // This animation must be synced with the segment scale animation (see the
  // _Segment widget) to make the overall animation look natural when the thumb
  // is not sliding.
  void _playThumbScaleAnimation({required bool isExpanding}) {
    _thumbScaleAnimation = _thumbScaleController.drive(
      Tween<double>(
        begin: _thumbScaleAnimation.value,
        end: isExpanding ? 1 : _kMinThumbScale,
      ),
    );
    _thumbScaleController.animateWith(_kThumbSpringAnimationSimulation);
  }

  void _onHighlightChangedByGesture(T newValue) {
    if (_highlighted == newValue) {
      return;
    }

    setState(() {
      _highlighted = newValue;
    });

    _thumbController.animateWith(_kThumbSpringAnimationSimulation);
    _thumbAnimatable = null;
  }

  void _onPressedChangedByGesture(T? newValue) {
    if (_pressed != newValue) {
      setState(() {
        _pressed = newValue;
      });
    }
  }

  void _onTapUp(TapUpDetails details) {
    // No gesture should interfere with an ongoing thumb drag.
    if (_isThumbDragging) {
      return;
    }

    final segment = _segmentForXPosition(details.localPosition.dx);

    _onPressedChangedByGesture(null);

    _handleFeedback(segment);

    if (segment != widget.selected) {
      widget.onChanged(segment);
    }
  }

  void _onDown(DragDownDetails details) {
    final touchDownSegment = _segmentForXPosition(details.localPosition.dx);

    _startedOnSelectedSegment = touchDownSegment == _highlighted;

    _onPressedChangedByGesture(touchDownSegment);

    _handleFeedback(touchDownSegment);

    if (_isThumbDragging) {
      _playThumbScaleAnimation(isExpanding: false);
    }
  }

  void _onUpdate(DragUpdateDetails details) {
    if (_isThumbDragging) {
      final segment = _segmentForXPosition(details.localPosition.dx);

      _onPressedChangedByGesture(segment);
      _onHighlightChangedByGesture(segment);

      _handleFeedback(segment);
    } else {
      final segment = _hasDraggedTooFar(details)
          ? null
          : _segmentForXPosition(details.localPosition.dx);

      _onPressedChangedByGesture(segment);

      _handleFeedback(segment ?? _feedbackValue);
    }
  }

  void _onEnd(DragEndDetails details) {
    final pressed = _pressed;

    if (_isThumbDragging) {
      _playThumbScaleAnimation(isExpanding: true);

      if (_highlighted != widget.selected) {
        widget.onChanged(_highlighted);
      }
    } else if (pressed != null) {
      _onHighlightChangedByGesture(pressed);

      assert(
        pressed == _highlighted,
        'pressed segment should be highlighted',
      );

      if (_highlighted != widget.selected) {
        widget.onChanged(_highlighted);
      }
    }

    _onPressedChangedByGesture(null);
    _startedOnSelectedSegment = null;

    _handleFeedback(_highlighted);
  }

  void _onCancel() {
    if (_isThumbDragging) {
      _playThumbScaleAnimation(isExpanding: true);
    }

    _onPressedChangedByGesture(null);
    _startedOnSelectedSegment = null;
  }

  void _handleFeedback(T value) {
    if (_feedbackValue == value) {
      return;
    }

    _feedbackValue = value;

    TactileFeedback.impact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    var children = widget.segments
        .map<Widget>(
          (segment) {
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: _Segment<T>(
                key: ValueKey<T>(segment.value),
                segment: segment,
                highlighted: _highlighted == segment.value,
                pressed: _pressed == segment.value,
                isDragging: _isThumbDragging,
              ),
            );
          },
        )
        .intersperse(
          const SizedBox(width: _kSeparatorWidth),
        )
        .toList();

    var highlightedIndex = widget.segments.indexWhere(
      (s) => s.value == _highlighted,
    );

    switch (Directionality.of(context)) {
      case TextDirection.ltr:
        break;
      case TextDirection.rtl:
        children = children.reversed.toList();
        highlightedIndex = widget.segments.length - highlightedIndex - 1;
    }

    return UnconstrainedBox(
      constrainedAxis: Axis.horizontal,
      child: AnimatedBuilder(
        animation: _thumbScaleAnimation,
        builder: (BuildContext context, Widget? child) {
          return _SegmentedSelectorRenderWidget<T>(
            highlightedIndex: highlightedIndex,
            thumbColor: theme.surfaceSecondary,
            thumbScale: _thumbScaleAnimation.value,
            state: this,
            children: children,
          );
        },
      ),
    );
  }
}

class _SegmentedSelectorRenderWidget<T extends Object>
    extends MultiChildRenderObjectWidget {
  const _SegmentedSelectorRenderWidget({
    required super.children,
    required this.highlightedIndex,
    required this.thumbColor,
    required this.thumbScale,
    required this.state,
    super.key,
  });

  final int highlightedIndex;
  final Color thumbColor;
  final double thumbScale;
  final _SegmentedSelectorState<T> state;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderSegmentedSelector<T>(
      highlightedIndex: highlightedIndex,
      thumbColor: thumbColor,
      thumbScale: thumbScale,
      state: state,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSegmentedSelector<T> renderObject,
  ) {
    renderObject
      ..highlightedIndex = highlightedIndex
      ..thumbColor = thumbColor
      ..thumbScale = thumbScale;
  }
}

class _SegmentedSelectorParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderSegmentedSelector<T extends Object> extends RenderBox
    with
        ContainerRenderObjectMixin<
          RenderBox,
          ContainerBoxParentData<RenderBox>
        >,
        RenderBoxContainerDefaultsMixin<
          RenderBox,
          ContainerBoxParentData<RenderBox>
        > {
  _RenderSegmentedSelector({
    required int highlightedIndex,
    required Color thumbColor,
    required double thumbScale,
    required this.state,
  }) : _highlightedIndex = highlightedIndex,
       _thumbColor = thumbColor,
       _thumbScale = thumbScale;

  final _SegmentedSelectorState<T> state;

  // The current **Unscaled** Thumb Rect in this RenderBox's coordinate space.
  Rect? currentThumbRect;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    state._thumbController.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    state._thumbController.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  int get highlightedIndex => _highlightedIndex;
  int _highlightedIndex;
  set highlightedIndex(int value) {
    if (_highlightedIndex == value) {
      return;
    }
    _highlightedIndex = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbColor;
  Color _thumbColor;
  set thumbColor(Color value) {
    if (_thumbColor == value) {
      return;
    }
    _thumbColor = value;
    markNeedsPaint();
  }

  double get thumbScale => _thumbScale;
  double _thumbScale;
  set thumbScale(double value) {
    if (_thumbScale == value) {
      return;
    }
    _thumbScale = value;
    markNeedsPaint();
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry), '');

    // No gesture should interfere with an ongoing thumb drag.
    if (event is PointerDownEvent && !state._isThumbDragging) {
      state._tap.addPointer(event);
      state._longPress.addPointer(event);
      state._drag.addPointer(event);
    }
  }

  // Intrinsic Dimensions

  double get totalSeparatorWidth => _kSeparatorWidth * (childCount ~/ 2);

  RenderBox? nonSeparatorChildAfter(RenderBox child) {
    final nextChild = childAfter(child);
    return nextChild == null ? null : childAfter(nextChild);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final childCount = this.childCount ~/ 2 + 1;

    var child = firstChild;
    var maxMinChildWidth = 0.0;

    while (child != null) {
      final childWidth = child.getMinIntrinsicWidth(height);
      maxMinChildWidth = math.max(maxMinChildWidth, childWidth);
      child = nonSeparatorChildAfter(child);
    }

    return maxMinChildWidth * childCount + totalSeparatorWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final childCount = this.childCount ~/ 2 + 1;

    var child = firstChild;
    var maxMaxChildWidth = 0.0;

    while (child != null) {
      final childWidth = child.getMaxIntrinsicWidth(height);
      maxMaxChildWidth = math.max(maxMaxChildWidth, childWidth);
      child = nonSeparatorChildAfter(child);
    }

    return maxMaxChildWidth * childCount + totalSeparatorWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    var child = firstChild;
    var maxMinChildHeight = 0.0;

    while (child != null) {
      final childHeight = child.getMinIntrinsicHeight(width);
      maxMinChildHeight = math.max(maxMinChildHeight, childHeight);
      child = nonSeparatorChildAfter(child);
    }

    return maxMinChildHeight;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    var child = firstChild;
    var maxMaxChildHeight = 0.0;

    while (child != null) {
      final childHeight = child.getMaxIntrinsicHeight(width);
      maxMaxChildHeight = math.max(maxMaxChildHeight, childHeight);
      child = nonSeparatorChildAfter(child);
    }

    return maxMaxChildHeight;
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _SegmentedSelectorParentData) {
      child.parentData = _SegmentedSelectorParentData();
    }
  }

  Size _calculateChildSize(BoxConstraints constraints) {
    final childCount = this.childCount ~/ 2 + 1;
    final separatorsCount = childCount - 1;

    var childWidth =
        (constraints.minWidth - totalSeparatorWidth * separatorsCount) /
        childCount;
    var maxHeight = 0.0;

    var child = firstChild;

    while (child != null) {
      childWidth = math.max(
        childWidth,
        child.getMaxIntrinsicWidth(double.infinity),
      );

      child = nonSeparatorChildAfter(child);
    }

    childWidth = math.min(
      childWidth,
      (constraints.maxWidth - totalSeparatorWidth * separatorsCount) /
          childCount,
    );

    child = firstChild;

    while (child != null) {
      final boxHeight = child.getMaxIntrinsicHeight(childWidth);
      maxHeight = math.max(maxHeight, boxHeight);
      child = nonSeparatorChildAfter(child);
    }

    return Size(childWidth, maxHeight);
  }

  Size _computeOverallSizeFromChildSize(
    Size childSize,
    BoxConstraints constraints,
  ) {
    final childCount = this.childCount ~/ 2 + 1;

    return constraints.constrain(
      Size(
        childSize.width * childCount + totalSeparatorWidth,
        childSize.height,
      ),
    );
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final childSize = _calculateChildSize(constraints);
    return _computeOverallSizeFromChildSize(childSize, constraints);
  }

  @override
  void performLayout() {
    final constraints = this.constraints;
    final childSize = _calculateChildSize(constraints);
    final childConstraints = BoxConstraints.tight(childSize);
    final separatorConstraints = childConstraints.heightConstraints();

    var child = firstChild;
    var index = 0;
    var start = 0.0;

    while (child != null) {
      child.layout(
        index.isEven ? childConstraints : separatorConstraints,
        parentUsesSize: true,
      );

      final childParentData = child.parentData! as _SegmentedSelectorParentData;
      final childOffset = Offset(start, 0);

      childParentData.offset = childOffset;
      start += child.size.width;

      // coverage:ignore-start
      assert(
        index.isEven || child.size.width == _kSeparatorWidth,
        '${child.size.width} != $_kSeparatorWidth',
      );
      // coverage:ignore-end

      child = childAfter(child);
      index += 1;
    }

    size = _computeOverallSizeFromChildSize(childSize, constraints);
  }

  // This method is used to convert the original unscaled thumb rect painted in
  // the previous frame, to a Rect that is within the valid boundary defined by
  // the child segments.
  Rect? moveThumbRectInBound(Rect? thumbRect, List<RenderBox> children) {
    if (thumbRect == null) {
      return null;
    }

    final firstChildOffset =
        (children.first.parentData! as _SegmentedSelectorParentData).offset;
    final leftMost = firstChildOffset.dx;
    final rightMost =
        (children.last.parentData! as _SegmentedSelectorParentData).offset.dx +
        children.last.size.width;

    // Ignore the horizontal position and the height of `thumbRect`, and
    // calculate them from `children`.
    return Rect.fromLTRB(
      math.max(thumbRect.left, leftMost),
      firstChildOffset.dy,
      math.min(thumbRect.right, rightMost),
      firstChildOffset.dy + children.first.size.height,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final children = getChildrenAsList();

    // Paint separators.
    for (var index = 1; index < childCount; index += 2) {
      final child = children[index];
      final childParentData = child.parentData! as _SegmentedSelectorParentData;
      context.paintChild(child, offset + childParentData.offset);
    }

    // Paint thumb under the highlighted segment.
    final selectedChild = children[highlightedIndex * 2];

    final childParentData =
        selectedChild.parentData! as _SegmentedSelectorParentData;

    final newThumbRect = childParentData.offset & selectedChild.size;

    // Update thumb animation's tween, in case the end rect changed (e.g., a
    // new segment is added during the animation).
    if (state._thumbController.isAnimating) {
      final thumbTween = state._thumbAnimatable;

      if (thumbTween == null) {
        // This is the first frame of the animation.
        final startingRect =
            moveThumbRectInBound(
              currentThumbRect,
              children,
            ) ??
            newThumbRect;

        state._thumbAnimatable = RectTween(
          begin: startingRect,
          end: newThumbRect,
        );
      }
    } else {
      state._thumbAnimatable = null;
    }

    final unscaledThumbRect =
        state._thumbAnimatable?.evaluate(state._thumbController) ??
        newThumbRect;

    currentThumbRect = unscaledThumbRect;

    final thumbRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: unscaledThumbRect.center,
        width: unscaledThumbRect.width * thumbScale,
        height: unscaledThumbRect.height * thumbScale,
      ).shift(offset),
      _kThumbRadius,
    );

    context.canvas.drawRRect(
      thumbRRect,
      Paint()..color = thumbColor,
    );

    // Paint segments.
    for (var index = 0; index < children.length; index += 2) {
      final child = children[index];
      final childParentData = child.parentData! as _SegmentedSelectorParentData;
      context.paintChild(child, offset + childParentData.offset);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    var child = lastChild;

    while (child != null) {
      final childParentData = child.parentData! as _SegmentedSelectorParentData;

      if ((childParentData.offset & child.size).contains(position)) {
        return result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset localOffset) {
            return child!.hitTest(result, position: localOffset);
          },
        );
      }

      child = childParentData.previousSibling;
    }

    return false;
  }
}
