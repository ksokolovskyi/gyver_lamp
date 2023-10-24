import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp/settings/settings.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:provider/provider.dart';
import 'package:settings_controller/settings_controller.dart';

import '../../helpers/helpers.dart';

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  group('GeneralSettings', () {
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
        child: const GeneralSettings(),
      );
    }

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(buildSubject());

      expect(find.byType(SettingTileGroup), findsOneWidget);
      expect(find.text(tester.l10n.general), findsOneWidget);

      expect(find.byType(SettingTile), findsNWidgets(2));

      expect(find.byIcon(GyverLampIcons.language), findsOneWidget);
      expect(find.text(tester.l10n.language), findsOneWidget);
      expect(find.byType(LanguageSelector), findsOneWidget);

      expect(find.byIcon(GyverLampIcons.moon), findsOneWidget);
      expect(find.text(tester.l10n.darkMode), findsOneWidget);
      expect(find.byType(DarkModeSwitcher), findsOneWidget);
    });
  });
}

extension _GeneralSettings on WidgetTester {
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
