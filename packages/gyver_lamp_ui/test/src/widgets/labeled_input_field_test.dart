import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('LabeledInputField', () {
    testWidgets('renders correctly with light theme', (tester) async {
      await tester.pumpSubject(
        const LabeledInputField(
          label: 'Input',
        ),
      );

      expect(
        find.byType(LabeledInputField),
        findsOneWidget,
      );
      expect(
        find.text('Input'),
        findsOneWidget,
      );
    });

    testWidgets('renders hintText correctly', (tester) async {
      await tester.pumpSubject(
        const LabeledInputField(
          label: 'Input',
          hintText: 'Hint',
        ),
      );

      expect(
        tester
            .widget<AnimatedOpacity>(
              find.ancestor(
                of: find.text('Hint'),
                matching: find.byType(AnimatedOpacity),
              ),
            )
            .opacity,
        equals(1.0),
      );

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<AnimatedOpacity>(
              find.ancestor(
                of: find.text('Hint'),
                matching: find.byType(AnimatedOpacity),
              ),
            )
            .opacity,
        equals(1.0),
      );

      await tester.enterText(
        find.byType(LabeledInputField),
        '123',
      );
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<AnimatedOpacity>(
              find.ancestor(
                of: find.text('Hint'),
                matching: find.byType(AnimatedOpacity),
              ),
            )
            .opacity,
        equals(0.0),
      );
    });

    testWidgets('renders errorText correctly', (tester) async {
      await tester.pumpSubject(
        const LabeledInputField(
          label: 'Input',
          errorText: 'Error',
        ),
      );

      expect(
        find.text('Error'),
        findsOneWidget,
      );

      await tester.pumpSubject(
        const LabeledInputField(
          label: 'Input',
        ),
      );

      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isTrue);

      await tester.pumpAndSettle();

      expect(
        find.text('Error'),
        findsNothing,
      );
    });

    testWidgets('calls onChanged after text editing', (tester) async {
      var text = '';

      await tester.pumpSubject(
        LabeledInputField(
          label: 'Input',
          onChanged: (value) => text = value,
        ),
      );

      await tester.enterText(
        find.byType(LabeledInputField),
        '123',
      );

      await tester.pumpAndSettle();

      expect(
        text,
        equals('123'),
      );
    });

    testWidgets('can not be edited when disabled', (tester) async {
      var text = '';

      await tester.pumpSubject(
        LabeledInputField(
          label: 'Input',
          enabled: false,
          onChanged: (value) => text = value,
        ),
      );

      await tester.enterText(
        find.byType(LabeledInputField),
        '123',
      );

      await tester.pumpAndSettle();

      expect(text, isEmpty);
    });

    testWidgets('can be controlled by controller', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpSubject(
        LabeledInputField(
          label: 'Input',
          controller: controller,
        ),
      );

      expect(
        find.text('123'),
        findsNothing,
      );

      controller.text = '123';

      expect(
        find.text('123'),
        findsOneWidget,
      );
    });

    testWidgets('does not show clear icon when empty', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpSubject(
        LabeledInputField(
          label: 'Input',
          controller: controller,
        ),
      );

      final opacity = tester
          .widget<AnimatedOpacity>(
            find.ancestor(
              of: find.byIcon(GyverLampIcons.close),
              matching: find.byType(AnimatedOpacity),
            ),
          )
          .opacity;

      expect(opacity, equals(0));
    });

    testWidgets('shows clear icon when not empty', (tester) async {
      final controller = TextEditingController(text: 'test');
      addTearDown(controller.dispose);

      await tester.pumpSubject(
        LabeledInputField(
          label: 'Input',
          controller: controller,
        ),
      );

      final opacity = tester
          .widget<AnimatedOpacity>(
            find.ancestor(
              of: find.byIcon(GyverLampIcons.close),
              matching: find.byType(AnimatedOpacity),
            ),
          )
          .opacity;

      expect(opacity, equals(1));
    });

    testWidgets(
      'gets cleared and focused after clear button tap',
      (tester) async {
        final controller = TextEditingController(text: 'test');
        addTearDown(controller.dispose);
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);

        await tester.pumpSubject(
          LabeledInputField(
            label: 'Input',
            controller: controller,
            focusNode: focusNode,
          ),
        );

        await tester.tap(find.byIcon(GyverLampIcons.close));
        await tester.pumpAndSettle();

        expect(controller.text, isEmpty);
        expect(focusNode.hasFocus, isTrue);
      },
    );
  });
}

extension _LabeledInputField on WidgetTester {
  Future<void> pumpSubject(
    Widget child,
  ) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        home: Scaffold(
          body: Center(
            child: Row(
              children: [
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
