import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('GyverLampPageRoute', () {
    testWidgets('can be instantiated', (tester) async {
      expect(
        GyverLampPageRoute<void>(
          builder: (context) {
            return const SizedBox.shrink();
          },
        ),
        isNotNull,
      );
    });

    testWidgets('can be pushed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Center(
                  child: IconButton(
                    icon: const Icon(GyverLampIcons.arrow_right),
                    onPressed: () {
                      Navigator.of(context).push(
                        GyverLampPageRoute<void>(
                          builder: (context) {
                            return Scaffold(
                              body: Center(
                                child: IconButton(
                                  icon: const Icon(GyverLampIcons.arrow_left),
                                  onPressed: () {},
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(GyverLampIcons.arrow_left), findsNothing);

      await tester.tap(find.byIcon(GyverLampIcons.arrow_right));
      await tester.pumpAndSettle();

      expect(find.byIcon(GyverLampIcons.arrow_left), findsOneWidget);
    });

    testWidgets('can be popped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Center(
                  child: IconButton(
                    icon: const Icon(GyverLampIcons.arrow_right),
                    onPressed: () {
                      Navigator.of(context).push(
                        GyverLampPageRoute<void>(
                          builder: (context) {
                            return Scaffold(
                              body: Center(
                                child: IconButton(
                                  icon: const Icon(GyverLampIcons.arrow_left),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byIcon(GyverLampIcons.arrow_left), findsNothing);

      await tester.tap(find.byIcon(GyverLampIcons.arrow_right));
      await tester.pumpAndSettle();

      expect(find.byIcon(GyverLampIcons.arrow_left), findsOneWidget);

      await tester.tap(find.byIcon(GyverLampIcons.arrow_left));
      await tester.pumpAndSettle();

      expect(find.byIcon(GyverLampIcons.arrow_left), findsNothing);
    });
  });
}
