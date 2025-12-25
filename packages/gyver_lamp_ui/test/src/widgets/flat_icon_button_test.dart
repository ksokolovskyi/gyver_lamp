import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('FlatIconButton', () {
    testWidgets(
      'sets correct size when created with FlatIconButton.medium',
      (tester) async {
        await tester.pumpSubject(
          const FlatIconButton.medium(
            icon: GyverLampIcons.close,
            onPressed: null,
          ),
        );

        expect(
          tester.widget(find.byType(FlatIconButton)),
          isA<FlatIconButton>().having(
            (b) => b.size,
            'size',
            equals(FlatIconButtonSize.medium),
          ),
        );
      },
    );

    testWidgets(
      'sets correct size when created with FlatIconButton.large',
      (tester) async {
        await tester.pumpSubject(
          const FlatIconButton.large(
            icon: GyverLampIcons.close,
            onPressed: null,
          ),
        );

        expect(
          tester.widget(find.byType(FlatIconButton)),
          isA<FlatIconButton>().having(
            (b) => b.size,
            'size',
            equals(FlatIconButtonSize.large),
          ),
        );
      },
    );

    testWidgets(
      'renders the given icon and responds to taps',
      (tester) async {
        var wasTapped = false;

        await tester.pumpSubject(
          FlatIconButton(
            size: FlatIconButtonSize.medium,
            icon: GyverLampIcons.close,
            onPressed: () => wasTapped = true,
          ),
        );

        await tester.tap(
          find.byIcon(GyverLampIcons.close),
        );

        expect(wasTapped, isTrue);
      },
    );

    testWidgets('renders icon with half opacity when disabled', (tester) async {
      await tester.pumpSubject(
        const FlatIconButton(
          size: FlatIconButtonSize.medium,
          icon: GyverLampIcons.close,
          onPressed: null,
        ),
      );

      expect(
        tester.widget(find.byIcon(GyverLampIcons.close)),
        isA<Icon>().having(
          (i) => i.color,
          'color',
          isA<Color>().having((c) => c.alpha, 'alpha', equals(128)),
        ),
      );
    });

    testWidgets('renders sizes correctly in medium variant', (tester) async {
      await tester.pumpSubject(
        FlatIconButton(
          size: FlatIconButtonSize.medium,
          icon: GyverLampIcons.close,
          onPressed: () {},
        ),
      );

      expect(
        tester.widget(find.byType(FlatIconButton)),
        isA<FlatIconButton>().having(
          (i) => i.dimension,
          'dimension',
          equals(32),
        ),
      );

      expect(
        tester.widget(find.byIcon(GyverLampIcons.close)),
        isA<Icon>().having((i) => i.size, 'size', equals(24)),
      );
    });

    testWidgets('renders sizes correctly in large variant', (tester) async {
      await tester.pumpSubject(
        FlatIconButton(
          size: FlatIconButtonSize.large,
          icon: GyverLampIcons.close,
          onPressed: () {},
        ),
      );

      expect(
        tester.widget(find.byType(FlatIconButton)),
        isA<FlatIconButton>().having(
          (i) => i.dimension,
          'dimension',
          equals(44),
        ),
      );

      expect(
        tester.widget(find.byIcon(GyverLampIcons.close)),
        isA<Icon>().having((i) => i.size, 'size', equals(16)),
      );
    });

    testWidgets('calls onPressed after tap', (tester) async {
      var wasTapped = false;

      await tester.pumpSubject(
        FlatIconButton(
          size: FlatIconButtonSize.medium,
          icon: GyverLampIcons.close,
          onPressed: () => wasTapped = true,
        ),
      );

      await tester.tap(find.byType(FlatIconButton));

      expect(wasTapped, isTrue);
    });

    testWidgets('cancels tap on drag', (tester) async {
      var wasTapped = false;

      await tester.pumpSubject(
        FlatIconButton(
          size: FlatIconButtonSize.medium,
          icon: GyverLampIcons.close,
          onPressed: () => wasTapped = true,
        ),
      );

      await tester.drag(
        find.byIcon(GyverLampIcons.close),
        const Offset(0, 100),
      );

      expect(wasTapped, isFalse);
    });

    testWidgets('animates tap when enabled', (tester) async {
      await tester.pumpSubject(
        FlatIconButton(
          size: FlatIconButtonSize.medium,
          icon: GyverLampIcons.close,
          onPressed: () {},
        ),
      );

      await tester.tap(find.byIcon(GyverLampIcons.close));
      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('does not animate tap when disabled', (tester) async {
      await tester.pumpSubject(
        const FlatIconButton(
          size: FlatIconButtonSize.medium,
          icon: GyverLampIcons.close,
          onPressed: null,
        ),
      );

      await tester.tap(find.byIcon(GyverLampIcons.close));
      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isFalse);
    });
  });
}

extension _FlatIconButton on WidgetTester {
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
