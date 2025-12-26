import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gyver_lamp_ui/src/theme/theme.dart';

/// {@template gyver_lamp_theme}
/// Gyver Lamp Theme.
/// {@endtemplate}
abstract class GyverLampTheme {
  /// Light [ThemeData] for Gyver Lamp.
  static ThemeData get lightThemeData {
    return ThemeData(
      useMaterial3: false,
      colorScheme: const ColorScheme.light().copyWith(
        surface: GyverLampColors.lightSurfacePrimary,
      ),
      scaffoldBackgroundColor: GyverLampColors.lightBackground,
      textTheme: GyverLampTextStyles.textTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: WidgetStateInputBorder.resolveWith(
          (states) {
            if (states.contains(WidgetState.focused)) {
              return const OutlineInputBorder(
                borderSide: BorderSide(
                  color: GyverLampColors.lightBorderInput,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              );
            }

            return const OutlineInputBorder(
              borderSide: BorderSide(
                width: 0.5,
                color: GyverLampColors.lightBorderPrimary,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            );
          },
        ),
        hoverColor: Colors.transparent,
        constraints: const BoxConstraints.tightFor(height: 42),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: GyverLampSpacings.md,
        ),
        filled: true,
        fillColor: GyverLampColors.lightSurfacePrimary,
        hintStyle: GyverLampTextStyles.body2.copyWith(
          color: GyverLampColors.lightTextSecondary.withValues(alpha: 0.5),
        ),
        suffixIconColor: GyverLampColors.lightTextSecondary,
      ),
      dividerTheme: const DividerThemeData(
        color: GyverLampColors.lightDivider,
        thickness: 2,
        space: 2,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: GyverLampColors.lightSelectionBackground,
        selectionHandleColor: GyverLampColors.lightSelectionHandle,
        cursorColor: GyverLampColors.lightTextPrimary,
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(
        // this color will be used as selectionHandleColor on iOS
        primaryColor: GyverLampColors.lightSelectionHandle,
      ),
      extensions: const [
        GyverLampAppTheme(
          background: GyverLampColors.lightBackground,
          onBackground: GyverLampColors.lightOnBackground,
          surfacePrimary: GyverLampColors.lightSurfacePrimary,
          surfaceSecondary: GyverLampColors.lightSurfaceSecondary,
          surfaceVariant: GyverLampColors.lightSurfaceVariant,
          borderPrimary: GyverLampColors.lightBorderPrimary,
          borderInput: GyverLampColors.lightBorderInput,
          textPrimary: GyverLampColors.lightTextPrimary,
          textSecondary: GyverLampColors.lightTextSecondary,
          pointer: GyverLampColors.lightPointer,
          connectedBackground: GyverLampColors.lightConnectedBackground,
          connectedText: GyverLampColors.lightConnectedText,
          connectingBackground: GyverLampColors.lightConnectingBackground,
          connectingText: GyverLampColors.lightConnectingText,
          notConnectedBackground: GyverLampColors.lightNotConnectedBackground,
          notConnectedText: GyverLampColors.lightNotConnectedText,
          divider: GyverLampColors.lightDivider,
          buttonDisabled: GyverLampColors.lightButtonDisabled,
          textButtonDisabled: GyverLampColors.lightTextButtonDisabled,
          selectionBackground: GyverLampColors.lightSelectionBackground,
          selectionHandle: GyverLampColors.lightSelectionHandle,
          shadows: GyverLampShadows.light,
        ),
      ],
    );
  }

  /// Dark [ThemeData] for Gyver Lamp.
  static ThemeData get darkThemeData {
    return ThemeData(
      useMaterial3: false,
      colorScheme: const ColorScheme.dark().copyWith(
        surface: GyverLampColors.darkSurfacePrimary,
      ),
      scaffoldBackgroundColor: GyverLampColors.darkBackground,
      textTheme: GyverLampTextStyles.textTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: WidgetStateInputBorder.resolveWith(
          (states) {
            if (states.contains(WidgetState.focused)) {
              return const OutlineInputBorder(
                borderSide: BorderSide(
                  color: GyverLampColors.darkBorderInput,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              );
            }

            return const OutlineInputBorder(
              borderSide: BorderSide(
                width: 0.5,
                color: GyverLampColors.darkBorderPrimary,
              ),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            );
          },
        ),
        hoverColor: Colors.transparent,
        constraints: const BoxConstraints.tightFor(height: 42),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: GyverLampSpacings.md,
        ),
        filled: true,
        fillColor: GyverLampColors.darkSurfacePrimary,
        hintStyle: GyverLampTextStyles.body2.copyWith(
          color: GyverLampColors.darkTextSecondary.withValues(alpha: 0.5),
        ),
        suffixIconColor: GyverLampColors.darkTextSecondary,
      ),
      dividerTheme: const DividerThemeData(
        color: GyverLampColors.darkDivider,
        thickness: 1,
        space: 1,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: GyverLampColors.darkSelectionBackground,
        selectionHandleColor: GyverLampColors.darkSelectionHandle,
        cursorColor: GyverLampColors.darkTextPrimary,
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(
        // this color will be used as selectionHandleColor on iOS
        primaryColor: GyverLampColors.darkSelectionHandle,
      ),
      extensions: const [
        GyverLampAppTheme(
          background: GyverLampColors.darkBackground,
          onBackground: GyverLampColors.darkOnBackground,
          surfacePrimary: GyverLampColors.darkSurfacePrimary,
          surfaceSecondary: GyverLampColors.darkSurfaceSecondary,
          surfaceVariant: GyverLampColors.darkSurfaceVariant,
          borderPrimary: GyverLampColors.darkBorderPrimary,
          borderInput: GyverLampColors.darkBorderInput,
          textPrimary: GyverLampColors.darkTextPrimary,
          textSecondary: GyverLampColors.darkTextSecondary,
          pointer: GyverLampColors.darkPointer,
          connectedBackground: GyverLampColors.darkConnectedBackground,
          connectedText: GyverLampColors.darkConnectedText,
          connectingBackground: GyverLampColors.darkConnectingBackground,
          connectingText: GyverLampColors.darkConnectingText,
          notConnectedBackground: GyverLampColors.darkNotConnectedBackground,
          notConnectedText: GyverLampColors.darkNotConnectedText,
          divider: GyverLampColors.darkDivider,
          buttonDisabled: GyverLampColors.darkButtonDisabled,
          textButtonDisabled: GyverLampColors.darkTextButtonDisabled,
          selectionBackground: GyverLampColors.darkSelectionBackground,
          selectionHandle: GyverLampColors.darkSelectionHandle,
          shadows: GyverLampShadows.dark,
        ),
      ],
    );
  }
}

/// {@template gyver_lamp_app_theme}
/// Theme extension to hold specific colors and shadows without brightness
/// mention.
/// {@endtemplate}
class GyverLampAppTheme extends ThemeExtension<GyverLampAppTheme> {
  /// {@macro gyver_lamp_app_theme}
  const GyverLampAppTheme({
    required this.background,
    required this.onBackground,
    required this.surfacePrimary,
    required this.surfaceSecondary,
    required this.surfaceVariant,
    required this.borderPrimary,
    required this.borderInput,
    required this.textPrimary,
    required this.textSecondary,
    required this.pointer,
    required this.connectedBackground,
    required this.connectedText,
    required this.connectingBackground,
    required this.connectingText,
    required this.notConnectedBackground,
    required this.notConnectedText,
    required this.divider,
    required this.buttonDisabled,
    required this.textButtonDisabled,
    required this.selectionBackground,
    required this.selectionHandle,
    required this.shadows,
  });

