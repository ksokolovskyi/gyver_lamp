import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_effects/src/models/frame.dart';
import 'package:gyver_lamp_effects/src/widgets/widgets.dart';

void main() {
  group('FramePainter', () {
    testWidgets(
      'renders correctly when width equals height and dimension is its factor',
      (tester) async {
        addTearDown(tester.view.reset);
        tester.view.physicalSize = const Size(30, 30);
        tester.view.devicePixelRatio = 1.0;

        final frame = Frame(
          dimension: 2,
          data: const [
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.black,
          ],
        );

        await tester.pumpWidget(
          RepaintBoundary(
            child: FramePainter(frame: frame),
          ),
        );

        await expectLater(
          find.byType(FramePainter),
          matchesGoldenFile('goldens/frame_painter.0.png'),
        );
      },
    );

    testWidgets(
      'renders correctly when width equals height and dimension is not its '
      'factor',
      (tester) async {
        addTearDown(tester.view.reset);
        tester.view.physicalSize = const Size(35, 35);
        tester.view.devicePixelRatio = 1.0;

        final frame = Frame(
          dimension: 2,
          data: const [
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.black,
          ],
        );

        await tester.pumpWidget(
          RepaintBoundary(
            child: FramePainter(frame: frame),
          ),
        );

        await expectLater(
          find.byType(FramePainter),
          matchesGoldenFile('goldens/frame_painter.1.png'),
        );
      },
    );

    testWidgets(
      'renders correctly when width is greater than height',
      (tester) async {
        addTearDown(tester.view.reset);
        tester.view.physicalSize = const Size(60, 30);
        tester.view.devicePixelRatio = 1.0;

        final frame = Frame(
          dimension: 2,
          data: const [
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.black,
          ],
        );

        await tester.pumpWidget(
          RepaintBoundary(
            child: FramePainter(frame: frame),
          ),
        );

        await expectLater(
          find.byType(FramePainter),
          matchesGoldenFile('goldens/frame_painter.2.png'),
        );
      },
    );

    testWidgets(
      'renders correctly when width is less than height',
      (tester) async {
        addTearDown(tester.view.reset);
        tester.view.physicalSize = const Size(30, 60);
        tester.view.devicePixelRatio = 1.0;

        final frame = Frame(
          dimension: 2,
          data: const [
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.black,
          ],
        );

        await tester.pumpWidget(
          RepaintBoundary(
            child: FramePainter(frame: frame),
          ),
        );

        await expectLater(
          find.byType(FramePainter),
          matchesGoldenFile('goldens/frame_painter.3.png'),
        );
      },
    );

    testWidgets('repaints when frame changes', (tester) async {
      addTearDown(tester.view.reset);
      tester.view.physicalSize = const Size(30, 30);
      tester.view.devicePixelRatio = 1.0;

      final frame1 = Frame(
        dimension: 2,
        data: const [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.black,
        ],
      );

      final frame2 = Frame(
        dimension: 2,
        data: const [
          Colors.black,
          Colors.blue,
          Colors.green,
          Colors.red,
        ],
      );

      await tester.pumpWidget(
        RepaintBoundary(
          child: FramePainter(frame: frame1),
        ),
      );

      await tester.pumpWidget(
        RepaintBoundary(
          child: FramePainter(frame: frame2),
        ),
      );

      await expectLater(
        find.byType(FramePainter),
        matchesGoldenFile('goldens/frame_painter.4.png'),
      );
    });
  });
}
