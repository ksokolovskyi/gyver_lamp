import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:tactile_feedback/tactile_feedback.dart';

// The height of the track.
const double _kTrackHeight = 32;

// The width of the track.
const double _kTrackWidth = 52;

// The radius of the thumb in idle state.
const double _kThumbRadius = 6;

// The radius of the thumb in pressed state.
const double _kPressedThumbRadius = 8;

// The radius of the splash when thumb is hovered, focused.
const double _kSplashRadius = 12;

// The duration of the toggle animation.
const Duration _kToggleDuration = Duration(milliseconds: 150);

// The minimum size of the switch.
const double _kSwitchMinSize = kMinInteractiveDimension - 8.0;

// The height of the switch.
const double _kSwitchHeight = kMinInteractiveDimension;

// The width of the switch.
const double _kSwitchWidth = _kTrackWidth - _kTrackHeight + _kSwitchMinSize;

// The size of the switch.
const Size _kSwitchSize = Size(_kSwitchWidth, _kSwitchHeight);

/// {@template switcher}
/// Gyver Lamp Switcher.
/// {@endtemplate}
class Switcher extends StatefulWidget {
  /// {@macro switcher}
  const Switcher({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// The value of the switcher.
  final bool value;

  /// The callback that is called when the switcher value changes.
  final ValueChanged<bool> onChanged;

  @override
  State<StatefulWidget> createState() => SwitcherState();

  // coverage:ignore-start
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      FlagProperty(
        'value',
        value: value,
        ifTrue: 'on',
        ifFalse: 'off',
        showName: true,
      ),
    );
  }
  // coverage:ignore-end
}

/// Gyver Lamp Switcher state.
class SwitcherState extends State<Switcher>
    with TickerProviderStateMixin, ToggleableStateMixin {
  final _SwitchPainter _painter = _SwitchPainter();

  bool _needsPositionAnimation = false;

  late bool _feedbackValue = widget.value;

  @override
  void didUpdateWidget(Switcher oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      // During a drag we may have modified the curve, reset it if its possible
      // to do without visual discontinuation.
      if (position.value == 0.0 || position.value == 1.0) {
        position
          ..curve = Curves.easeIn
          ..reverseCurve = Curves.easeOut;
      }

      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?> get onChanged => _handleChanged;

  @override
  bool get tristate => false;

  @override
  bool? get value => widget.value;

  double get _trackInnerLength => _kSwitchSize.width - _kSwitchMinSize;

  void _handleDragStart(DragStartDetails details) {
    reactionController.forward();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    position
      ..curve = Curves.linear
      ..reverseCurve = null;

    final delta = details.primaryDelta! / _trackInnerLength;

    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        positionController.value -= delta;
      case TextDirection.ltr:
        positionController.value += delta;
    }

    _handleFeedback(position.value >= 0.5);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (position.value >= 0.5 != widget.value) {
      widget.onChanged(!widget.value);
      // Wait with finishing the animation until widget.value has changed to
      // !widget.value as part of the widget.onChanged call above.
      setState(() {
        _needsPositionAnimation = true;
      });
    } else {
      animateToValue();
    }

    reactionController.reverse();
  }

  void _handleChanged(bool? value) {
    assert(
      value != null,
      'value can not be null',
    );

    widget.onChanged(value!);
    _handleFeedback(value);
  }

  void _handleFeedback(bool value) {
    if (_feedbackValue == value) {
      return;
    }

    _feedbackValue = value;

    TactileFeedback.impact();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsPositionAnimation) {
      _needsPositionAnimation = false;
      animateToValue();
    }

    positionController.duration = _kToggleDuration;

    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;
    final textDirection = Directionality.of(context);

    final splashColor = widget.value
        ? theme.background.withOpacity(0.1)
        : theme.textSecondary.withOpacity(0.1);

    return RepaintBoundary(
      child: Semantics(
        toggled: widget.value,
        child: GestureDetector(
          excludeFromSemantics: true,
          onHorizontalDragStart: _handleDragStart,
          onHorizontalDragUpdate: _handleDragUpdate,
          onHorizontalDragEnd: _handleDragEnd,
          child: buildToggleable(
            size: _kSwitchSize,
            mouseCursor: MaterialStateProperty.resolveWith<MouseCursor>(
              (states) {
                return MaterialStateProperty.resolveAs<MouseCursor>(
                  MaterialStateMouseCursor.clickable,
                  states,
                );
              },
            ),
            painter: _painter
              ..trackHeight = _kTrackHeight
              ..trackWidth = _kTrackWidth
              ..trackInnerLength = _trackInnerLength
              ..thumbRadius = _kThumbRadius
              ..pressedThumbRadius = _kPressedThumbRadius
              ..activeColor = theme.background
              ..activePressedColor = theme.background
              ..inactiveColor = theme.textSecondary
              ..inactivePressedColor = theme.textSecondary
              ..hoverColor = splashColor
              ..focusColor = splashColor
              ..splashRadius = _kSplashRadius
              ..activeTrackColor = theme.onBackground
              ..inactiveTrackColor = theme.surfaceVariant
              ..inactiveReactionColor = Colors.transparent
              ..reactionColor = Colors.transparent
              ..isFocused = states.contains(MaterialState.focused)
              ..isHovered = states.contains(MaterialState.hovered)
              ..position = position
              ..positionController = positionController
              ..downPosition = downPosition
              ..reaction = reaction
              ..reactionFocusFade = reactionFocusFade
              ..reactionHoverFade = reactionHoverFade
              ..textDirection = textDirection,
          ),
        ),
      ),
    );
  }
}

