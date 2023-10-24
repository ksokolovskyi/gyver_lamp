import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  const items = <CustomDropdownMenuItem<int>>[
    CustomDropdownMenuItem(value: 1, label: '1'),
    CustomDropdownMenuItem(value: 2, label: '2'),
    CustomDropdownMenuItem(value: 3, label: '3'),
    CustomDropdownMenuItem(value: 4, label: '4'),
    CustomDropdownMenuItem(value: 5, label: '5'),
    CustomDropdownMenuItem(value: 6, label: '6'),
    CustomDropdownMenuItem(value: 7, label: '7'),
    CustomDropdownMenuItem(value: 8, label: '8'),
    CustomDropdownMenuItem(value: 9, label: '9'),
    CustomDropdownMenuItem(value: 10, label: '10'),
    CustomDropdownMenuItem(value: 11, label: '11'),
    CustomDropdownMenuItem(value: 12, label: '12'),
    CustomDropdownMenuItem(value: 13, label: '13'),
  ];

  group('CustomDropdownButton', () {
    testWidgets('renders correctly', (tester) async {
      final selected = items[0];

      await tester.pumpSubject(
        Column(
          children: [
            CustomDropdownButton<int>(
              items: items,
              selected: selected.value,
              onChanged: (_) {},
            ),
          ],
        ),
      );

      expect(find.byType(CustomDropdownButton<int>), findsOneWidget);
      expect(find.text(selected.label), findsOneWidget);
      expect(find.byIcon(GyverLampIcons.chevron_down), findsOneWidget);
    });

    testWidgets('changes icon on tap', (tester) async {
      await tester.pumpSubject(
        Column(
          children: [
            CustomDropdownButton<int>(
              items: items,
              selected: items[0].value,
              onChanged: (_) {},
            ),
          ],
        ),
      );

      expect(find.byIcon(GyverLampIcons.chevron_down), findsOneWidget);
      expect(find.byIcon(GyverLampIcons.chevron_up), findsNothing);

      await tester.tap(find.byType(CustomDropdownButton<int>));
      await tester.pumpAndSettle();

      expect(find.byIcon(GyverLampIcons.chevron_down), findsNothing);
      expect(find.byIcon(GyverLampIcons.chevron_up), findsOneWidget);
    });

    testWidgets('opens dropdown menu on tap', (tester) async {
      await tester.pumpSubject(
        Column(
          children: [
            CustomDropdownButton<int>(
              items: items,
              selected: items[0].value,
              onChanged: (_) {},
            ),
          ],
        ),
      );

      await tester.tap(find.byType(CustomDropdownButton<int>));
      await tester.pumpAndSettle();

      expect(find.byType(CustomDropdownMenu<int>), findsOneWidget);
    });

    testWidgets('closes dropdown menu on tap outside', (tester) async {
      await tester.pumpSubject(
        Column(
          children: [
            CustomDropdownButton<int>(
              items: items,
              selected: items[0].value,
              onChanged: (_) {},
            ),
          ],
        ),
      );

      await tester.tap(find.byType(CustomDropdownButton<int>));
      await tester.pumpAndSettle();

      expect(find.byType(CustomDropdownMenu<int>), findsOneWidget);

      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();

      expect(find.byType(CustomDropdownMenu<int>), findsNothing);
    });

    testWidgets('closes dropdown menu on tap on menu item', (tester) async {
      await tester.pumpSubject(
        Column(
          children: [
            CustomDropdownButton<int>(
              items: items,
              selected: items[0].value,
              onChanged: (_) {},
            ),
          ],
        ),
      );

      await tester.tap(find.byType(CustomDropdownButton<int>));
      await tester.pumpAndSettle();

      expect(find.byType(CustomDropdownMenu<int>), findsOneWidget);

      await tester.tap(find.text(items[1].label));
      await tester.pumpAndSettle();

      expect(find.byType(CustomDropdownMenu<int>), findsNothing);
    });

    testWidgets('closes dropdown on orientation change', (tester) async {
      final selected = items[0];

      await tester.pumpSubject(
        Builder(
          builder: (context) {
            final data = MediaQuery.of(context);

            return MediaQuery(
              data: data,
              child: Column(
                children: [
                  CustomDropdownButton<int>(
                    items: items,
                    selected: selected.value,
                    onChanged: (_) {},
                  ),
                ],
              ),
            );
          },
        ),
      );

      final orientation = MediaQuery.of(
        tester.element(
          find.byType(CustomDropdownButton<int>),
        ),
      ).orientation;

      await tester.tap(find.byType(CustomDropdownButton<int>));
      await tester.pumpAndSettle();

      expect(find.byType(CustomDropdownMenu<int>), findsOneWidget);

      await tester.pumpSubject(
        Builder(
          builder: (context) {
            final data = MediaQuery.of(context);

            return MediaQuery(
              data: data.copyWith(
                size: Size(data.size.height, data.size.width),
              ),
              child: Column(
                children: [
                  CustomDropdownButton<int>(
                    items: items,
                    selected: selected.value,
                    onChanged: (_) {},
                  ),
                ],
              ),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      final newOrientation = MediaQuery.of(
        tester.element(
          find.byType(CustomDropdownButton<int>),
        ),
      ).orientation;

      expect(orientation, isNot(equals(newOrientation)));
      expect(find.byType(CustomDropdownMenu<int>), findsNothing);
    });

    testWidgets('calls onChanged when new value is selected', (tester) async {
      int? newValue;

      await tester.pumpSubject(
        Column(
          children: [
            CustomDropdownButton<int>(
              items: items,
              selected: items[0].value,
              onChanged: (value) => newValue = value,
            ),
          ],
        ),
      );

      await tester.tap(find.byType(CustomDropdownButton<int>));
      await tester.pumpAndSettle();

      await tester.tap(find.text(items[1].label));
      await tester.pumpAndSettle();

      expect(find.byType(CustomDropdownMenu<int>), findsNothing);
      expect(newValue, isNotNull);
      expect(newValue, equals(items[1].value));
    });

    testWidgets(
      'does not call onChanged when same value is selected',
      (tester) async {
        int? newValue;

        final selected = items[0];

        await tester.pumpSubject(
          Column(
            children: [
              CustomDropdownButton<int>(
                items: items,
                selected: selected.value,
                onChanged: (value) => newValue = value,
              ),
            ],
          ),
        );

        await tester.tap(find.byType(CustomDropdownButton<int>));
        await tester.pumpAndSettle();

        await tester.tap(
          find.descendant(
            of: find.byType(CustomDropdownMenu<int>),
            matching: find.text(selected.label),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(CustomDropdownMenu<int>), findsNothing);
        expect(newValue, isNull);
      },
    );

    testWidgets('animates when new value is selected', (tester) async {
      await tester.pumpSubject(
        Column(
          children: [
            CustomDropdownButton<int>(
              items: items,
              selected: items[0].value,
              onChanged: (_) {},
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.binding.hasScheduledFrame, isFalse);

      await tester.pumpSubject(
        Column(
          children: [
            CustomDropdownButton<int>(
              items: items,
              selected: items[1].value,
              onChanged: (_) {},
            ),
          ],
        ),
      );

      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isTrue);

      await tester.pumpAndSettle();

      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('can be constrained by menuMaxHeight', (tester) async {
      const menuMaxHeight = 200.0;

      await tester.pumpSubject(
        Column(
          children: [
            CustomDropdownButton<int>(
              menuMaxHeight: menuMaxHeight,
              items: items,
              selected: items[0].value,
              onChanged: (_) {},
            ),
          ],
        ),
      );

      await tester.tap(find.byType(CustomDropdownButton<int>));
      await tester.pumpAndSettle();

      final size = tester.getSize(find.byType(CustomDropdownMenu<int>));

      expect(size.height, equals(menuMaxHeight));
    });

    testWidgets(
      'menu width is equal to button width when textDirection is ltr',
      (tester) async {
        await tester.pumpSubject(
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 20),
                child: CustomDropdownButton<int>(
                  items: items,
                  selected: items[0].value,
                  onChanged: (_) {},
                ),
              ),
            ],
          ),
        );

        await tester.tap(find.byType(CustomDropdownButton<int>));
        await tester.pumpAndSettle();

        final button = tester.getRect(find.byType(CustomDropdownButton<int>));
        final menu = tester.getRect(find.byType(CustomDropdownMenu<int>));

        expect(button.left, equals(menu.left));
        expect(button.right, equals(menu.right));
      },
    );

    testWidgets(
      'menu width is equal to button width when textDirection is rtl',
      (tester) async {
        await tester.pumpSubject(
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 20),
                child: CustomDropdownButton<int>(
                  items: items,
                  selected: items[0].value,
                  onChanged: (_) {},
                ),
              ),
            ],
          ),
          textDirection: TextDirection.rtl,
        );

        await tester.tap(find.byType(CustomDropdownButton<int>));
        await tester.pumpAndSettle();

        final button = tester.getRect(find.byType(CustomDropdownButton<int>));
        final menu = tester.getRect(find.byType(CustomDropdownMenu<int>));

        expect(button.left, equals(menu.left));
        expect(button.right, equals(menu.right));
      },
    );

    testWidgets('new item can be selected by arrows and enter', (tester) async {
      int? newValue;

      final selected = items[0];

      await tester.pumpSubject(
        Column(
          children: [
            CustomDropdownButton<int>(
              items: items,
              selected: selected.value,
              onChanged: (value) => newValue = value,
            ),
          ],
        ),
      );

      await tester.tap(find.byType(CustomDropdownButton<int>));
      await tester.pumpAndSettle();

      expect(find.byType(CustomDropdownMenu<int>), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.byType(CustomDropdownMenu<int>), findsNothing);

      expect(newValue, isNotNull);
      expect(newValue, isNot(equals(selected.value)));
    });

    testWidgets('new item can be selected by arrows and space', (tester) async {
      int? newValue;

      final selected = items[0];

      await tester.pumpSubject(
        Column(
          children: [
            CustomDropdownButton<int>(
              items: items,
              selected: selected.value,
              onChanged: (value) => newValue = value,
            ),
          ],
        ),
      );

      await tester.tap(find.byType(CustomDropdownButton<int>));
      await tester.pumpAndSettle();

      expect(find.byType(CustomDropdownMenu<int>), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();

      expect(find.byType(CustomDropdownMenu<int>), findsNothing);

      expect(newValue, isNotNull);
      expect(newValue, isNot(equals(selected.value)));
    });
  });
}

extension _CustomDropdownButton on WidgetTester {
  Future<void> pumpSubject(
    Widget child, {
    TextDirection textDirection = TextDirection.ltr,
  }) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        home: Scaffold(
          body: child,
        ),
        builder: (context, child) {
          return Directionality(
            textDirection: textDirection,
            child: child!,
          );
        },
      ),
    );
  }
}
