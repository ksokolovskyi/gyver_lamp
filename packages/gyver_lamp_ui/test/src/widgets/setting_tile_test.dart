import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('SettingTile', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(
        SettingTile(
          icon: GyverLampIcons.github,
          label: 'GitHub',
          action: FlatIconButton.medium(
            icon: GyverLampIcons.arrow_outward,
            onPressed: () {},
          ),
        ),
      );

      expect(
        find.byType(SettingTile),
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

extension _SettingTile on WidgetTester {
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
