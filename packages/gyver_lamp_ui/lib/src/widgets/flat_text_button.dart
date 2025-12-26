import 'package:flutter/material.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

// The corner radius of the button.
const _kBorderRadius = Radius.circular(8);

/// Represents the size of the [FlatTextButton].
enum FlatTextButtonSize {
  /// Represents a small size.
  small,

  /// Represents a medium size.
  medium,

  /// Represents a large size.
  large,
}

/// {@template flat_text_button}
/// Gyver Lamp Flat Text Button.
/// {@endtemplate}
class FlatTextButton extends StatelessWidget {
  /// {@macro flat_text_button}
  const FlatTextButton({
    required this.size,
    required this.child,
    required this.onPressed,
    super.key,
  });

  /// Small size [FlatTextButton].
  const FlatTextButton.small({
    required this.child,
    required this.onPressed,
    super.key,
  }) : size = FlatTextButtonSize.small;

  /// Medium size [FlatTextButton].
  const FlatTextButton.medium({
    required this.child,
    required this.onPressed,
    super.key,
  }) : size = FlatTextButtonSize.medium;

  /// Large size [FlatTextButton].
  const FlatTextButton.large({
    required this.child,
    required this.onPressed,
    super.key,
  }) : size = FlatTextButtonSize.large;

  /// The size of the button.
  final FlatTextButtonSize size;

  /// The child widget of the button.
  ///
  /// Typically the button's label (e.g. [Text] text).
  final Widget child;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// The height of the button.
  double get height => switch (size) {
    (FlatTextButtonSize.small) => 32,
    (FlatTextButtonSize.medium) => 40,
    (FlatTextButtonSize.large) => 48,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return RepaintBoundary(
      child: Container(
        height: height,
        decoration: const ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(_kBorderRadius),
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            splashFactory: InkRipple.splashFactory,
            borderRadius: const BorderRadius.all(_kBorderRadius),
            mouseCursor: onPressed == null
                ? SystemMouseCursors.basic
                : SystemMouseCursors.click,
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GyverLampSpacings.lg,
              ),
              child: DefaultTextStyle(
                style:
                    switch (size) {
                      (FlatTextButtonSize.small) =>
                        GyverLampTextStyles.buttonSmallBold,
                      (FlatTextButtonSize.medium) =>
                        GyverLampTextStyles.buttonMediumBold,
                      (FlatTextButtonSize.large) =>
                        GyverLampTextStyles.buttonLargeBold,
                    }.copyWith(
                      color: onPressed != null
                          ? theme.textSecondary
                          : theme.textSecondary.withValues(alpha: 0.5),
                    ),
                overflow: TextOverflow.ellipsis,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: child,
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
