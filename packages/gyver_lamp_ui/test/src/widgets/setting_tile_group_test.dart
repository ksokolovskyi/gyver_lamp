import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('SettingTileGroup', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(
        SettingTileGroup(
          label: 'Group',
          tiles: [
            SettingTile(
              icon: GyverLampIcons.mail,
              label: 'Mail',
              action: FlatIconButton.medium(
                icon: GyverLampIcons.done,
                onPressed: () {},
              ),
            ),
            SettingTile(
              icon: GyverLampIcons.github,
              label: 'GitHub',
              action: FlatIconButton.medium(
                icon: GyverLampIcons.arrow_outward,
                onPressed: () {},
              ),
            ),
          ],
        ),
      );

      expect(
        find.byType(SettingTileGroup),
        findsOneWidget,
      );
      expect(
        find.byType(SettingTile),
        findsNWidgets(2),
      );
      expect(
        find.byIcon(GyverLampIcons.mail),
        findsOneWidget,
      );
      expect(
        find.text('Mail'),
        findsOneWidget,
      );
      expect(
        find.byIcon(GyverLampIcons.done),
        findsOneWidget,
      );
      expect(
        find.byType(Divider),
        findsOneWidget,
      );
      expect(
        find.byIcon(GyverLampIcons.github),
        findsOneWidget,
      );
      expect(
        find.text('GitHub'),
        findsOneWidget,
      );
      expect(
        find.byIcon(GyverLampIcons.arrow_outward),
        findsOneWidget,
      );
    });
  });
}

extension _SettingTileGroup on WidgetTester {
  Future<void> pumpSubject(
    Widget child,
  ) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        home: Scaffold(
          body: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
