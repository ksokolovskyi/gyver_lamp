import 'package:gyver_lamp_effects/src/generators/fast_led/fast_led.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';

/// {@template clouds_frames_generator}
/// A frames generator which produces clouds effect frames.
/// {@endtemplate}
class CloudsFramesGenerator extends NoiseFramesGenerator {
  /// {@macro clouds_frames_generator}
  CloudsFramesGenerator({
    required super.dimension,
  }) : super(
          blur: 20,
          looped: true,
          palette: const [
            FastLedColors.blue,
            FastLedColors.darkBlue,
            FastLedColors.darkBlue,
            FastLedColors.darkBlue,
            //
            FastLedColors.darkBlue,
            FastLedColors.darkBlue,
            FastLedColors.darkBlue,
            FastLedColors.darkBlue,
            //
            FastLedColors.blue,
            FastLedColors.darkBlue,
            FastLedColors.skyBlue,
            FastLedColors.skyBlue,
            //
            FastLedColors.lightBlue,
            FastLedColors.white,
            FastLedColors.lightBlue,
            FastLedColors.skyBlue,
          ],
        );
}
