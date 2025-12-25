import 'package:flutter/material.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

/// Represents the size of the [FlatIconButton].
enum FlatIconButtonSize {
  /// Represents a medium size.
  medium,

  /// Represents a large size.
  large,
}

/// {@template flat_icon_button}
/// Gyver Lamp Flat Icon Button.
/// {@endtemplate}
class FlatIconButton extends StatelessWidget {
  /// {@macro flat_icon_button}
  const FlatIconButton({
    required this.size,
    required this.icon,
    required this.onPressed,
    this.color,
    super.key,
  });

  /// Medium size [FlatIconButton].
  const FlatIconButton.medium({
    required this.icon,
    required this.onPressed,
    this.color,
    super.key,
  }) : size = FlatIconButtonSize.medium;

  /// Large size [FlatIconButton].
  const FlatIconButton.large({
    required this.icon,
    required this.onPressed,
    this.color,
    super.key,
  }) : size = FlatIconButtonSize.large;

  /// The size of the button.
  final FlatIconButtonSize size;

  /// The icon of the button.
  final IconData icon;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// The color of the button.
  final Color? color;

  /// Length of the button's side.
  double get dimension => switch (size) {
    FlatIconButtonSize.medium => 32,
    FlatIconButtonSize.large => 44,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return RepaintBoundary(
      child: SizedBox.square(
        dimension: dimension,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: color ?? theme.surfacePrimary,
            shape: const CircleBorder(),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
              customBorder: const CircleBorder(),
              mouseCursor: onPressed == null
                  ? SystemMouseCursors.basic
                  : SystemMouseCursors.click,
              onTap: onPressed,
              child: Center(
                child: Icon(
                  icon,
                  size: switch (size) {
                    (FlatIconButtonSize.medium) => 24,
                    (FlatIconButtonSize.large) => 16,
                  },
                  color: onPressed == null
                      ? theme.textSecondary.withOpacity(0.5)
                      : theme.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
