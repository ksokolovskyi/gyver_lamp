import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('AlertMessenger', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(
        const AlertMessenger(
          child: Scaffold(),
        ),
      );

      expect(
        find.byType(AlertMessenger),
        findsOneWidget,
      );
      expect(
        find.byType(Scaffold),
        findsOneWidget,
      );
    });

    testWidgets('updates child', (tester) async {
      await tester.pumpSubject(
        const AlertMessenger(
          child: Scaffold(),
        ),
      );

      expect(
        find.byType(AlertMessenger),
        findsOneWidget,
      );
      expect(
        find.byType(Scaffold),
        findsOneWidget,
      );
      expect(
        find.byType(ColoredBox),
        findsNothing,
      );

      await tester.pumpSubject(
        const AlertMessenger(
          child: ColoredBox(
            color: Colors.red,
          ),
        ),
      );

      expect(
        find.byType(AlertMessenger),
        findsOneWidget,
      );
      expect(
        find.byType(Scaffold),
        findsNothing,
      );
      expect(
        find.byType(ColoredBox),
        findsOneWidget,
      );
    });

    testWidgets('AlertMessenger.of returns state', (tester) async {
      await tester.pumpSubject(
        const AlertMessenger(
          child: Scaffold(),
        ),
      );

      final state1 = tester.state<AlertMessengerState>(
        find.byType(AlertMessenger),
      );

      final state2 = AlertMessenger.of(
        tester.element(
          find.byType(Scaffold),
        ),
      );

      expect(state1, equals(state2));
    });

    testWidgets(
      'AlertMessenger.of() throws when there is no AlertMessenger in the tree',
      (tester) async {
        await tester.pumpSubject(
          const Scaffold(),
        );

        await expectLater(
          () => AlertMessenger.of(
            tester.element(
              find.byType(Scaffold),
            ),
          ),
          throwsA(
            isA<FlutterError>().having(
              (e) => e.message,
              'message',
              allOf(
                contains('No AlertMessenger widget found.'),
                contains(
                  'Scaffold widgets require an AlertMessenger '
                  'widget ancestor.',
                ),
              ),
            ),
          ),
        );
      },
    );

    testWidgets('showError() shows alert with animation', (tester) async {
      await tester.pumpSubject(
        const AlertMessenger(
          child: Scaffold(),
        ),
      );

      final state = AlertMessenger.of(
        tester.element(
          find.byType(Scaffold),
        ),
      );

      var isShown = false;

      state.showInfo(message: 'ERROR').then((_) => isShown = true).ignore();

      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isTrue);

      // Awaiting the animation.
      await tester.pump(kShowDuration * 1.01);

      expect(find.text('ERROR'), findsOneWidget);
      expect(isShown, isTrue);
    });

    testWidgets('showInfo() shows alert with animation', (tester) async {
      await tester.pumpSubject(
        const AlertMessenger(
          child: Scaffold(),
        ),
      );

      final state = AlertMessenger.of(
        tester.element(
          find.byType(Scaffold),
        ),
      );

      var isShown = false;

      state.showInfo(message: 'INFO').then((_) => isShown = true).ignore();

      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isTrue);

      // Awaiting the animation.
      await tester.pump(kShowDuration * 1.01);

      expect(find.text('INFO'), findsOneWidget);
      expect(isShown, isTrue);
    });

    testWidgets('hide() hides alert with animation', (tester) async {
      await tester.runAsync(
        () async {
          await tester.pumpSubject(
            const AlertMessenger(
              child: Scaffold(),
            ),
          );

          final state = AlertMessenger.of(
            tester.element(
              find.byType(Scaffold),
            ),
          );

          state.showInfo(message: 'INFO').ignore();

          // Awaiting the animation.
          await tester.pump(kShowDuration);

          expect(find.text('INFO'), findsOneWidget);

          var isHidden = false;

          state.hide().then((_) => isHidden = true).ignore();

          await tester.pump();

          expect(tester.binding.hasScheduledFrame, isTrue);

          // Awaiting the animation.
          await tester.pump(kHideDuration);

          expect(find.text('INFO'), findsNothing);
          expect(isHidden, isTrue);
        },
      );
    });

    testWidgets('clear() hides alert without animation', (tester) async {
      await tester.pumpSubject(
        const AlertMessenger(
          child: Scaffold(),
        ),
      );

      final state = AlertMessenger.of(
        tester.element(
          find.byType(Scaffold),
        ),
      );

      state.showInfo(message: 'INFO').ignore();

      // Awaiting the animation.
      await tester.pumpAndSettle();

      expect(find.text('INFO'), findsOneWidget);

      state.clear();

      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isFalse);

      expect(find.text('INFO'), findsNothing);
    });

    testWidgets('new alert replaces the old one', (tester) async {
      await tester.pumpSubject(
        const AlertMessenger(
          child: Scaffold(),
        ),
      );

      final state = AlertMessenger.of(
        tester.element(
          find.byType(Scaffold),
        ),
      );

      state.showInfo(message: 'INFO').ignore();

      // Awaiting the animation.
      await tester.pumpAndSettle();

      expect(find.text('INFO'), findsOneWidget);

      state.showInfo(message: 'NEW ONE').ignore();

      // Awaiting the animation.
      await tester.pumpAndSettle();

      expect(find.text('INFO'), findsNothing);
      expect(find.text('NEW ONE'), findsOneWidget);
    });

    testWidgets(
      'error alert closes automatically after the timeout',
      (tester) async {
        await tester.pumpSubject(
          const AlertMessenger(
            child: Scaffold(),
          ),
        );

        final state = AlertMessenger.of(
          tester.element(
            find.byType(Scaffold),
          ),
        );

        state.showError(message: 'ERROR').ignore();

        // Awaiting the animation.
        await tester.pumpAndSettle();

        expect(find.text('ERROR'), findsOneWidget);

        // Awaiting the display duration.
        await tester.pumpAndSettle(kErrorAlertDuration);

        expect(find.text('ERROR'), findsNothing);
      },
    );

    testWidgets(
      'info alert closes automatically after the timeout',
      (tester) async {
        await tester.pumpSubject(
          const AlertMessenger(
            child: Scaffold(),
          ),
        );

        final state = AlertMessenger.of(
          tester.element(
            find.byType(Scaffold),
          ),
        );

        state.showInfo(message: 'INFO').ignore();

        // Awaiting the animation.
        await tester.pumpAndSettle();

        expect(find.text('INFO'), findsOneWidget);

        // Awaiting the display duration.
        await tester.pumpAndSettle(kInfoAlertDuration);

        expect(find.text('INFO'), findsNothing);
      },
    );

    testWidgets('alert can be closed by button', (tester) async {
      await tester.pumpSubject(
        const AlertMessenger(
          child: Scaffold(),
        ),
      );

      final state = AlertMessenger.of(
        tester.element(
          find.byType(Scaffold),
        ),
      );

      state.showInfo(message: 'INFO').ignore();

      // Awaiting the animation.
      await tester.pumpAndSettle();

      expect(find.text('INFO'), findsOneWidget);

      await tester.tap(
        find.byIcon(GyverLampIcons.close),
      );

      // Awaiting the animation.
      await tester.pumpAndSettle();

      expect(find.text('INFO'), findsNothing);
    });

    testWidgets('alert is removed after widget disposal', (tester) async {
      await tester.pumpSubject(
        const AlertMessenger(
          child: Scaffold(),
        ),
      );

      final state = AlertMessenger.of(
        tester.element(
          find.byType(Scaffold),
        ),
      );

      state.showInfo(message: 'INFO').ignore();

      // Awaiting the animation.
      await tester.pumpAndSettle();

      expect(find.text('INFO'), findsOneWidget);

      await tester.pumpSubject(
        const Center(),
      );

      expect(find.text('INFO'), findsNothing);
    });
  });
}

extension _AlertMessenger on WidgetTester {
  Future<void> pumpSubject(
    Widget child,
  ) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        home: child,
      ),
    );
  }
}