  /// Background Color
  final Color background;

  /// On Background Color
  final Color onBackground;

  /// Surface Primary Color
  final Color surfacePrimary;

  /// Surface Secondary Color
  final Color surfaceSecondary;

  /// Surface Variant Color
  final Color surfaceVariant;

  /// Border Primary Color
  final Color borderPrimary;

  /// Border Input Color
  final Color borderInput;

  /// Text Primary Color
  final Color textPrimary;

  /// Text Secondary Color
  final Color textSecondary;

  /// Pointer Color
  final Color pointer;

  /// Connected Background Color
  final Color connectedBackground;

  /// Connected Text Color
  final Color connectedText;

  /// Connecting Background Color
  final Color connectingBackground;

  /// Connecting Text Color
  final Color connectingText;

  /// Not Connected Background Color
  final Color notConnectedBackground;

  /// Not Connected Text Color
  final Color notConnectedText;

  /// Divider Color
  final Color divider;

  /// Button Disabled Color
  final Color buttonDisabled;

  /// Text Button Disabled Color
  final Color textButtonDisabled;

  /// Selection Background Color
  final Color selectionBackground;

  /// Selection Handle Color
  final Color selectionHandle;

  /// Shadows
  final GyverLampShadows shadows;

  @override
  GyverLampAppTheme copyWith({
    Color? background,
    Color? onBackground,
    Color? surfacePrimary,
    Color? surfaceSecondary,
    Color? surfaceVariant,
    Color? borderPrimary,
    Color? borderInput,
    Color? textPrimary,
    Color? textSecondary,
    Color? pointer,
    Color? connectedBackground,
    Color? connectedText,
    Color? connectingBackground,
    Color? connectingText,
    Color? notConnectedBackground,
    Color? notConnectedText,
    Color? divider,
    Color? buttonDisabled,
    Color? textButtonDisabled,
    Color? selectionBackground,
    Color? selectionHandle,
    GyverLampShadows? shadows,
  }) {
    return GyverLampAppTheme(
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surfacePrimary: surfacePrimary ?? this.surfacePrimary,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      borderPrimary: borderPrimary ?? this.borderPrimary,
      borderInput: borderInput ?? this.borderInput,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      pointer: pointer ?? this.pointer,
      connectedBackground: connectedBackground ?? this.connectedBackground,
      connectedText: connectedText ?? this.connectedText,
      connectingBackground: connectingBackground ?? this.connectingBackground,
      connectingText: connectingText ?? this.connectingText,
      notConnectedBackground:
          notConnectedBackground ?? this.notConnectedBackground,
      notConnectedText: notConnectedText ?? this.notConnectedText,
      divider: divider ?? this.divider,
      buttonDisabled: buttonDisabled ?? this.buttonDisabled,
      textButtonDisabled: textButtonDisabled ?? this.textButtonDisabled,
      selectionBackground: selectionBackground ?? this.selectionBackground,
      selectionHandle: selectionHandle ?? this.selectionHandle,
      shadows: shadows ?? this.shadows,
    );
  }

