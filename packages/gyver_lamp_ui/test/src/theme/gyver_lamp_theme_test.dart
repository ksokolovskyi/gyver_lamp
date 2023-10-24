import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('GyverLampTheme', () {
    group('lightThemeData', () {
      testWidgets('can be instantiated', (tester) async {
        expect(
          GyverLampTheme.lightThemeData,
          isNotNull,
        );
      });

      testWidgets('can be used', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: GyverLampTheme.lightThemeData,
            home: const Scaffold(
              body: Column(
                children: [
                  LabeledInputField(label: 'Test'),
                ],
              ),
            ),
          ),
        );
      });

      testWidgets('provides GyverLampAppTheme extension', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: GyverLampTheme.lightThemeData,
            home: const Scaffold(
              body: Column(
                children: [
                  LabeledInputField(label: 'Test'),
                ],
              ),
            ),
          ),
        );

        final theme = Theme.of(
          tester.element(find.byType(Scaffold)),
        );

        final extension = theme.extension<GyverLampAppTheme>();

        expect(extension, isNotNull);
        expect(
          extension!.background,
          equals(GyverLampColors.lightBackground),
        );
      });
    });

    group('darkThemeData', () {
      testWidgets('can be instantiated', (tester) async {
        expect(
          GyverLampTheme.darkThemeData,
          isNotNull,
        );
      });

      testWidgets('can be used', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: GyverLampTheme.darkThemeData,
            home: const Scaffold(
              body: Column(
                children: [
                  LabeledInputField(label: 'Test'),
                ],
              ),
            ),
          ),
        );
      });

      testWidgets('provides GyverLampAppTheme extension', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: GyverLampTheme.darkThemeData,
            home: const Scaffold(
              body: Column(
                children: [
                  LabeledInputField(label: 'Test'),
                ],
              ),
            ),
          ),
        );

        final theme = Theme.of(
          tester.element(find.byType(Scaffold)),
        );

        final extension = theme.extension<GyverLampAppTheme>();

        expect(extension, isNotNull);
        expect(
          extension!.background,
          equals(GyverLampColors.darkBackground),
        );
      });
    });
  });

  group('GyverLampAppTheme', () {
    const light = GyverLampAppTheme(
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
    );

    const dark = GyverLampAppTheme(
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
    );

    group('lerp', () {
      test('returns same object when other is null', () {
        final lerped = dark.lerp(null, 1);

        expect(lerped, equals(dark));
      });

      test('returns new object with lerped properties', () {
        final lerped = dark.lerp(light, 1);

        expect(lerped, isNot(equals(dark)));
        expect(lerped.background, equals(light.background));
      });
    });

    group('copyWith', () {
      test(
        'returns new object with the same properties '
        'when no properties are provided',
        () {
          final copy = dark.copyWith();

          expect(copy, isNot(equals(dark)));
          expect(copy.background, equals(dark.background));
        },
      );

      test(
        'returns new object with updated passed properties',
        () {
          final copy = dark.copyWith(background: light.background);

          expect(copy, isNot(equals(dark)));
          expect(copy.background, equals(light.background));
        },
      );
    });
  });
}
