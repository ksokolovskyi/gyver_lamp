import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('FlatTextButton', () {
    testWidgets(
      'sets correct size when created with FlatTextButton.small',
      (tester) async {
        await tester.pumpSubject(
          const FlatTextButton.small(
            onPressed: null,
            child: Text('Text'),
          ),
        );

        expect(
          tester.widget(find.byType(FlatTextButton)),
          isA<FlatTextButton>().having(
            (b) => b.size,
            'size',
            equals(FlatTextButtonSize.small),
          ),
        );
      },
    );

    testWidgets(
      'sets correct size when created with FlatTextButton.medium',
      (tester) async {
        await tester.pumpSubject(
          const FlatTextButton.medium(
            onPressed: null,
            child: Text('Text'),
          ),
        );

        expect(
          tester.widget(find.byType(FlatTextButton)),
          isA<FlatTextButton>().having(
            (b) => b.size,
            'size',
            equals(FlatTextButtonSize.medium),
          ),
        );
      },
    );

    testWidgets(
      'sets correct size when created with FlatTextButton.large',
      (tester) async {
        await tester.pumpSubject(
          const FlatTextButton.large(
            onPressed: null,
            child: Text('Text'),
          ),
        );

        expect(
          tester.widget(find.byType(FlatTextButton)),
          isA<FlatTextButton>().having(
            (b) => b.size,
            'size',
            equals(FlatTextButtonSize.large),
          ),
        );
      },
    );

    testWidgets('renders the given text and responds to taps', (tester) async {
      var wasTapped = false;

      await tester.pumpSubject(
        FlatTextButton(
          onPressed: () => wasTapped = true,
          size: FlatTextButtonSize.small,
          child: const Text('Text'),
        ),
      );

      await tester.tap(find.text('Text'));

      expect(wasTapped, isTrue);
    });

    testWidgets('renders the given icon and responds to taps', (tester) async {
      var wasTapped = false;

      await tester.pumpSubject(
        FlatTextButton(
          onPressed: () => wasTapped = true,
          size: FlatTextButtonSize.small,
          child: const Icon(GyverLampIcons.close),
        ),
      );

      await tester.tap(find.byIcon(GyverLampIcons.close));

      expect(wasTapped, isTrue);
    });

    testWidgets('renders text with half opacity when disabled', (tester) async {
      await tester.pumpSubject(
        const FlatTextButton(
          onPressed: null,
          size: FlatTextButtonSize.small,
          child: Text('Text'),
        ),
      );

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
                isA<Color>().having((c) => c.alpha, 'alpha', equals(128)),
              ),
        ),
      );
    });

    testWidgets('renders sizes correctly in small variant', (tester) async {
      await tester.pumpSubject(
        const FlatTextButton(
          onPressed: null,
          size: FlatTextButtonSize.small,
          child: Text('Text'),
        ),
      );

      expect(
        tester.widget(find.byType(FlatTextButton)),
        isA<FlatTextButton>().having((b) => b.height, 'height', equals(32)),
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
        const FlatTextButton(
          onPressed: null,
          size: FlatTextButtonSize.medium,
          child: Text('Text'),
        ),
      );

      expect(
        tester.widget(find.byType(FlatTextButton)),
        isA<FlatTextButton>().having((b) => b.height, 'height', equals(40)),
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
        const FlatTextButton(
          onPressed: null,
          size: FlatTextButtonSize.large,
          child: Text('Text'),
        ),
      );

      expect(
        tester.widget(find.byType(FlatTextButton)),
        isA<FlatTextButton>().having((b) => b.height, 'height', equals(48)),
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
        FlatTextButton(
          onPressed: () => wasTapped = true,
          size: FlatTextButtonSize.medium,
          child: const Text('Text'),
        ),
      );

      await tester.tap(find.byType(FlatTextButton));

      expect(wasTapped, isTrue);
    });

    testWidgets('cancels tap on drag', (tester) async {
      var wasTapped = false;

      await tester.pumpSubject(
        FlatTextButton(
          onPressed: () => wasTapped = true,
          size: FlatTextButtonSize.medium,
          child: const Text('Text'),
        ),
      );

      await tester.drag(
        find.text('Text'),
        const Offset(0, 100),
      );

      expect(wasTapped, isFalse);
    });

    testWidgets('animates tap when enabled', (tester) async {
      await tester.pumpSubject(
        FlatTextButton(
          onPressed: () {},
          size: FlatTextButtonSize.medium,
          child: const Text('Text'),
        ),
      );

      await tester.tap(find.text('Text'));
      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('does not animate tap when disabled', (tester) async {
      await tester.pumpSubject(
        const FlatTextButton(
          onPressed: null,
          size: FlatTextButtonSize.medium,
          child: Text('Text'),
        ),
      );

      await tester.tap(find.text('Text'));
      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isFalse);
    });
  });
}

extension _FlatTextButton on WidgetTester {
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
