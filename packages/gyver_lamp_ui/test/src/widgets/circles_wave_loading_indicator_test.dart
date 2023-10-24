import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('CirclesWaveLoadingIndicator', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(
        const CirclesWaveLoadingIndicator(),
      );

      expect(
        find.byType(CirclesWaveLoadingIndicator),
        findsOneWidget,
      );

      expect(
        find.descendant(
          of: find.byType(Transform),
          matching: find.byType(DecoratedBox),
        ),
        findsNWidgets(3),
      );
    });

    testWidgets('animates repeatedly', (tester) async {
      await tester.pumpSubject(
        const CirclesWaveLoadingIndicator(),
      );

      expect(tester.binding.hasScheduledFrame, isTrue);

      await tester.pump(const Duration(seconds: 5));

      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('renders color correctly', (tester) async {
      await tester.pumpSubject(
        const CirclesWaveLoadingIndicator(color: Colors.yellow),
      );

      expect(
        tester.widgetList(
          find.descendant(
            of: find.byType(Transform),
            matching: find.byType(DecoratedBox),
          ),
        ),
        everyElement(
          isA<DecoratedBox>().having(
            (b) => b.decoration,
            'decoration',
            isA<BoxDecoration>().having(
              (d) => d.color,
              'color',
              equals(Colors.yellow),
            ),
          ),
        ),
      );
    });

    testWidgets('renders size correctly', (tester) async {
      await tester.pumpSubject(
        const CirclesWaveLoadingIndicator(size: 15),
      );

      expect(
        tester.widgetList(
          find.descendant(
            of: find.byType(Transform),
            matching: find.byType(SizedBox),
          ),
        ),
        everyElement(
          isA<SizedBox>()
              .having((b) => b.height, 'height', equals(15))
              .having((b) => b.width, 'width', equals(15)),
        ),
      );
    });
  });
}

extension _CirclesWaveLoadingIndicator on WidgetTester {
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
