import 'package:flutter/material.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

// The corner radius of the button.
const _kBorderRadius = Radius.circular(8);

/// Represents the size of the [RoundedOutlinedButton].
enum RoundedOutlinedButtonSize {
  /// Represents a small size.
  small,

  /// Represents a medium size.
  medium,

  /// Represents a large size.
  large,
}

/// {@template rounded_outlined_button}
/// Gyver Lamp Rounded Outlined Button.
/// {@endtemplate}
class RoundedOutlinedButton extends StatefulWidget {
  /// {@macro rounded_outlined_button}
  const RoundedOutlinedButton({
    required this.size,
    required this.child,
    required this.onPressed,
    super.key,
  });

  /// Small size [RoundedOutlinedButton].
  const RoundedOutlinedButton.small({
    required this.child,
    required this.onPressed,
    super.key,
  }) : size = RoundedOutlinedButtonSize.small;

  /// Medium size [RoundedOutlinedButton].
  const RoundedOutlinedButton.medium({
    required this.child,
    required this.onPressed,
    super.key,
  }) : size = RoundedOutlinedButtonSize.medium;

  /// Large size [RoundedOutlinedButton].
  const RoundedOutlinedButton.large({
    required this.child,
    required this.onPressed,
    super.key,
  }) : size = RoundedOutlinedButtonSize.large;

  /// The size of the button.
  final RoundedOutlinedButtonSize size;

  /// The child widget of the button.
  ///
  /// Typically the button's label (e.g. [Text] widget).
  final Widget child;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// The height of the button.
  double get height => switch (size) {
    (RoundedOutlinedButtonSize.small) => 32,
    (RoundedOutlinedButtonSize.medium) => 40,
    (RoundedOutlinedButtonSize.large) => 48,
  };

  @override
  State<RoundedOutlinedButton> createState() => RoundedOutlinedButtonState();
}

/// Gyver Lamp Rounded Outlined Button state.
class RoundedOutlinedButtonState extends State<RoundedOutlinedButton> {
  /// Whether the button is pressed.
  @visibleForTesting
  bool isPressed = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return RepaintBoundary(
      child: SizedBox(
        height: widget.height,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(_kBorderRadius),
              side: BorderSide(color: theme.textSecondary),
            ),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
              borderRadius: const BorderRadius.all(_kBorderRadius),
              mouseCursor: widget.onPressed == null
                  ? SystemMouseCursors.basic
                  : SystemMouseCursors.click,
              onTap: widget.onPressed,
              onTapDown: widget.onPressed == null
                  ? null
                  : (_) => setState(() => isPressed = true),
              onTapUp: widget.onPressed == null
                  ? null
                  : (_) => setState(() => isPressed = false),
              onTapCancel: widget.onPressed == null
                  ? null
                  : () => setState(() => isPressed = false),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: GyverLampSpacings.lg,
                ),
                child: DefaultTextStyle(
                  style:
                      switch (widget.size) {
                        (RoundedOutlinedButtonSize.small) =>
                          GyverLampTextStyles.buttonSmallBold,
                        (RoundedOutlinedButtonSize.medium) =>
                          GyverLampTextStyles.buttonMediumBold,
                        (RoundedOutlinedButtonSize.large) =>
                          GyverLampTextStyles.buttonLargeBold,
                      }.copyWith(
                        color: widget.onPressed != null
                            ? theme.textSecondary
                            : theme.textSecondary.withValues(alpha: 0.5),
                      ),
                  overflow: TextOverflow.ellipsis,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: widget.child,
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
