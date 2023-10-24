import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';
import 'package:gyver_lamp_effects/src/widgets/widgets.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

void main() {
  group('GyverLampEffect', () {
    const speed = 16;
    const scale = 30;

    testWidgets('renders correctly', (tester) async {
      await tester.pumpSubject(
        const GyverLampEffect(
          type: GyverLampEffectType.clouds,
          speed: speed,
          scale: scale,
        ),
      );

      expect(find.byType(GyverLampEffect), findsOneWidget);
      expect(find.byType(Fidgeter), findsOneWidget);
      expect(find.byType(FramesBuilder), findsOneWidget);
      expect(
        find.ancestor(
          of: find.byIcon(GyverLampIcons.play),
          matching: find.byType(FlatIconButton),
        ),
        findsOneWidget,
      );
    });

    testWidgets('passes correct values to the FramesBuilder', (tester) async {
      await tester.pumpSubject(
        const GyverLampEffect(
          type: GyverLampEffectType.clouds,
          speed: 1,
          scale: 2,
          dimension: 3,
        ),
      );

      final builder = tester.widget<FramesBuilder>(find.byType(FramesBuilder));

      expect(
        builder.generator,
        isA<CloudsFramesGenerator>().having(
          (g) => g.dimension,
          'dimension',
          equals(3),
        ),
      );
      expect(builder.speed, equals(1));
      expect(builder.scale, equals(2));
      expect(builder.paused, isTrue);
    });

    group('uses correct generator', () {
      testWidgets('when type is GyverLampEffectType.sparkles', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.sparkles,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<SparklesFramesGenerator>(),
        );
      });

      testWidgets('when type is GyverLampEffectType.fire', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.fire,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<FireFramesGenerator>(),
        );
      });

      testWidgets(
        'when type is GyverLampEffectType.verticalRainbow',
        (tester) async {
          await tester.pumpSubject(
            const GyverLampEffect(
              type: GyverLampEffectType.verticalRainbow,
              speed: speed,
              scale: scale,
            ),
          );

          expect(
            tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
            isA<VerticalRainbowFramesGenerator>(),
          );
        },
      );

      testWidgets(
        'when type is GyverLampEffectType.horizontalRainbow',
        (tester) async {
          await tester.pumpSubject(
            const GyverLampEffect(
              type: GyverLampEffectType.horizontalRainbow,
              speed: speed,
              scale: scale,
            ),
          );

          expect(
            tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
            isA<HorizontalRainbowFramesGenerator>(),
          );
        },
      );

      testWidgets('when type is GyverLampEffectType.colors', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.colors,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<ColorsFramesGenerator>(),
        );
      });

      testWidgets('when type is GyverLampEffectType.madness', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.madness,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<MadnessFramesGenerator>(),
        );
      });

      testWidgets('when type is GyverLampEffectType.clouds', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.clouds,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<CloudsFramesGenerator>(),
        );
      });

      testWidgets('when type is GyverLampEffectType.lava', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.lava,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<LavaFramesGenerator>(),
        );
      });

      testWidgets('when type is GyverLampEffectType.plasma', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.plasma,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<PlasmaFramesGenerator>(),
        );
      });

      testWidgets('when type is GyverLampEffectType.rainbow', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.rainbow,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<RainbowFramesGenerator>(),
        );
      });

      testWidgets(
        'when type is GyverLampEffectType.rainbowStripes',
        (tester) async {
          await tester.pumpSubject(
            const GyverLampEffect(
              type: GyverLampEffectType.rainbowStripes,
              speed: speed,
              scale: scale,
            ),
          );

          expect(
            tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
            isA<RainbowStripesFramesGenerator>(),
          );
        },
      );

      testWidgets('when type is GyverLampEffectType.zebra', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.zebra,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<ZebraFramesGenerator>(),
        );
      });

      testWidgets('when type is GyverLampEffectType.forest', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.forest,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<ForestFramesGenerator>(),
        );
      });

      testWidgets('when type is GyverLampEffectType.ocean', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.ocean,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<OceanFramesGenerator>(),
        );
      });

      testWidgets('when type is GyverLampEffectType.color', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.color,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<ColorFramesGenerator>(),
        );
      });

      testWidgets('when type is GyverLampEffectType.snow', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.snow,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<SnowFramesGenerator>(),
        );
      });

      testWidgets('when type is GyverLampEffectType.matrix', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.matrix,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<MatrixFramesGenerator>(),
        );
      });

      testWidgets('when type is GyverLampEffectType.fireflies', (tester) async {
        await tester.pumpSubject(
          const GyverLampEffect(
            type: GyverLampEffectType.fireflies,
            speed: speed,
            scale: scale,
          ),
        );

        expect(
          tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
          isA<FirefliesFramesGenerator>(),
        );
      });
    });

    testWidgets('renders correct effect after type change', (tester) async {
      await tester.pumpSubject(
        const GyverLampEffect(
          type: GyverLampEffectType.clouds,
          speed: speed,
          scale: scale,
        ),
      );

      expect(
        tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
        isA<CloudsFramesGenerator>(),
      );

      await tester.pumpSubject(
        const GyverLampEffect(
          type: GyverLampEffectType.fire,
          speed: speed,
          scale: scale,
        ),
      );

      await tester.pumpAndSettle();

      expect(
        tester.widget<FramesBuilder>(find.byType(FramesBuilder)).generator,
        isA<FireFramesGenerator>(),
      );
    });

    testWidgets('can be paused and continued', (tester) async {
      await tester.pumpSubject(
        const GyverLampEffect(
          type: GyverLampEffectType.clouds,
          speed: speed,
          scale: scale,
        ),
      );

      expect(
        tester.widget<FramesBuilder>(find.byType(FramesBuilder)).paused,
        isTrue,
      );

      await tester.tap(
        find.ancestor(
          of: find.byIcon(GyverLampIcons.play),
          matching: find.byType(FlatIconButton),
        ),
      );

      await tester.pump();

      expect(
        find.ancestor(
          of: find.byIcon(GyverLampIcons.play),
          matching: find.byType(FlatIconButton),
        ),
        findsNothing,
      );
      expect(
        find.ancestor(
          of: find.byIcon(GyverLampIcons.pause),
          matching: find.byType(FlatIconButton),
        ),
        findsOneWidget,
      );
      expect(
        tester.widget<FramesBuilder>(find.byType(FramesBuilder)).paused,
        isFalse,
      );

      await tester.tap(
        find.ancestor(
          of: find.byIcon(GyverLampIcons.pause),
          matching: find.byType(FlatIconButton),
        ),
      );

      await tester.pump();

      expect(
        find.ancestor(
          of: find.byIcon(GyverLampIcons.pause),
          matching: find.byType(FlatIconButton),
        ),
        findsNothing,
      );
      expect(
        find.ancestor(
          of: find.byIcon(GyverLampIcons.play),
          matching: find.byType(FlatIconButton),
        ),
        findsOneWidget,
      );
      expect(
        tester.widget<FramesBuilder>(find.byType(FramesBuilder)).paused,
        isTrue,
      );
    });
  });
}

extension _GyverLampEffect on WidgetTester {
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
