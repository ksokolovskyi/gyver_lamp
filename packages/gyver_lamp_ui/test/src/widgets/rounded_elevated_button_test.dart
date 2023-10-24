import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('RoundedElevatedButton', () {
    testWidgets(
      'sets correct size when created with RoundedElevatedButton.small',
      (tester) async {
        await tester.pumpSubject(
          const RoundedElevatedButton.small(
            onPressed: null,
            child: Text('Text'),
          ),
        );

        expect(
          tester.widget(find.byType(RoundedElevatedButton)),
          isA<RoundedElevatedButton>().having(
            (b) => b.size,
            'size',
            equals(RoundedElevatedButtonSize.small),
          ),
        );
      },
    );

    testWidgets(
      'sets correct size when created with RoundedElevatedButton.medium',
      (tester) async {
        await tester.pumpSubject(
          const RoundedElevatedButton.medium(
            onPressed: null,
            child: Text('Text'),
          ),
        );

        expect(
          tester.widget(find.byType(RoundedElevatedButton)),
          isA<RoundedElevatedButton>().having(
            (b) => b.size,
            'size',
            equals(RoundedElevatedButtonSize.medium),
          ),
        );
      },
    );

    testWidgets(
      'sets correct size when created with RoundedElevatedButton.large',
      (tester) async {
        await tester.pumpSubject(
          const RoundedElevatedButton.large(
            onPressed: null,
            child: Text('Text'),
          ),
        );

        expect(
          tester.widget(find.byType(RoundedElevatedButton)),
          isA<RoundedElevatedButton>().having(
            (b) => b.size,
            'size',
            equals(RoundedElevatedButtonSize.large),
          ),
        );
      },
    );

    testWidgets('renders the given text and responds to taps', (tester) async {
      var wasTapped = false;

      await tester.pumpSubject(
        RoundedElevatedButton(
          onPressed: () => wasTapped = true,
          size: RoundedElevatedButtonSize.small,
          child: const Text('Text'),
        ),
      );

      await tester.tap(find.text('Text'));

      expect(wasTapped, isTrue);
    });

    testWidgets('renders the given icon and responds to taps', (tester) async {
      var wasTapped = false;

      await tester.pumpSubject(
        RoundedElevatedButton(
          onPressed: () => wasTapped = true,
          size: RoundedElevatedButtonSize.small,
          child: const Icon(GyverLampIcons.close),
        ),
      );

      await tester.tap(find.byIcon(GyverLampIcons.close));

      expect(wasTapped, isTrue);
    });

    testWidgets(
      'renders text with textButtonDisabled color when disabled',
      (tester) async {
        await tester.pumpSubject(
          const RoundedElevatedButton(
            onPressed: null,
            size: RoundedElevatedButtonSize.small,
            child: Text('Text'),
          ),
        );

        final context = tester.element(find.byType(RoundedElevatedButton));
        final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

        expect(
          tester.widget(find.byType(RichText)),
          isA<RichText>().having(
            (t) => t.text,
            'text',
            isA<TextSpan>()
                .having(
                  (s) => s.text,
                  'text',
                  equals('Text'),
                )
                .having(
                  (s) => s.style?.color,
                  'color',
                  equals(theme.textButtonDisabled),
                ),
          ),
        );
      },
    );

    testWidgets('renders sizes correctly in small variant', (tester) async {
      await tester.pumpSubject(
        const RoundedElevatedButton(
          onPressed: null,
          size: RoundedElevatedButtonSize.small,
          child: Text('Text'),
        ),
      );

      expect(
        tester.widget(find.byType(RoundedElevatedButton)),
        isA<RoundedElevatedButton>().having(
          (b) => b.height,
          'height',
          equals(32),
        ),
      );

      expect(
        tester.firstWidget(
          find.ancestor(
            of: find.text('Text'),
            matching: find.byType(DefaultTextStyle),
          ),
        ),
        isA<DefaultTextStyle>().having(
          (s) => s.style.fontSize,
          'fontSize',
          equals(GyverLampTextStyles.buttonSmallBold.fontSize),
        ),
      );
    });

    testWidgets('renders sizes correctly in medium variant', (tester) async {
      await tester.pumpSubject(
        const RoundedElevatedButton(
          onPressed: null,
          size: RoundedElevatedButtonSize.medium,
          child: Text('Text'),
        ),
      );

      expect(
        tester.widget(find.byType(RoundedElevatedButton)),
        isA<RoundedElevatedButton>().having(
          (b) => b.height,
          'height',
          equals(40),
        ),
      );

      expect(
        tester.firstWidget(
          find.ancestor(
            of: find.text('Text'),
            matching: find.byType(DefaultTextStyle),
          ),
        ),
        isA<DefaultTextStyle>().having(
          (s) => s.style.fontSize,
          'fontSize',
          equals(GyverLampTextStyles.buttonMediumBold.fontSize),
        ),
      );
    });

    testWidgets('renders sizes correctly in large variant', (tester) async {
      await tester.pumpSubject(
        const RoundedElevatedButton(
          onPressed: null,
          size: RoundedElevatedButtonSize.large,
          child: Text('Text'),
        ),
      );

      expect(
        tester.widget(find.byType(RoundedElevatedButton)),
        isA<RoundedElevatedButton>().having(
          (b) => b.height,
          'height',
          equals(48),
        ),
      );

      expect(
        tester.firstWidget(
          find.ancestor(
            of: find.text('Text'),
            matching: find.byType(DefaultTextStyle),
          ),
        ),
        isA<DefaultTextStyle>().having(
          (s) => s.style.fontSize,
          'fontSize',
          equals(GyverLampTextStyles.buttonLargeBold.fontSize),
        ),
      );
    });

    testWidgets('calls onPressed after tap', (tester) async {
      var wasTapped = false;

      await tester.pumpSubject(
        RoundedElevatedButton(
          onPressed: () => wasTapped = true,
          size: RoundedElevatedButtonSize.medium,
          child: const Text('Text'),
        ),
      );

      await tester.tap(find.byType(RoundedElevatedButton));

      expect(wasTapped, isTrue);
    });

    testWidgets('cancels tap on drag', (tester) async {
      var wasTapped = false;

      await tester.pumpSubject(
        RoundedElevatedButton(
          onPressed: () => wasTapped = true,
          size: RoundedElevatedButtonSize.medium,
          child: const Text('Text'),
        ),
      );

      final state = tester.state<RoundedElevatedButtonState>(
        find.byType(RoundedElevatedButton),
      );

      await tester.drag(
        find.text('Text'),
        const Offset(0, 100),
      );

      expect(wasTapped, isFalse);
      expect(state.isPressed, isFalse);
    });

    testWidgets('animates tap when enabled', (tester) async {
      await tester.pumpSubject(
        RoundedElevatedButton(
          onPressed: () {},
          size: RoundedElevatedButtonSize.medium,
          child: const Text('Text'),
        ),
      );

      final state = tester.state<RoundedElevatedButtonState>(
        find.byType(RoundedElevatedButton),
      );

      final gesture = await tester.press(find.text('Text'));

      expect(tester.binding.hasScheduledFrame, isTrue);
      expect(state.isPressed, isTrue);

      await gesture.up();
      await tester.pumpAndSettle();

      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(state.isPressed, isFalse);
    });

    testWidgets('does not animate tap when disabled', (tester) async {
      await tester.pumpSubject(
        const RoundedElevatedButton(
          onPressed: null,
          size: RoundedElevatedButtonSize.medium,
          child: Text('Text'),
        ),
      );

      final state = tester.state<RoundedElevatedButtonState>(
        find.byType(RoundedElevatedButton),
      );

      await tester.press(find.text('Text'));
      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isFalse);
      expect(state.isPressed, isFalse);
    });
  });
}

extension _RoundedElevatedButton on WidgetTester {
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
