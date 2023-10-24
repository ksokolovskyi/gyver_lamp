import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';
import 'package:gyver_lamp_effects/src/widgets/widgets.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockFramesGenerator extends Mock implements FramesGenerator {}

void main() {
  group('FramesBuilder', () {
    const dimension = 9;
    const frameSize = dimension * dimension;

    final redFrame = Frame(
      dimension: dimension,
      data: List.filled(frameSize, Colors.red),
    );
    final blueFrame = Frame(
      dimension: dimension,
      data: List.filled(frameSize, Colors.blue),
    );
    final greenFrame = Frame(
      dimension: dimension,
      data: List.filled(frameSize, Colors.green),
    );
    final whiteFrame = Frame(
      dimension: dimension,
      data: List.filled(frameSize, Colors.white),
    );

    late FramesGenerator generator;

    setUp(() {
      generator = _MockFramesGenerator();
      when(() => generator.dimension).thenReturn(dimension);
      when(() => generator.blur).thenReturn(10);
    });

    testWidgets('renders correctly', (tester) async {
      when(
        () => generator.generate(
          speed: any(named: 'speed'),
          scale: any(named: 'scale'),
        ),
      ).thenReturn(whiteFrame);
      when(generator.reset).thenAnswer((_) async {});

      await tester.pumpSubject(
        FramesBuilder(
          generator: generator,
          paused: true,
          speed: 16,
          scale: 30,
        ),
      );

      expect(find.byType(FramesBuilder), findsOneWidget);
      expect(find.byType(FramePainter), findsOneWidget);

      final painter = tester.widget<FramePainter>(find.byType(FramePainter));
      expect(painter.frame, equals(whiteFrame));
    });

    testWidgets('resets generator when is paused', (tester) async {
      when(
        () => generator.generate(
          speed: any(named: 'speed'),
          scale: any(named: 'scale'),
        ),
      ).thenReturn(whiteFrame);
      when(generator.reset).thenAnswer((_) async {});

      await tester.pumpSubject(
        FramesBuilder(
          generator: generator,
          paused: true,
          speed: 16,
          scale: 30,
        ),
      );

      verify(() => generator.reset()).called(1);
    });

    testWidgets('does not reset generator when is not paused', (tester) async {
      when(
        () => generator.generate(
          speed: any(named: 'speed'),
          scale: any(named: 'scale'),
        ),
      ).thenReturn(whiteFrame);
      when(generator.reset).thenAnswer((_) async {});

      await tester.pumpSubject(
        FramesBuilder(
          generator: generator,
          paused: false,
          speed: 16,
          scale: 30,
        ),
      );

      verifyNever(() => generator.reset());
    });

    testWidgets('does not generate next frame if paused', (tester) async {
      when(
        () => generator.generate(
          speed: any(named: 'speed'),
          scale: any(named: 'scale'),
        ),
      ).thenReturn(whiteFrame);
      when(generator.reset).thenAnswer((_) async {});

      const speed = 16;
      const scale = 30;

      await tester.pumpSubject(
        FramesBuilder(
          generator: generator,
          paused: true,
          speed: speed,
          scale: scale,
        ),
      );

      verify(() => generator.generate(speed: speed, scale: scale)).called(1);

      await tester.pump(const Duration(seconds: 5));

      verifyNever(() => generator.generate(speed: speed, scale: scale));
    });

    testWidgets('generates new frame according to the speed', (tester) async {
      final frames = [redFrame, greenFrame, blueFrame];
      var index = 0;

      when(
        () => generator.generate(
          speed: any(named: 'speed'),
          scale: any(named: 'scale'),
        ),
      ).thenAnswer((_) => frames[index++]);

      const speed = 16;
      const scale = 30;

      await tester.pumpSubject(
        FramesBuilder(
          generator: generator,
          paused: false,
          speed: speed,
          scale: scale,
        ),
      );

      verify(() => generator.generate(speed: speed, scale: scale)).called(1);
      expect(
        tester.widget<FramePainter>(find.byType(FramePainter)).frame,
        equals(redFrame),
      );

      await tester.pump(const Duration(milliseconds: speed ~/ 2));

      verifyNever(() => generator.generate(speed: speed, scale: scale));

      await tester.pump(const Duration(milliseconds: speed ~/ 2));

      verify(() => generator.generate(speed: speed, scale: scale)).called(1);
      expect(
        tester.widget<FramePainter>(find.byType(FramePainter)).frame,
        equals(greenFrame),
      );

      await tester.pump(const Duration(milliseconds: speed));

      verify(() => generator.generate(speed: speed, scale: scale)).called(1);
      expect(
        tester.widget<FramePainter>(find.byType(FramePainter)).frame,
        equals(blueFrame),
      );
    });

    testWidgets('does not generate new frames after pausing', (tester) async {
      when(
        () => generator.generate(
          speed: any(named: 'speed'),
          scale: any(named: 'scale'),
        ),
      ).thenReturn(whiteFrame);

      const speed = 16;
      const scale = 30;

      await tester.pumpSubject(
        FramesBuilder(
          generator: generator,
          paused: false,
          speed: speed,
          scale: scale,
        ),
      );

      verify(() => generator.generate(speed: speed, scale: scale)).called(1);

      await tester.pump(const Duration(milliseconds: speed));

      verify(() => generator.generate(speed: speed, scale: scale)).called(1);

      await tester.pump(const Duration(milliseconds: speed ~/ 2));

      await tester.pumpSubject(
        FramesBuilder(
          generator: generator,
          paused: true,
          speed: speed,
          scale: scale,
        ),
      );

      await tester.pump(const Duration(seconds: 5));

      verifyNever(() => generator.generate(speed: speed, scale: scale));
    });

    testWidgets('does not generate new frames after disposal', (tester) async {
      when(
        () => generator.generate(
          speed: any(named: 'speed'),
          scale: any(named: 'scale'),
        ),
      ).thenReturn(whiteFrame);

      const speed = 16;
      const scale = 30;

      await tester.pumpSubject(
        FramesBuilder(
          generator: generator,
          paused: false,
          speed: speed,
          scale: scale,
        ),
      );

      verify(() => generator.generate(speed: speed, scale: scale)).called(1);

      await tester.pump(const Duration(milliseconds: speed));

      verify(() => generator.generate(speed: speed, scale: scale)).called(1);

      await tester.pump(const Duration(milliseconds: speed ~/ 2));

      await tester.pumpSubject(const Center());

      await tester.pump(const Duration(seconds: 5));

      verifyNever(() => generator.generate(speed: speed, scale: scale));
    });

    testWidgets('generates new frames after unpausing', (tester) async {
      when(
        () => generator.generate(
          speed: any(named: 'speed'),
          scale: any(named: 'scale'),
        ),
      ).thenReturn(whiteFrame);
      when(generator.reset).thenAnswer((_) async {});

      const speed = 16;
      const scale = 30;

      await tester.pumpSubject(
        FramesBuilder(
          generator: generator,
          paused: true,
          speed: speed,
          scale: scale,
        ),
      );

      verify(() => generator.generate(speed: speed, scale: scale)).called(1);

      await tester.pump(const Duration(milliseconds: speed));

      verifyNever(() => generator.generate(speed: speed, scale: scale));

      await tester.pumpSubject(
        FramesBuilder(
          generator: generator,
          paused: false,
          speed: speed,
          scale: scale,
        ),
      );

      await tester.pump(const Duration(milliseconds: speed));

      verify(() => generator.generate(speed: speed, scale: scale)).called(1);
    });

    testWidgets(
      'generates new frame immediately after generator swap when paused',
      (tester) async {
        final generator1 = _MockFramesGenerator();
        when(
          () => generator1.generate(
            speed: any(named: 'speed'),
            scale: any(named: 'scale'),
          ),
        ).thenReturn(redFrame);
        when(generator1.reset).thenAnswer((_) async {});

        final generator2 = _MockFramesGenerator();
        when(
          () => generator2.generate(
            speed: any(named: 'speed'),
            scale: any(named: 'scale'),
          ),
        ).thenReturn(blueFrame);
        when(generator2.reset).thenAnswer((_) async {});

        const speed = 16;
        const scale = 30;

        await tester.pumpSubject(
          FramesBuilder(
            generator: generator1,
            paused: true,
            speed: speed,
            scale: scale,
          ),
        );

        verify(() => generator1.generate(speed: speed, scale: scale)).called(1);
        expect(
          tester.widget<FramePainter>(find.byType(FramePainter)).frame,
          equals(redFrame),
        );

        await tester.pumpSubject(
          FramesBuilder(
            generator: generator2,
            paused: true,
            speed: speed,
            scale: scale,
          ),
        );

        verifyNever(() => generator1.generate(speed: speed, scale: scale));
        verify(() => generator2.generate(speed: speed, scale: scale)).called(1);
        expect(
          tester.widget<FramePainter>(find.byType(FramePainter)).frame,
          equals(blueFrame),
        );
      },
    );

    testWidgets(
      'does not generate new frame immediately after generator swap '
      'when is not paused',
      (tester) async {
        final generator1 = _MockFramesGenerator();
        when(
          () => generator1.generate(
            speed: any(named: 'speed'),
            scale: any(named: 'scale'),
          ),
        ).thenReturn(redFrame);

        final generator2 = _MockFramesGenerator();
        when(
          () => generator2.generate(
            speed: any(named: 'speed'),
            scale: any(named: 'scale'),
          ),
        ).thenReturn(blueFrame);

        const speed = 16;
        const scale = 30;

        await tester.pumpSubject(
          FramesBuilder(
            generator: generator1,
            paused: false,
            speed: speed,
            scale: scale,
          ),
        );

        verify(() => generator1.generate(speed: speed, scale: scale)).called(1);
        expect(
          tester.widget<FramePainter>(find.byType(FramePainter)).frame,
          equals(redFrame),
        );

        await tester.pumpSubject(
          FramesBuilder(
            generator: generator2,
            paused: false,
            speed: speed,
            scale: scale,
          ),
        );

        verifyNever(() => generator1.generate(speed: speed, scale: scale));
        verifyNever(() => generator2.generate(speed: speed, scale: scale));

        await tester.pump(const Duration(milliseconds: speed));

        verifyNever(() => generator1.generate(speed: speed, scale: scale));
        verify(() => generator2.generate(speed: speed, scale: scale)).called(1);
        expect(
          tester.widget<FramePainter>(find.byType(FramePainter)).frame,
          equals(blueFrame),
        );
      },
    );

    testWidgets(
      'generates new frame immediately after scale change when paused',
      (tester) async {
        when(
          () => generator.generate(
            speed: any(named: 'speed'),
            scale: any(named: 'scale'),
          ),
        ).thenReturn(whiteFrame);
        when(generator.reset).thenAnswer((_) async {});

        const speed = 16;
        const scale1 = 30;
        const scale2 = 60;

        await tester.pumpSubject(
          FramesBuilder(
            generator: generator,
            paused: true,
            speed: speed,
            scale: scale1,
          ),
        );

        verify(() => generator.generate(speed: speed, scale: scale1)).called(1);

        await tester.pumpSubject(
          FramesBuilder(
            generator: generator,
            paused: true,
            speed: speed,
            scale: scale2,
          ),
        );

        verifyNever(() => generator.generate(speed: speed, scale: scale1));
        verify(() => generator.generate(speed: speed, scale: scale2)).called(1);
      },
    );

    testWidgets(
      'does not generate new frame immediately after scale change '
      'when is not paused',
      (tester) async {
        when(
          () => generator.generate(
            speed: any(named: 'speed'),
            scale: any(named: 'scale'),
          ),
        ).thenReturn(whiteFrame);
        when(generator.reset).thenAnswer((_) async {});

        const speed = 16;
        const scale1 = 30;
        const scale2 = 60;

        await tester.pumpSubject(
          FramesBuilder(
            generator: generator,
            paused: false,
            speed: speed,
            scale: scale1,
          ),
        );

        verify(() => generator.generate(speed: speed, scale: scale1)).called(1);

        await tester.pumpSubject(
          FramesBuilder(
            generator: generator,
            paused: false,
            speed: speed,
            scale: scale2,
          ),
        );

        verifyNever(() => generator.generate(speed: speed, scale: scale1));
        verifyNever(() => generator.generate(speed: speed, scale: scale2));

        await tester.pump(const Duration(milliseconds: speed));

        verifyNever(() => generator.generate(speed: speed, scale: scale1));
        verify(() => generator.generate(speed: speed, scale: scale2)).called(1);
      },
    );

    testWidgets(
      'does not generate new frame after speed change when paused',
      (tester) async {
        when(
          () => generator.generate(
            speed: any(named: 'speed'),
            scale: any(named: 'scale'),
          ),
        ).thenReturn(whiteFrame);
        when(generator.reset).thenAnswer((_) async {});

        const speed1 = 16;
        const speed2 = 32;
        const scale = 30;

        await tester.pumpSubject(
          FramesBuilder(
            generator: generator,
            paused: true,
            speed: speed1,
            scale: scale,
          ),
        );

        verify(() => generator.generate(speed: speed1, scale: scale)).called(1);

        await tester.pumpSubject(
          FramesBuilder(
            generator: generator,
            paused: true,
            speed: speed2,
            scale: scale,
          ),
        );

        await tester.pumpAndSettle(const Duration(seconds: 5));

        verifyNever(() => generator.generate(speed: speed1, scale: scale));
        verifyNever(() => generator.generate(speed: speed2, scale: scale));
      },
    );

    testWidgets(
      'updates internal timer correctly after speed change',
      (tester) async {
        when(
          () => generator.generate(
            speed: any(named: 'speed'),
            scale: any(named: 'scale'),
          ),
        ).thenReturn(whiteFrame);

        const speed1 = 16;
        const speed2 = speed1 * 2;
        const scale = 30;

        await tester.pumpSubject(
          FramesBuilder(
            generator: generator,
            paused: false,
            speed: speed1,
            scale: scale,
          ),
        );

        verify(() => generator.generate(speed: speed1, scale: scale)).called(1);

        await tester.pumpSubject(
          FramesBuilder(
            generator: generator,
            paused: false,
            speed: speed2,
            scale: scale,
          ),
        );

        await tester.pump(const Duration(milliseconds: speed1));

        verifyNever(() => generator.generate(speed: speed1, scale: scale));
        verifyNever(() => generator.generate(speed: speed2, scale: scale));

        await tester.pump(const Duration(milliseconds: speed1));

        verifyNever(() => generator.generate(speed: speed1, scale: scale));
        verify(() => generator.generate(speed: speed2, scale: scale)).called(1);
      },
    );
  });
}

extension _FramesBuilder on WidgetTester {
  Future<void> pumpSubject(Widget child) {
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
}
