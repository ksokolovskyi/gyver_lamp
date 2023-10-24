import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';

void main() {
  group('GyverLampIcons', () {
    test('fontFamily is correct', () {
      expect(GyverLampIcons.fontFamily, equals('GyverLampIcons'));
    });

    test('fontPackage is correct', () {
      expect(GyverLampIcons.fontPackage, equals('gyver_lamp_icons'));
    });

    testWidgets('can be used', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: Icon(GyverLampIcons.close),
          ),
        ),
      );

      expect(find.byIcon(GyverLampIcons.close), findsOneWidget);
    });
  });
}
