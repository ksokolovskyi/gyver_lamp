import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/settings/widgets/widgets.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:settings_controller/settings_controller.dart';

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  group('DarkModeSwitcher', () {
    late ValueNotifier<bool?> darkModeOn;
    late SettingsController settingsController;

    setUp(() {
      darkModeOn = ValueNotifier(null);

      settingsController = _MockSettingsController();
      when(() => settingsController.darkModeOn).thenReturn(darkModeOn);
      when(
        () => settingsController.setDarkModeOn(active: any(named: 'active')),
      ).thenReturn(null);
    });

    tearDown(() {
      darkModeOn.dispose();
    });

    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpSubject(
        controller: settingsController,
        subject: const DarkModeSwitcher(),
      );

      expect(find.byType(DarkModeSwitcher), findsOneWidget);
      expect(find.byType(Switcher), findsOneWidget);
    });

    testWidgets(
      'toggled off when setting is not set',
      (WidgetTester tester) async {
        darkModeOn.value = null;

        await tester.pumpSubject(
          controller: settingsController,
          subject: const DarkModeSwitcher(),
        );

        final switcher = tester.widget<Switcher>(find.byType(Switcher));
        expect(switcher.value, isFalse);
      },
    );

    testWidgets(
      'toggled off when setting is disabled',
      (WidgetTester tester) async {
        darkModeOn.value = false;

        await tester.pumpSubject(
          controller: settingsController,
          subject: const DarkModeSwitcher(),
        );

        final switcher = tester.widget<Switcher>(find.byType(Switcher));
        expect(switcher.value, isFalse);
      },
    );

    testWidgets(
      'toggled on when setting is enabled',
      (WidgetTester tester) async {
        darkModeOn.value = true;

        await tester.pumpSubject(
          controller: settingsController,
          subject: const DarkModeSwitcher(),
        );

        final switcher = tester.widget<Switcher>(find.byType(Switcher));
        expect(switcher.value, isTrue);
      },
    );

    testWidgets('redraws when setting is changed', (WidgetTester tester) async {
      darkModeOn.value = false;

      await tester.pumpSubject(
        controller: settingsController,
        subject: const DarkModeSwitcher(),
      );

      darkModeOn.value = true;
      await tester.pump();

      final switcher = tester.widget<Switcher>(find.byType(Switcher));
      expect(switcher.value, isTrue);
    });

    testWidgets(
      'calls SettingsController.setDarkModeOn when toggled on',
      (WidgetTester tester) async {
        darkModeOn.value = false;

        await tester.pumpSubject(
          controller: settingsController,
          subject: const DarkModeSwitcher(),
        );

        await tester.tap(find.byType(DarkModeSwitcher));

        verify(() => settingsController.setDarkModeOn(active: true)).called(1);
      },
    );

    testWidgets(
      'calls SettingsController.setDarkModeOn when toggled off',
      (WidgetTester tester) async {
        darkModeOn.value = true;

        await tester.pumpSubject(
          controller: settingsController,
          subject: const DarkModeSwitcher(),
        );

        await tester.tap(find.byType(DarkModeSwitcher));

        verify(() => settingsController.setDarkModeOn(active: false)).called(1);
      },
    );
  });
}

extension _DarkModeSwitcher on WidgetTester {
  Future<void> pumpSubject({
    required SettingsController controller,
    required Widget subject,
  }) {
    return pumpWidget(
      Provider<SettingsController>.value(
        value: controller,
        child: MaterialApp(
          theme: GyverLampTheme.lightThemeData,
          home: Scaffold(
            body: Center(child: subject),
          ),
        ),
      ),
    );
  }
}
