import 'package:gyver_lamp_effects/src/generators/generators.dart';

/// {@template rainbow_stripes_frames_generator}
/// A frames generator which produces rainbow stripes effect frames.
/// {@endtemplate}
class RainbowStripesFramesGenerator extends NoiseFramesGenerator {
  /// {@macro rainbow_stripes_frames_generator}
  RainbowStripesFramesGenerator({
    required super.dimension,
  }) : super(
          blur: 20,
          looped: true,
          palette: const [
            0xFF0000,
            0x000000,
            0xAB5500,
            0x000000,
            //
            0xABAB00,
            0x000000,
            0x00FF00,
            0x000000,
            //
            0x00AB55,
            0x000000,
            0x0000FF,
            0x000000,
            //
            0x5500AB,
            0x000000,
            0xAB0055,
            0x000000,
          ],
        );
}
