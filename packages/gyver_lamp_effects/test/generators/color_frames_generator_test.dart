import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';

import '../helpers/frames_generator_test_sheet.dart';
import '../helpers/generator_settings_variant.dart';

void main() {
  group('ColorFramesGenerator', () {
    final settingsVariant = GeneratorSettingsVariant.all();

    test('has correct blur value', () {
      expect(ColorFramesGenerator(dimension: 16).blur, equals(0));
    });

    test('caches frame until scale changes', () {
      final generator = ColorFramesGenerator(dimension: 16);

      final frame = generator.generate(speed: 8, scale: 33);

      expect(
        identical(frame, generator.generate(speed: 8, scale: 33)),
        isTrue,
      );
      expect(
        identical(frame, generator.generate(speed: 8, scale: 11)),
        isFalse,
      );
    });

    test('caches frame even if speed changes', () {
      final generator = ColorFramesGenerator(dimension: 16);

      final frame = generator.generate(speed: 8, scale: 33);

      expect(
        identical(frame, generator.generate(speed: 8, scale: 33)),
        isTrue,
      );
      expect(
        identical(frame, generator.generate(speed: 16, scale: 33)),
        isTrue,
      );
    });

    test('reset works correctly', () {
      const speed = 8;
      const scale = 33;
      final generator = ColorFramesGenerator(dimension: 16);

      final initialFrame = generator.generate(speed: speed, scale: scale);

      generator
        ..generate(speed: speed, scale: scale)
        ..generate(speed: speed, scale: scale)
        ..generate(speed: speed, scale: scale)
        ..reset();

      final initialFrameAfterReset = generator.generate(
        speed: speed,
        scale: scale,
      );

      expect(identical(initialFrame, initialFrameAfterReset), isFalse);
      expect(initialFrame, equals(initialFrameAfterReset));
    });

    testWidgets(
      'renders correctly',
      (tester) async {
        addTearDown(tester.view.reset);
        tester.view.physicalSize = const Size(128, 128);
        tester.view.devicePixelRatio = 1.0;

        final settings = settingsVariant.currentValue!;
        final generator = ColorFramesGenerator(dimension: settings.dimension);

        await tester.pumpWidget(
          RepaintBoundary(
            child: FramesGeneratorTestSheet(
              generator: generator,
              speed: settings.speed,
              scale: settings.scale,
            ),
          ),
        );

        await expectLater(
          find.byType(FramesGeneratorTestSheet),
          matchesGoldenFile(
            'goldens/color_frames_generator.${settings.id}.png',
          ),
        );
      },
      variant: settingsVariant,
    );
  });
}
