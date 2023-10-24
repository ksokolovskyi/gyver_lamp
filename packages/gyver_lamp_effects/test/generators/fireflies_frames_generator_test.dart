import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';

import '../helpers/frames_generator_test_sheet.dart';
import '../helpers/generator_settings_variant.dart';

void main() {
  group('FirefliesFramesGenerator', () {
    final settingsVariant = GeneratorSettingsVariant.all();

    test('has correct blur value', () {
      expect(FirefliesFramesGenerator(dimension: 16).blur, equals(3));
    });

    testWidgets(
      'renders correctly',
      (tester) async {
        addTearDown(tester.view.reset);
        tester.view.physicalSize = const Size(128, 128);
        tester.view.devicePixelRatio = 1.0;

        final settings = settingsVariant.currentValue!;
        final generator = FirefliesFramesGenerator(
          dimension: settings.dimension,
          random: math.Random(3333),
        );

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
            'goldens/fireflies_frames_generator.${settings.id}.png',
          ),
        );
      },
      variant: settingsVariant,
    );
  });
}
