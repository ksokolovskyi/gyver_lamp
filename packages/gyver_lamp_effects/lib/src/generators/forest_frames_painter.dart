import 'package:gyver_lamp_effects/src/generators/fast_led/fast_led.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';

/// {@template forest_frames_generator}
/// A frames generator which produces forest effect frames.
/// {@endtemplate}
class ForestFramesGenerator extends NoiseFramesGenerator {
  /// {@macro forest_frames_generator}
  ForestFramesGenerator({
    required super.dimension,
  }) : super(
          blur: 20,
          looped: true,
          palette: const [
            FastLedColors.darkGreen,
            FastLedColors.darkGreen,
            FastLedColors.darkOliveGreen,
            FastLedColors.darkGreen,
            //
            FastLedColors.green,
            FastLedColors.forestGreen,
            FastLedColors.oliveDrab,
            FastLedColors.green,
            //
            FastLedColors.seaGreen,
            FastLedColors.mediumAquamarine,
            FastLedColors.limeGreen,
            FastLedColors.yellowGreen,
            //
            FastLedColors.lightGreen,
            FastLedColors.lawnGreen,
            FastLedColors.mediumAquamarine,
            FastLedColors.forestGreen,
          ],
        );
}
