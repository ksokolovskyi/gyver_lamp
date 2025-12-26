import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mockingjay/mockingjay.dart';

void main() {
  group('ConfirmationDialog', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(
        ConfirmationDialog(
          title: 'Title',
          body: 'Body',
          cancelLabel: 'Cancel',
          confirmLabel: 'Confirm',
          onCancel: () {},
          onConfirm: () {},
        ),
      );

      expect(find.byType(ConfirmationDialog), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('Cancel'),
          matching: find.byType(RoundedOutlinedButton),
        ),
        findsOneWidget,
      );
      expect(
        find.ancestor(
          of: find.text('Confirm'),
          matching: find.byType(RoundedElevatedButton),
        ),
        findsOneWidget,
      );
    });

    testWidgets('can be shown', (tester) async {
      await tester.pumpSubject(
        Builder(
          builder: (context) {
            return FlatIconButton.medium(
              icon: GyverLampIcons.arrow_outward,
              onPressed: () {
                GyverLampDialog.show(
                  context,
                  dialog: ConfirmationDialog(
                    title: 'Title',
                    body: 'Body',
                    cancelLabel: 'Cancel',
                    confirmLabel: 'Confirm',
                    onCancel: () {},
                    onConfirm: () {},
                  ),
                );
              },
            );
          },
        ),
      );

      await tester.tap(find.byType(FlatIconButton));
      await tester.pumpAndSettle();

      expect(find.byType(ConfirmationDialog), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('Cancel'),
          matching: find.byType(RoundedOutlinedButton),
        ),
        findsOneWidget,
      );
      expect(
        find.ancestor(
          of: find.text('Confirm'),
          matching: find.byType(RoundedElevatedButton),
        ),
        findsOneWidget,
      );
    });

    testWidgets('calls onCancel after tap on cancel button', (tester) async {
      var wasCancelled = false;

      await tester.pumpSubject(
        ConfirmationDialog(
          title: 'Title',
          body: 'Body',
          cancelLabel: 'Cancel',
          confirmLabel: 'Confirm',
          onCancel: () => wasCancelled = true,
          onConfirm: () {},
        ),
      );

      await tester.tap(
        find.ancestor(
          of: find.text('Cancel'),
          matching: find.byType(RoundedOutlinedButton),
        ),
      );

      expect(wasCancelled, isTrue);
    });

    testWidgets('tries to pop page after tap on cancel button', (tester) async {
      var wasPopped = false;

      final navigator = MockNavigator();

      when(navigator.maybePop).thenAnswer((_) async {
        wasPopped = true;
        return true;
      });
      when(navigator.canPop).thenReturn(true);

      await tester.pumpSubject(
        MockNavigatorProvider(
          navigator: navigator,
          child: ConfirmationDialog(
            title: 'Title',
            body: 'Body',
            cancelLabel: 'Cancel',
            confirmLabel: 'Confirm',
            onCancel: () {},
            onConfirm: () {},
          ),
        ),
      );

      await tester.tap(
        find.ancestor(
          of: find.text('Cancel'),
          matching: find.byType(RoundedOutlinedButton),
        ),
      );

      expect(wasPopped, isTrue);
    });

    testWidgets('calls onConfirm after tap on confirm button', (tester) async {
      var wasConfirmed = false;

      await tester.pumpSubject(
        ConfirmationDialog(
          title: 'Title',
          body: 'Body',
          cancelLabel: 'Cancel',
          confirmLabel: 'Confirm',
          onCancel: () {},
          onConfirm: () => wasConfirmed = true,
        ),
      );

      await tester.tap(
        find.ancestor(
          of: find.text('Confirm'),
          matching: find.byType(RoundedElevatedButton),
        ),
      );

      expect(wasConfirmed, isTrue);
    });

    testWidgets(
      'tries to pop page after tap on confirm button',
      (tester) async {
        var wasPopped = false;

        final navigator = MockNavigator();

        when(navigator.maybePop).thenAnswer((_) async {
          wasPopped = true;
          return true;
        });
        when(navigator.canPop).thenReturn(true);

        await tester.pumpSubject(
          MockNavigatorProvider(
            navigator: navigator,
            child: ConfirmationDialog(
              title: 'Title',
              body: 'Body',
              cancelLabel: 'Cancel',
              confirmLabel: 'Confirm',
              onCancel: () {},
              onConfirm: () {},
            ),
          ),
        );

        await tester.tap(
          find.ancestor(
            of: find.text('Confirm'),
            matching: find.byType(RoundedElevatedButton),
          ),
        );

        expect(wasPopped, isTrue);
      },
    );
  });
}

extension _ConfirmationDialog on WidgetTester {
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
