import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp/settings/settings.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';
import 'package:settings_controller/settings_controller.dart';

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  group('SettingView', () {
    late ValueNotifier<Locale?> locale;
    late ValueNotifier<bool?> darkModeOn;
    late SettingsController settingsController;
    late MockNavigator navigator;

    setUp(() {
      locale = ValueNotifier(null);
      darkModeOn = ValueNotifier(null);

      settingsController = _MockSettingsController();
      when(() => settingsController.locale).thenReturn(locale);
      when(() => settingsController.darkModeOn).thenReturn(darkModeOn);

      navigator = MockNavigator();
    });

    tearDown(() {
      locale.dispose();
      darkModeOn.dispose();
    });

    Widget buildSubject() {
      return Provider<SettingsController>.value(
        value: settingsController,
        child: MockNavigatorProvider(
          navigator: navigator,
          child: const SettingsView(),
        ),
      );
    }

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(buildSubject());

      expect(find.byType(SettingsView), findsOneWidget);
      expect(
        find.ancestor(
          of: find.byIcon(GyverLampIcons.arrow_left),
          matching: find.byType(FlatIconButton),
        ),
        findsOneWidget,
      );
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(GeneralSettings), findsOneWidget);
      expect(find.byType(GetInTouchSettings), findsOneWidget);
      expect(find.byType(OtherSettings), findsOneWidget);
    });

    testWidgets('pop page on back button tap', (tester) async {
      when(navigator.pop).thenAnswer((_) async {});

      await tester.pumpSubject(buildSubject());

      await tester.tap(
        find.ancestor(
          of: find.byIcon(GyverLampIcons.arrow_left),
          matching: find.byType(FlatIconButton),
        ),
      );

      verify(navigator.pop).called(1);
    });
  });
}

extension _SettingsView on WidgetTester {
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
