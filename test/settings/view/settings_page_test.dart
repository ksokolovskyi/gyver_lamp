import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp/settings/view/view.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';
import 'package:settings_controller/settings_controller.dart';

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  group('SettingsPage', () {
    late ValueNotifier<Locale?> locale;
    late ValueNotifier<bool?> darkModeOn;
    late SettingsController settingsController;

    setUp(() {
      locale = ValueNotifier(null);
      darkModeOn = ValueNotifier(null);

      settingsController = _MockSettingsController();
      when(() => settingsController.locale).thenReturn(locale);
      when(() => settingsController.darkModeOn).thenReturn(darkModeOn);
    });

    tearDown(() {
      locale.dispose();
      darkModeOn.dispose();
    });

    Widget buildSubject() {
      return Provider<SettingsController>.value(
        value: settingsController,
        child: const SettingsPage(),
      );
    }

    group('route', () {
      test('returns correct GyverLampPageRoute', () {
        expect(
          SettingsPage.route(),
          isRoute(whereName: equals('settings')),
        );
      });

      testWidgets('can be pushed', (tester) async {
        await tester.pumpWidget(
          Provider<SettingsController>.value(
            value: settingsController,
            child: MaterialApp(
              theme: GyverLampTheme.lightThemeData,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: Center(
                child: Builder(
                  builder: (context) {
                    return ElevatedButton(
                      child: const Text('PUSH'),
                      onPressed: () {
                        Navigator.of(context).push(
                          SettingsPage.route(),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('PUSH'));
        await tester.pumpAndSettle();

        expect(find.byType(SettingsPage), findsOneWidget);
      });
    });

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(buildSubject());

      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.byType(SettingsView), findsOneWidget);
    });
  });
}

extension _SettingsPage on WidgetTester {
  Future<void> pumpSubject(Widget subject) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: subject,
      ),
    );
  }
}
