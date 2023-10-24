import 'package:gyver_lamp_effects/src/generators/fast_led/fast_led.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';

/// {@template lava_frames_generator}
/// A frames generator which produces lava effect frames.
/// {@endtemplate}
class LavaFramesGenerator extends NoiseFramesGenerator {
  /// {@macro lava_frames_generator}
  LavaFramesGenerator({
    required super.dimension,
  }) : super(
          blur: 20,
          palette: const [
            FastLedColors.black,
            FastLedColors.maroon,
            FastLedColors.black,
            FastLedColors.maroon,
            //
            FastLedColors.darkRed,
            FastLedColors.darkRed,
            FastLedColors.maroon,
            FastLedColors.darkRed,
            //
            FastLedColors.darkRed,
            FastLedColors.darkRed,
            FastLedColors.red,
            FastLedColors.orange,
            //
            FastLedColors.white,
            FastLedColors.orange,
            FastLedColors.red,
            FastLedColors.darkRed,
          ],
        );
}
