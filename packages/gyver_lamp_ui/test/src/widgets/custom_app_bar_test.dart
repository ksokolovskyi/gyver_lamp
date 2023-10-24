import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('CustomAppBar', () {
    testWidgets('renders correctly with all parts specified', (tester) async {
      await tester.pumpSubject(
        CustomAppBar(
          leading: FlatIconButton.medium(
            icon: GyverLampIcons.align_left,
            onPressed: () {},
          ),
          title: 'Title',
          actions: [
            Switcher(
              value: false,
              onChanged: (_) {},
            ),
          ],
        ),
      );

      expect(find.byType(CustomAppBar), findsOneWidget);
      expect(find.byIcon(GyverLampIcons.align_left), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.byType(Switcher), findsOneWidget);
    });

    testWidgets('renders correctly with only leading', (tester) async {
      await tester.pumpSubject(
        CustomAppBar(
          leading: FlatIconButton.medium(
            icon: GyverLampIcons.align_left,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byType(CustomAppBar), findsOneWidget);
      expect(find.byIcon(GyverLampIcons.align_left), findsOneWidget);
    });

    testWidgets('renders correctly with only title specified', (tester) async {
      await tester.pumpSubject(
        const CustomAppBar(
          title: 'Title',
        ),
      );

      expect(find.byType(CustomAppBar), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets(
      'renders correctly with only actions specified',
      (tester) async {
        await tester.pumpSubject(
          CustomAppBar(
            actions: [
              FlatIconButton.medium(
                icon: GyverLampIcons.align_left,
                onPressed: () {},
              ),
              Switcher(
                value: false,
                onChanged: (_) {},
              ),
            ],
          ),
        );

        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.byIcon(GyverLampIcons.align_left), findsOneWidget);
        expect(find.byType(Switcher), findsOneWidget);
      },
    );

    testWidgets(
      'animates scrolling under for AxisDirection.down',
      (tester) async {
        await tester.pumpSubject(
          Column(
            children: [
              const CustomAppBar(
                title: 'Title',
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 100,
                  itemExtent: 20,
                  itemBuilder: (context, index) {
                    return ConstrainedBox(
                      key: ValueKey(index),
                      constraints: const BoxConstraints.expand(height: 20),
                      child: const ColoredBox(color: Colors.grey),
                    );
                  },
                ),
              ),
            ],
          ),
        );

        final state = tester.state<CustomAppBarState>(
          find.byType(CustomAppBar),
        );

        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        expect(state.isScrolledUnder, isFalse);

        await tester.scrollUntilVisible(
          find.byKey(const ValueKey(99)),
          200,
        );
        await tester.pumpAndSettle();

        expect(state.isScrolledUnder, isTrue);

        await tester.scrollUntilVisible(
          find.byKey(const ValueKey(0)),
          -200,
        );
        await tester.pumpAndSettle();

        expect(state.isScrolledUnder, isFalse);
      },
    );

    testWidgets(
      'animates scrolling under for AxisDirection.up',
      (tester) async {
        await tester.pumpSubject(
          Column(
            children: [
              const CustomAppBar(
                title: 'Title',
              ),
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: 100,
                  itemExtent: 20,
                  itemBuilder: (context, index) {
                    return ConstrainedBox(
                      key: ValueKey(index),
                      constraints: const BoxConstraints.expand(height: 20),
                      child: const ColoredBox(color: Colors.grey),
                    );
                  },
                ),
              ),
            ],
          ),
        );

        final state = tester.state<CustomAppBarState>(
          find.byType(CustomAppBar),
        );

        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        expect(state.isScrolledUnder, isTrue);

        await tester.scrollUntilVisible(
          find.byKey(const ValueKey(99)),
          200,
        );
        await tester.pumpAndSettle();

        expect(state.isScrolledUnder, isFalse);

        await tester.scrollUntilVisible(
          find.byKey(const ValueKey(0)),
          -200,
        );
        await tester.pumpAndSettle();

        expect(state.isScrolledUnder, isTrue);
      },
    );

    testWidgets(
      'does not animate scrolling under for AxisDirection.right',
      (tester) async {
        await tester.pumpSubject(
          Column(
            children: [
              const CustomAppBar(
                title: 'Title',
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 100,
                  itemExtent: 20,
                  itemBuilder: (context, index) {
                    return ConstrainedBox(
                      key: ValueKey(index),
                      constraints: const BoxConstraints.expand(width: 20),
                      child: const ColoredBox(color: Colors.grey),
                    );
                  },
                ),
              ),
            ],
          ),
        );

        final state = tester.state<CustomAppBarState>(
          find.byType(CustomAppBar),
        );

        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        expect(state.isScrolledUnder, isFalse);

        await tester.scrollUntilVisible(
          find.byKey(const ValueKey(99)),
          200,
        );
        await tester.pumpAndSettle();

        expect(state.isScrolledUnder, isFalse);

        await tester.scrollUntilVisible(
          find.byKey(const ValueKey(0)),
          -200,
        );
        await tester.pumpAndSettle();

        expect(state.isScrolledUnder, isFalse);
      },
    );

    testWidgets(
      'does not animate scrolling under for AxisDirection.left',
      (tester) async {
        await tester.pumpSubject(
          Column(
            children: [
              const CustomAppBar(
                title: 'Title',
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  itemCount: 100,
                  itemExtent: 20,
                  itemBuilder: (context, index) {
                    return ConstrainedBox(
                      key: ValueKey(index),
                      constraints: const BoxConstraints.expand(width: 20),
                      child: const ColoredBox(color: Colors.grey),
                    );
                  },
                ),
              ),
            ],
          ),
        );

        final state = tester.state<CustomAppBarState>(
          find.byType(CustomAppBar),
        );

        expect(find.byType(CustomAppBar), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        expect(state.isScrolledUnder, isFalse);

        await tester.scrollUntilVisible(
          find.byKey(const ValueKey(99)),
          200,
        );
        await tester.pumpAndSettle();

        expect(state.isScrolledUnder, isFalse);

        await tester.scrollUntilVisible(
          find.byKey(const ValueKey(0)),
          -200,
        );
        await tester.pumpAndSettle();

        expect(state.isScrolledUnder, isFalse);
      },
    );
  });
}

extension _CustomAppBar on WidgetTester {
  Future<void> pumpSubject(
    Widget child,
  ) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        home: Scaffold(
          body: Center(child: child),
        ),
      ),
    );
  }
}
