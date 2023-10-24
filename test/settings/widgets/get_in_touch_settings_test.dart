import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp/settings/settings.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('GetInTouchSettings', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject((_) async {});

      expect(find.byType(SettingTileGroup), findsOneWidget);
      expect(find.text(tester.l10n.getInTouch), findsOneWidget);

      expect(find.byType(SettingTile), findsNWidgets(3));
      expect(find.byType(FlatIconButton), findsNWidgets(3));
      expect(find.byIcon(GyverLampIcons.arrow_outward), findsNWidgets(3));

      expect(find.byIcon(GyverLampIcons.mail), findsOneWidget);
      expect(find.text(tester.l10n.email), findsOneWidget);

      expect(find.byIcon(GyverLampIcons.x), findsOneWidget);
      expect(find.text(tester.l10n.twitter), findsOneWidget);

      expect(find.byIcon(GyverLampIcons.dribbble), findsOneWidget);
      expect(find.text(tester.l10n.dribbble), findsOneWidget);
    });

    testWidgets('launches mail on mail button tap', (tester) async {
      String? launchedUrl;

      await tester.pumpSubject((url) async {
        launchedUrl = url;
      });

      await tester.tap(
        find.descendant(
          of: find.widgetWithText(SettingTile, tester.l10n.email),
          matching: find.byType(FlatIconButton),
        ),
      );

      expect(launchedUrl, equals('mailto:sokolovskyi.konstantin@gmail.com'));
    });

    testWidgets('launches twitter on twitter button tap', (tester) async {
      String? launchedUrl;

      await tester.pumpSubject((url) async {
        launchedUrl = url;
      });

      await tester.tap(
        find.descendant(
          of: find.widgetWithText(SettingTile, tester.l10n.twitter),
          matching: find.byType(FlatIconButton),
        ),
      );

      expect(launchedUrl, equals('https://twitter.com/k_sokolovskyi'));
    });

    testWidgets('launches dribbble on dribbble button tap', (tester) async {
      String? launchedUrl;

      await tester.pumpSubject((url) async {
        launchedUrl = url;
      });

      await tester.tap(
        find.descendant(
          of: find.widgetWithText(SettingTile, tester.l10n.dribbble),
          matching: find.byType(FlatIconButton),
        ),
      );

      expect(launchedUrl, equals('https://dribbble.com/ira_dehtiar'));
    });
  });
}

extension _GetInTouchSettings on WidgetTester {
  Future<void> pumpSubject(AsyncValueSetter<String> urlLauncher) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: GetInTouchSettings(urlLauncher: urlLauncher),
      ),
    );
  }
}
