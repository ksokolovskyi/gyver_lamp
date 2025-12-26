import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_effects/src/widgets/widgets.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  Matrix4 calculateTransformation(Offset offset) {
    return Matrix4.identity()
      ..setEntry(3, 2, 0.005)
      ..multiply(Matrix4.rotationX(offset.dy * kMaxRotation))
      ..multiply(Matrix4.rotationY(-offset.dx * kMaxRotation));
  }

  group('Fidgeter', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(
        const Fidgeter(
          foregroundChild: Icon(GyverLampIcons.done),
          child: SizedBox.square(
            dimension: 200,
            child: ColoredBox(
              color: Colors.red,
            ),
          ),
        ),
      );

      expect(find.byType(Fidgeter), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) => widget is ColoredBox && widget.color == Colors.red,
        ),
        findsOneWidget,
      );
      expect(find.byIcon(GyverLampIcons.done), findsOneWidget);
    });

    testWidgets(
      'transforms child according to the touches and drags',
      (tester) async {
        await tester.pumpSubject(
          const Fidgeter(
            child: ColoredBox(
              color: Colors.red,
            ),
          ),
        );

        expect(
          tester.fidgeterTransformation,
          equals(calculateTransformation(Offset.zero)),
        );

        final fidgeter = find.byType(Fidgeter);

        final center = tester.getCenter(fidgeter);
        final topLeft = tester.getTopLeft(fidgeter);
        final topRight = tester.getTopRight(fidgeter);
        final bottomLeft = tester.getBottomLeft(fidgeter);
        final bottomRight = tester.getBottomRight(fidgeter);

        final gesture = await tester.createGesture();

        await gesture.down(center);
        await tester.pumpAndSettle();
        await gesture.moveTo(topLeft);
        await tester.pumpAndSettle();

        expect(
          tester.fidgeterTransformation,
          equals(calculateTransformation(const Offset(-1, -1))),
        );

        await gesture.moveTo(center);
        await tester.pumpAndSettle();
        await gesture.moveTo(topRight);
        await tester.pumpAndSettle();

        expect(
          tester.fidgeterTransformation,
          equals(calculateTransformation(const Offset(1, -1))),
        );

        await gesture.moveTo(center);
        await tester.pumpAndSettle();
        await gesture.moveTo(bottomLeft);
        await tester.pumpAndSettle();

        expect(
          tester.fidgeterTransformation,
          equals(calculateTransformation(const Offset(-1, 1))),
        );

        await gesture.moveTo(center);
        await tester.pumpAndSettle();
        await gesture.moveTo(bottomRight);
        await tester.pumpAndSettle();

        expect(
          tester.fidgeterTransformation,
          equals(calculateTransformation(const Offset(1, 1))),
        );

        await gesture.moveTo(center);
        await tester.pumpAndSettle();
        await gesture.up();
        await tester.pumpAndSettle();

        expect(
          tester.fidgeterTransformation,
          equals(calculateTransformation(Offset.zero)),
        );
      },
    );

    testWidgets('transforms child back after tap up', (tester) async {
      await tester.pumpSubject(
        const Fidgeter(
          child: ColoredBox(
            color: Colors.red,
          ),
        ),
      );

      expect(
        tester.fidgeterTransformation,
        equals(calculateTransformation(Offset.zero)),
      );

      final topLeft = tester.getTopLeft(find.byType(Fidgeter));

      final gesture = await tester.startGesture(topLeft);
      await tester.pumpAndSettle();

      expect(
        tester.fidgeterTransformation,
        equals(calculateTransformation(const Offset(-1, -1))),
      );

      await gesture.up();
      await tester.pumpAndSettle();

      expect(
        tester.fidgeterTransformation,
        equals(calculateTransformation(Offset.zero)),
      );
    });
  });
}

extension _Fidgeter on WidgetTester {
  Future<void> pumpSubject(
    Widget child,
  ) {
    return pumpWidget(
      MaterialApp(
        theme: GyverLampTheme.lightThemeData,
        home: Scaffold(
          body: Center(
            child: SizedBox.square(
              dimension: 200,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Matrix4 get fidgeterTransformation {
    return widget<Transform>(
      find.descendant(
        of: find.byType(Fidgeter),
        matching: find.byType(Transform),
      ),
    ).transform;
  }
}