class _SwitchPainter extends ToggleablePainter {
  AnimationController get positionController => _positionController!;
  AnimationController? _positionController;
  set positionController(AnimationController value) {
    if (value == _positionController) {
      return;
    }
    _positionController = value;
    notifyListeners();
  }

  Color get activePressedColor => _activePressedColor!;
  Color? _activePressedColor;
  set activePressedColor(Color value) {
    if (value == _activePressedColor) {
      return;
    }
    _activePressedColor = value;
    notifyListeners();
  }

  Color get inactivePressedColor => _inactivePressedColor!;
  Color? _inactivePressedColor;
  set inactivePressedColor(Color value) {
    if (value == _inactivePressedColor) {
      return;
    }
    _inactivePressedColor = value;
    notifyListeners();
  }

  double get thumbRadius => _thumbRadius!;
  double? _thumbRadius;
  set thumbRadius(double value) {
    if (value == _thumbRadius) {
      return;
    }
    _thumbRadius = value;
    notifyListeners();
  }

  double get pressedThumbRadius => _pressedThumbRadius!;
  double? _pressedThumbRadius;
  set pressedThumbRadius(double value) {
    if (value == _pressedThumbRadius) {
      return;
    }
    _pressedThumbRadius = value;
    notifyListeners();
  }

  double get trackHeight => _trackHeight!;
  double? _trackHeight;
  set trackHeight(double value) {
    if (value == _trackHeight) {
      return;
    }
    _trackHeight = value;
    notifyListeners();
  }

  double get trackWidth => _trackWidth!;
  double? _trackWidth;
  set trackWidth(double value) {
    if (value == _trackWidth) {
      return;
    }
    _trackWidth = value;
    notifyListeners();
  }

  Color get activeTrackColor => _activeTrackColor!;
  Color? _activeTrackColor;
  set activeTrackColor(Color value) {
    if (value == _activeTrackColor) {
      return;
    }
    _activeTrackColor = value;
    notifyListeners();
  }

  Color get inactiveTrackColor => _inactiveTrackColor!;
  Color? _inactiveTrackColor;
  set inactiveTrackColor(Color value) {
    if (value == _inactiveTrackColor) {
      return;
    }
    _inactiveTrackColor = value;
    notifyListeners();
  }

