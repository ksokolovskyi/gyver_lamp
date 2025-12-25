import 'package:flutter/material.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

// The corner radius of the button.
const _kBorderRadius = Radius.circular(8);

/// Represents the size of the [RoundedElevatedButton].
enum RoundedElevatedButtonSize {
  /// Represents a small size.
  small,

  /// Represents a medium size.
  medium,

  /// Represents a large size.
  large,
}

/// {@template rounded_elevated_button}
/// Gyver Lamp Rounded Elevated Button.
/// {@endtemplate}
class RoundedElevatedButton extends StatefulWidget {
  /// {@macro rounded_elevated_button}
  const RoundedElevatedButton({
    required this.size,
    required this.child,
    required this.onPressed,
    super.key,
  });

  /// Small size [RoundedElevatedButton].
  const RoundedElevatedButton.small({
    required this.child,
    required this.onPressed,
    super.key,
  }) : size = RoundedElevatedButtonSize.small;

  /// Medium size [RoundedElevatedButton].
  const RoundedElevatedButton.medium({
    required this.child,
    required this.onPressed,
    super.key,
  }) : size = RoundedElevatedButtonSize.medium;

  /// Large size [RoundedElevatedButton].
  const RoundedElevatedButton.large({
    required this.child,
    required this.onPressed,
    super.key,
  }) : size = RoundedElevatedButtonSize.large;

  /// The size of the button.
  final RoundedElevatedButtonSize size;

  /// The child widget of the button.
  ///
  /// Typically the button's label (e.g. [Text] text).
  final Widget child;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// The height of the button.
  double get height => switch (size) {
    (RoundedElevatedButtonSize.small) => 32,
    (RoundedElevatedButtonSize.medium) => 40,
    (RoundedElevatedButtonSize.large) => 48,
  };

  @override
  State<RoundedElevatedButton> createState() => RoundedElevatedButtonState();
}

/// Gyver Lamp Rounded Elevated Button state.
class RoundedElevatedButtonState extends State<RoundedElevatedButton> {
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
      child: AnimatedContainer(
        height: widget.height,
        duration: const Duration(milliseconds: 250),
        decoration: ShapeDecoration(
          color: widget.onPressed != null
              ? theme.onBackground
              : theme.buttonDisabled,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(_kBorderRadius),
          ),
          shadows: [
            if (widget.onPressed != null && !isPressed) theme.shadows.shadow2,
          ],
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
                      (RoundedElevatedButtonSize.small) =>
                        GyverLampTextStyles.buttonSmallBold,
                      (RoundedElevatedButtonSize.medium) =>
                        GyverLampTextStyles.buttonMediumBold,
                      (RoundedElevatedButtonSize.large) =>
                        GyverLampTextStyles.buttonLargeBold,
                    }.copyWith(
                      color: widget.onPressed != null
                          ? theme.background
                          : theme.textButtonDisabled,
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
    );
  }
}
