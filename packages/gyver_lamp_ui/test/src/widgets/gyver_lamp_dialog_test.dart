import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('GyverLampDialog', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(
        GyverLampDialog(
          title: 'Title',
          body: const Text('Body'),
          actions: [
            FlatIconButton.medium(
              icon: GyverLampIcons.close,
              onPressed: () {},
            ),
          ],
        ),
      );

      expect(find.byType(GyverLampDialog), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(find.byIcon(GyverLampIcons.close), findsOneWidget);
    });

    group('show', () {
      testWidgets('renders dialog widget', (tester) async {
        await tester.pumpSubject(
          Builder(
            builder: (context) {
              return FlatIconButton.medium(
                icon: GyverLampIcons.arrow_outward,
                onPressed: () {
                  GyverLampDialog.show(
                    context,
                    dialog: GyverLampDialog(
                      title: 'Title',
                      body: const Text('Body'),
                      actions: [
                        FlatIconButton.medium(
                          icon: GyverLampIcons.close,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );

        await tester.tap(find.byType(FlatIconButton));
        await tester.pumpAndSettle();

        expect(find.byType(GyverLampDialog), findsOneWidget);
        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Body'), findsOneWidget);
        expect(find.byIcon(GyverLampIcons.close), findsOneWidget);
      });
    });
  });
}

extension _GyverLampDialog on WidgetTester {
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