  @override
  GyverLampAppTheme lerp(GyverLampAppTheme? other, double t) {
    if (other is! GyverLampAppTheme) {
      return this;
    }

    return GyverLampAppTheme(
      background: Color.lerp(
        background,
        other.background,
        t,
      )!,
      onBackground: Color.lerp(
        onBackground,
        other.onBackground,
        t,
      )!,
      surfacePrimary: Color.lerp(
        surfacePrimary,
        other.surfacePrimary,
        t,
      )!,
      surfaceSecondary: Color.lerp(
        surfaceSecondary,
        other.surfaceSecondary,
        t,
      )!,
      surfaceVariant: Color.lerp(
        surfaceVariant,
        other.surfaceVariant,
        t,
      )!,
      borderPrimary: Color.lerp(
        borderPrimary,
        other.borderPrimary,
        t,
      )!,
      borderInput: Color.lerp(
        borderInput,
        other.borderInput,
        t,
      )!,
      textPrimary: Color.lerp(
        textPrimary,
        other.textPrimary,
        t,
      )!,
      textSecondary: Color.lerp(
        textSecondary,
        other.textSecondary,
        t,
      )!,
      pointer: Color.lerp(
        pointer,
        other.pointer,
        t,
      )!,
      connectedBackground: Color.lerp(
        connectedBackground,
        other.connectedBackground,
        t,
      )!,
      connectedText: Color.lerp(
        connectedText,
        other.connectedText,
        t,
      )!,
      connectingBackground: Color.lerp(
        connectingBackground,
        other.connectingBackground,
        t,
      )!,
      connectingText: Color.lerp(
        connectingText,
        other.connectingText,
        t,
      )!,
      notConnectedBackground: Color.lerp(
        notConnectedBackground,
        other.notConnectedBackground,
        t,
      )!,
      notConnectedText: Color.lerp(
        notConnectedText,
        other.notConnectedText,
        t,
      )!,
      divider: Color.lerp(
        divider,
        other.divider,
        t,
      )!,
      buttonDisabled: Color.lerp(
        buttonDisabled,
        other.buttonDisabled,
        t,
      )!,
      textButtonDisabled: Color.lerp(
        textButtonDisabled,
        other.textButtonDisabled,
        t,
      )!,
      selectionBackground: Color.lerp(
        selectionBackground,
        other.selectionBackground,
        t,
      )!,
      selectionHandle: Color.lerp(
        selectionHandle,
        other.selectionHandle,
        t,
      )!,
      shadows: GyverLampShadows.lerp(
        shadows,
        other.shadows,
        t,
      ),
    );
  }
}
