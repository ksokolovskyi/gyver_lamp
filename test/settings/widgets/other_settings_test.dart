import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp/settings/settings.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('OtherSettings', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject((_) async {});

      expect(find.byType(SettingTileGroup), findsOneWidget);
      expect(find.text(tester.l10n.otherStuff), findsOneWidget);

      expect(find.byType(SettingTile), findsNWidgets(4));
      expect(find.byType(FlatIconButton), findsNWidgets(4));
      expect(find.byIcon(GyverLampIcons.arrow_outward), findsNWidgets(4));

      expect(find.byIcon(GyverLampIcons.github), findsOneWidget);
      expect(find.text(tester.l10n.lampProject), findsOneWidget);

      expect(find.byIcon(GyverLampIcons.group), findsOneWidget);
      expect(find.text(tester.l10n.credits), findsOneWidget);

      expect(find.byIcon(GyverLampIcons.policy), findsOneWidget);
      expect(find.text(tester.l10n.privacyPolicy), findsOneWidget);

      expect(find.byIcon(GyverLampIcons.align_left), findsOneWidget);
      expect(find.text(tester.l10n.termsOfUse), findsOneWidget);
    });

    testWidgets(
      'launches lamp project github on github button tap',
      (tester) async {
        String? launchedUrl;

        await tester.pumpSubject((url) async {
          launchedUrl = url;
        });

        await tester.tap(
          find.descendant(
            of: find.widgetWithText(SettingTile, tester.l10n.lampProject),
            matching: find.byType(FlatIconButton),
          ),
        );

        expect(launchedUrl, equals('https://github.com/AlexGyver/GyverLamp'));
      },
    );
  });
}

extension _OtherSettings on WidgetTester {
  Future<void> pumpSubject(AsyncValueSetter<String> urlLauncher) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: OtherSettings(urlLauncher: urlLauncher),
      ),
    );
  }
}