  TextDirection get textDirection => _textDirection!;
  TextDirection? _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    notifyListeners();
  }

  double get trackInnerLength => _trackInnerLength!;
  double? _trackInnerLength;
  set trackInnerLength(double value) {
    if (value == _trackInnerLength) {
      return;
    }
    _trackInnerLength = value;
    notifyListeners();
  }

  bool _stopPressAnimation = false;
  double? _pressedInactiveThumbRadius;
  double? _pressedActiveThumbRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final currentValue = position.value;

    final double visualPosition;

    switch (textDirection) {
      case TextDirection.rtl:
        visualPosition = 1.0 - currentValue;
      case TextDirection.ltr:
        visualPosition = currentValue;
    }

    if (reaction.status == AnimationStatus.reverse && !_stopPressAnimation) {
      _stopPressAnimation = true;
    } else {
      _stopPressAnimation = false;
    }

    // To get the thumb radius when the press ends, the value can be any number
    // between thumbRadius and pressedThumbRadius.
    if (!_stopPressAnimation) {
      if (currentValue == 0) {
        _pressedInactiveThumbRadius = lerpDouble(
          thumbRadius,
          pressedThumbRadius,
          reaction.value,
        );
        _pressedActiveThumbRadius = thumbRadius;
      } else if (currentValue == 1) {
        _pressedActiveThumbRadius = lerpDouble(
          thumbRadius,
          pressedThumbRadius,
          reaction.value,
        );
        _pressedInactiveThumbRadius = thumbRadius;
      }
    }

    final inactiveThumbSize = Size.fromRadius(
      _pressedInactiveThumbRadius ?? thumbRadius,
    );
    final activeThumbSize = Size.fromRadius(
      _pressedActiveThumbRadius ?? thumbRadius,
    );

    final Size thumbSize;

    if (reaction.isCompleted) {
      thumbSize = Size.fromRadius(pressedThumbRadius);
    } else {
      thumbSize = Tween<Size>(
        begin: inactiveThumbSize,
        end: activeThumbSize,
      )
          .chain(CurveTween(curve: Curves.easeInOut))
          .animate(positionController)
          .value;
    }

    final positionValue = CurvedAnimation(
      parent: positionController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ).value;

    final trackColor = Color.lerp(
      inactiveTrackColor,
      activeTrackColor,
      positionValue,
    )!;

    final Color lerpedThumbColor;

    if (!reaction.isDismissed) {
      lerpedThumbColor = Color.lerp(
        inactivePressedColor,
        activePressedColor,
        positionValue,
      )!;
    } else if (positionController.status == AnimationStatus.forward) {
      lerpedThumbColor = Color.lerp(
        inactivePressedColor,
        activeColor,
        positionValue,
      )!;
    } else if (positionController.status == AnimationStatus.reverse) {
      lerpedThumbColor = Color.lerp(
        inactiveColor,
        activePressedColor,
        positionValue,
      )!;
    } else {
      lerpedThumbColor = Color.lerp(
        inactiveColor,
        activeColor,
        positionValue,
      )!;
    }

    final thumbColor = lerpedThumbColor;

    final trackPaintOffset = _computeTrackPaintOffset(
      size,
      trackWidth,
      trackHeight,
    );

    final thumbPaintOffset = _computeThumbPaintOffset(
      trackPaintOffset,
      thumbSize,
      visualPosition,
    );

    final radialReactionOrigin = Offset(
      thumbPaintOffset.dx + thumbSize.height / 2,
      size.height / 2,
    );

    _paintTrack(
      canvas,
      trackPaintOffset,
      trackColor,
      Size(trackWidth, trackHeight),
    );

    paintRadialReaction(
      canvas: canvas,
      origin: radialReactionOrigin,
    );

    _paintThumb(
      canvas,
      thumbPaintOffset,
      thumbColor,
      thumbSize,
    );
  }

  /// Computes canvas offset for track's upper left corner.
  Offset _computeTrackPaintOffset(
    Size canvasSize,
    double trackWidth,
    double trackHeight,
  ) {
    final horizontalOffset = (canvasSize.width - trackWidth) / 2.0;
    final verticalOffset = (canvasSize.height - trackHeight) / 2.0;

    return Offset(horizontalOffset, verticalOffset);
  }

  /// Computes canvas offset for thumb's upper left corner.
  Offset _computeThumbPaintOffset(
    Offset trackPaintOffset,
    Size thumbSize,
    double visualPosition,
  ) {
    // How much thumb radius extends beyond the track.
    final trackRadius = trackHeight / 2;
    final additionalThumbRadius = thumbSize.height / 2 - trackRadius;
    final additionalRectWidth = (thumbSize.width - thumbSize.height) / 2;

    final horizontalProgress = visualPosition * trackInnerLength;
    final thumbHorizontalOffset = trackPaintOffset.dx -
        additionalThumbRadius -
        additionalRectWidth +
        horizontalProgress;
    final thumbVerticalOffset = trackPaintOffset.dy - additionalThumbRadius;

    return Offset(thumbHorizontalOffset, thumbVerticalOffset);
  }

  void _paintTrack(
    Canvas canvas,
    Offset offset,
    Color color,
    Size size,
  ) {
    final trackRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      trackWidth,
      trackHeight,
    );

    final trackRadius = trackHeight / 2;

    final trackRRect = RRect.fromRectAndRadius(
      trackRect,
      Radius.circular(trackRadius),
    );

    canvas.drawRRect(
      trackRRect,
      Paint()..color = color,
    );
  }

  void _paintThumb(
    Canvas canvas,
    Offset offset,
    Color color,
    Size size,
  ) {
    final thumbRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      size.width,
      size.height,
    );

    final thumbRadius = size.height / 2;

    final thumbRRect = RRect.fromRectAndRadius(
      thumbRect,
      Radius.circular(thumbRadius),
    );

    canvas.drawRRect(
      thumbRRect,
      Paint()..color = color,
    );
  }
}
