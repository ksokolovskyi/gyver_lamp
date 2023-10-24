import 'package:gyver_lamp_effects/src/generators/fast_led/fast_led.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';

/// {@template ocean_frames_generator}
/// A frames generator which produces ocean effect frames.
/// {@endtemplate}
class OceanFramesGenerator extends NoiseFramesGenerator {
  /// {@macro ocean_frames_generator}
  OceanFramesGenerator({
    required super.dimension,
  }) : super(
          blur: 20,
          looped: true,
          palette: const [
            FastLedColors.midnightBlue,
            FastLedColors.darkBlue,
            FastLedColors.midnightBlue,
            FastLedColors.navy,
            //
            FastLedColors.darkBlue,
            FastLedColors.mediumBlue,
            FastLedColors.seaGreen,
            FastLedColors.teal,
            //
            FastLedColors.cadetBlue,
            FastLedColors.blue,
            FastLedColors.darkCyan,
            FastLedColors.cornflowerBlue,
            //
            FastLedColors.aquamarine,
            FastLedColors.seaGreen,
            FastLedColors.aqua,
            FastLedColors.lightSkyBlue,
          ],
        );
}
