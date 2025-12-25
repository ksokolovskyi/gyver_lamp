import 'package:gyver_lamp_effects/src/generators/fast_led/fast_led.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';

/// {@template zebra_frames_generator}
/// A frames generator which produces zebra effect frames.
/// {@endtemplate}
class ZebraFramesGenerator extends NoiseFramesGenerator {
  /// {@macro zebra_frames_generator}
  ZebraFramesGenerator({
    required super.dimension,
  }) : super(
         blur: 20,
         looped: true,
         palette: const [
           FastLedColors.white,
           FastLedColors.black,
           FastLedColors.black,
           FastLedColors.black,
           //
           FastLedColors.white,
           FastLedColors.black,
           FastLedColors.black,
           FastLedColors.black,
           //
           FastLedColors.white,
           FastLedColors.black,
           FastLedColors.black,
           FastLedColors.black,
           //
           FastLedColors.white,
           FastLedColors.black,
           FastLedColors.black,
           FastLedColors.black,
         ],
       );
}
