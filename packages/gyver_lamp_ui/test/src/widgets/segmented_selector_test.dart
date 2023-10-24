import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tactile_feedback/tactile_feedback_platform_interface.dart';

class _MockTactileFeedbackPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements TactileFeedbackPlatform {}

void main() {
  group('SegmentedSelector', () {
    late TactileFeedbackPlatform tactileFeedbackPlatform;

    setUp(() {
      tactileFeedbackPlatform = _MockTactileFeedbackPlatform();

      when(tactileFeedbackPlatform.impact).thenAnswer((_) async {});

      TactileFeedbackPlatform.instance = tactileFeedbackPlatform;
    });

    testWidgets('renders correctly with TextDirection.ltr', (tester) async {
      await tester.pumpSubject(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SegmentedSelector<int>(
            segments: const [
              SelectorSegment(value: 1, label: '1'),
              SelectorSegment(value: 2, label: '2'),
              SelectorSegment(value: 3, label: '3'),
            ],
            selected: 1,
            onChanged: (value) {},
          ),
        ),
      );

      expect(find.byType(SegmentedSelector<int>), findsOneWidget);

      final one = tester.getCenter(find.text('1'));
      final two = tester.getCenter(find.text('2'));
      final three = tester.getCenter(find.text('3'));

      expect(one.dx, lessThan(two.dx));
      expect(two.dx, lessThan(three.dx));
    });

    testWidgets('renders correctly with TextDirection.rtl', (tester) async {
      await tester.pumpSubject(
        Directionality(
          textDirection: TextDirection.rtl,
          child: SegmentedSelector<int>(
            segments: const [
              SelectorSegment(value: 1, label: '1'),
              SelectorSegment(value: 2, label: '2'),
              SelectorSegment(value: 3, label: '3'),
            ],
            selected: 1,
            onChanged: (value) {},
          ),
        ),
      );

      expect(find.byType(SegmentedSelector<int>), findsOneWidget);

      final one = tester.getCenter(find.text('1'));
      final two = tester.getCenter(find.text('2'));
      final three = tester.getCenter(find.text('3'));

      expect(one.dx, greaterThan(two.dx));
      expect(two.dx, greaterThan(three.dx));
    });

    testWidgets(
      'calls onChanged when new value is selected by tap '
      'with TextDirection.ltr',
      (tester) async {
        var newValue = -1;

        await tester.pumpSubject(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SegmentedSelector<int>(
              segments: const [
                SelectorSegment(value: 1, label: '1'),
                SelectorSegment(value: 2, label: '2'),
                SelectorSegment(value: 3, label: '3'),
              ],
              selected: 1,
              onChanged: (value) => newValue = value,
            ),
          ),
        );

        await tester.tap(find.text('2'));

        expect(newValue, equals(2));
      },
    );

    testWidgets(
      'calls onChanged when new value is selected by tap '
      'with TextDirection.rtl',
      (tester) async {
        var newValue = -1;

        await tester.pumpSubject(
          Directionality(
            textDirection: TextDirection.rtl,
            child: SegmentedSelector<int>(
              segments: const [
                SelectorSegment(value: 1, label: '1'),
                SelectorSegment(value: 2, label: '2'),
                SelectorSegment(value: 3, label: '3'),
              ],
              selected: 1,
              onChanged: (value) => newValue = value,
            ),
          ),
        );

        await tester.tap(find.text('2'));

        expect(newValue, equals(2));
      },
    );

    testWidgets(
      'calls onChanged when new value is selected by drag '
      'with TextDirection.ltr',
      (tester) async {
        var newValue = -1;

        await tester.pumpSubject(
          Directionality(
            textDirection: TextDirection.ltr,
            child: SegmentedSelector<int>(
              segments: const [
                SelectorSegment(value: 1, label: '1'),
                SelectorSegment(value: 2, label: '2'),
                SelectorSegment(value: 3, label: '3'),
              ],
              selected: 1,
              onChanged: (value) => newValue = value,
            ),
          ),
        );

        await tester.pumpAndSettle();

        await TestAsyncUtils.guard<void>(() async {
          final gesture = await tester.startGesture(
            tester.getCenter(find.text('1')),
          );

          await tester.pumpAndSettle();

          await gesture.moveTo(tester.getCenter(find.text('2')));

          await tester.pumpAndSettle();

          await gesture.moveTo(tester.getCenter(find.text('3')));

          await tester.pumpAndSettle();

          await gesture.up();

          await tester.pumpAndSettle();
        });

        expect(newValue, equals(3));
      },
    );

    testWidgets(
      'calls onChanged when new value is selected by drag '
      'with TextDirection.rtl',
      (tester) async {
        var newValue = -1;

        await tester.pumpSubject(
          Directionality(
            textDirection: TextDirection.rtl,
            child: SegmentedSelector<int>(
              segments: const [
                SelectorSegment(value: 1, label: '1'),
                SelectorSegment(value: 2, label: '2'),
                SelectorSegment(value: 3, label: '3'),
              ],
              selected: 1,
              onChanged: (value) => newValue = value,
            ),
          ),
        );

        await tester.pumpAndSettle();

        await TestAsyncUtils.guard<void>(() async {
          final gesture = await tester.startGesture(
            tester.getCenter(find.text('1')),
          );

          await tester.pumpAndSettle();

          await gesture.moveTo(tester.getCenter(find.text('2')));

          await tester.pumpAndSettle();

          await gesture.moveTo(tester.getCenter(find.text('3')));

          await tester.pumpAndSettle();

          await gesture.up();

          await tester.pumpAndSettle();
        });

        expect(newValue, equals(3));
      },
    );

    testWidgets(
      'calls onChanged when tapped on not selected segment '
      'and dragged to another one',
      (tester) async {
        var newValue = -1;

        await tester.pumpSubject(
          SegmentedSelector<int>(
            segments: const [
              SelectorSegment(value: 1, label: '1'),
              SelectorSegment(value: 2, label: '2'),
              SelectorSegment(value: 3, label: '3'),
            ],
            selected: 1,
            onChanged: (value) => newValue = value,
          ),
        );

        await tester.pumpAndSettle();

        await TestAsyncUtils.guard<void>(() async {
          final gesture = await tester.startGesture(
            tester.getCenter(find.text('2')),
          );

          await tester.pumpAndSettle();

          await gesture.moveTo(tester.getCenter(find.text('3')));

          await tester.pumpAndSettle();

          await gesture.up();

          await tester.pumpAndSettle();
        });

        expect(newValue, equals(3));
      },
    );

    testWidgets(
      'animates to the new value after widget selected value update',
      (tester) async {
        await tester.pumpSubject(
          SegmentedSelector<int>(
            segments: const [
              SelectorSegment(value: 1, label: '1'),
              SelectorSegment(value: 2, label: '2'),
              SelectorSegment(value: 3, label: '3'),
            ],
            selected: 1,
            onChanged: (value) {},
          ),
        );

        await tester.pump();

        await tester.pumpSubject(
          SegmentedSelector<int>(
            segments: const [
              SelectorSegment(value: 1, label: '1'),
              SelectorSegment(value: 2, label: '2'),
              SelectorSegment(value: 3, label: '3'),
            ],
            selected: 2,
            onChanged: (value) {},
          ),
        );

        await tester.pump();

        expect(tester.binding.hasScheduledFrame, isTrue);

        await tester.pumpAndSettle();

        expect(tester.binding.hasScheduledFrame, isFalse);
      },
    );

    testWidgets(
      'does not call onChanged when drag is cancelled',
      (tester) async {
        var wasCalled = false;

        await tester.pumpSubject(
          SegmentedSelector<int>(
            segments: const [
              SelectorSegment(value: 1, label: '1'),
              SelectorSegment(value: 2, label: '2'),
              SelectorSegment(value: 3, label: '3'),
            ],
            selected: 1,
            onChanged: (value) => wasCalled = true,
          ),
        );

        await tester.pumpAndSettle();

        await TestAsyncUtils.guard<void>(() async {
          final gesture = await tester.startGesture(
            tester.getCenter(find.text('1')),
          );

          await gesture.cancel();
        });

        expect(wasCalled, isFalse);
      },
    );

    testWidgets(
      'does not call onChanged when tapped on not selected segment '
      'and dragged too far',
      (tester) async {
        var wasCalled = false;

        await tester.pumpSubject(
          SegmentedSelector<int>(
            segments: const [
              SelectorSegment(value: 1, label: '1'),
              SelectorSegment(value: 2, label: '2'),
              SelectorSegment(value: 3, label: '3'),
            ],
            selected: 1,
            onChanged: (value) => wasCalled = true,
          ),
        );

        await tester.pumpAndSettle();

        await TestAsyncUtils.guard<void>(() async {
          final gesture = await tester.startGesture(
            tester.getCenter(find.text('3')),
          );

          await tester.pumpAndSettle();

          await gesture.moveBy(const Offset(100, 0));

          await tester.pumpAndSettle();

          await gesture.up();

          await tester.pumpAndSettle();
        });

        expect(wasCalled, isFalse);
      },
    );

    testWidgets(
      'does not call onChanged after widget selected value update',
      (tester) async {
        var wasCalled = false;

        await tester.pumpSubject(
          SegmentedSelector<int>(
            segments: const [
              SelectorSegment(value: 1, label: '1'),
              SelectorSegment(value: 2, label: '2'),
              SelectorSegment(value: 3, label: '3'),
            ],
            selected: 1,
            onChanged: (value) => wasCalled = true,
          ),
        );

        await tester.pump();

        await tester.pumpSubject(
          SegmentedSelector<int>(
            segments: const [
              SelectorSegment(value: 1, label: '1'),
              SelectorSegment(value: 2, label: '2'),
              SelectorSegment(value: 3, label: '3'),
            ],
            selected: 2,
            onChanged: (value) => wasCalled = true,
          ),
        );

        await tester.pumpAndSettle();

        expect(wasCalled, isFalse);
      },
    );

    testWidgets('animates segment on press', (tester) async {
      await tester.pumpSubject(
        SegmentedSelector<int>(
          segments: const [
            SelectorSegment(value: 1, label: '1'),
            SelectorSegment(value: 2, label: '2'),
            SelectorSegment(value: 3, label: '3'),
          ],
          selected: 1,
          onChanged: (value) {},
        ),
      );

      await tester.pumpAndSettle();

      await TestAsyncUtils.guard<void>(() async {
        final gesture = await tester.startGesture(
          tester.getCenter(find.text('1')),
        );

        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.binding.hasScheduledFrame, isTrue);

        await tester.pumpAndSettle();

        expect(tester.binding.hasScheduledFrame, isFalse);

        await gesture.up();

        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.binding.hasScheduledFrame, isTrue);

        await tester.pumpAndSettle();

        expect(tester.binding.hasScheduledFrame, isFalse);
      });
    });

    testWidgets('correctly computes dimensions', (tester) async {
      late final BoxConstraints constraints;

      await tester.pumpSubject(
        LayoutBuilder(
          builder: (context, c) {
            constraints = c;

            return SegmentedSelector<int>(
              segments: const [
                SelectorSegment(value: 1, label: '1'),
                SelectorSegment(value: 2, label: '2'),
                SelectorSegment(value: 3, label: '3'),
              ],
              selected: 1,
              onChanged: (value) {},
            );
          },
        ),
      );

      final size = tester.getSize(find.byType(SegmentedSelector<int>));

      final renderBox = tester.renderObject(
        find.byType(SegmentedSelector<int>),
      ) as RenderBox;

      expect(renderBox.getMinIntrinsicWidth(0), equals(size.width));
      expect(renderBox.getMaxIntrinsicWidth(0), equals(size.width));
      expect(
        renderBox.getMinIntrinsicWidth(double.infinity),
        equals(size.width),
      );
      expect(
        renderBox.getMaxIntrinsicWidth(double.infinity),
        equals(size.width),
      );

      expect(renderBox.getMinIntrinsicHeight(0), equals(size.height));
      expect(renderBox.getMaxIntrinsicHeight(0), equals(size.height));
      expect(
        renderBox.getMinIntrinsicHeight(double.infinity),
        equals(size.height),
      );
      expect(
        renderBox.getMaxIntrinsicHeight(double.infinity),
        equals(size.height),
      );

      expect(
        renderBox.getDryLayout(constraints),
        equals(size),
      );
    });

    testWidgets('updates after theme change', (tester) async {
      tester.view
        ..physicalSize = const Size(300, 300)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final repaintBoundaryKey = UniqueKey();

      await tester.pumpSubject(
        RepaintBoundary(
          key: repaintBoundaryKey,
          child: Theme(
            data: GyverLampTheme.lightThemeData,
            child: SegmentedSelector<int>(
              segments: const [
                SelectorSegment(value: 1, label: '1'),
                SelectorSegment(value: 2, label: '2'),
                SelectorSegment(value: 3, label: '3'),
              ],
              selected: 1,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      final renderRepaintBoundary =
          tester.renderObject(find.byKey(repaintBoundaryKey))
              as RenderRepaintBoundary;
      final imageBefore = renderRepaintBoundary.toImageSync();
      addTearDown(imageBefore.dispose);

      await tester.pumpSubject(
        RepaintBoundary(
          key: repaintBoundaryKey,
          child: Theme(
            data: GyverLampTheme.darkThemeData,
            child: SegmentedSelector<int>(
              segments: const [
                SelectorSegment(value: 1, label: '1'),
                SelectorSegment(value: 2, label: '2'),
                SelectorSegment(value: 3, label: '3'),
              ],
              selected: 1,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(
        await matchesReferenceImage(imageBefore).matchAsync(
          find.byKey(repaintBoundaryKey),
        ),
        contains('does not match'),
      );
    });

    testWidgets(
      'calls TactileFeedback.impact() when new value is selected by tap',
      (tester) async {
        var wasImpacted = false;

        when(tactileFeedbackPlatform.impact).thenAnswer((_) async {
          wasImpacted = true;
        });

        await tester.pumpSubject(
          SegmentedSelector<int>(
            segments: const [
              SelectorSegment(value: 1, label: '1'),
              SelectorSegment(value: 2, label: '2'),
              SelectorSegment(value: 3, label: '3'),
            ],
            selected: 1,
            onChanged: (value) {},
          ),
        );

        await tester.tap(find.text('2'));

        expect(wasImpacted, isTrue);
      },
    );

    testWidgets(
      'calls onChanged when new value is selected by drag',
      (tester) async {
        var wasImpacted = false;

        when(tactileFeedbackPlatform.impact).thenAnswer((_) async {
          wasImpacted = true;
        });

        await tester.pumpSubject(
          SegmentedSelector<int>(
            segments: const [
              SelectorSegment(value: 1, label: '1'),
              SelectorSegment(value: 2, label: '2'),
              SelectorSegment(value: 3, label: '3'),
            ],
            selected: 1,
            onChanged: (value) {},
          ),
        );

        await tester.pumpAndSettle();

        await TestAsyncUtils.guard<void>(() async {
          final gesture = await tester.startGesture(
            tester.getCenter(find.text('1')),
          );

          await tester.pumpAndSettle();

          await gesture.moveTo(tester.getCenter(find.text('2')));

          await tester.pumpAndSettle();

          await gesture.up();

          await tester.pumpAndSettle();
        });

        expect(wasImpacted, isTrue);
      },
    );
  });
}

extension _SegmentedSelector on WidgetTester {
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
