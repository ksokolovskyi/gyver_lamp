import 'package:gyver_lamp_effects/src/generators/generators.dart';

/// {@template rainbow_frames_generator}
/// A frames generator which produces rainbow effect frames.
/// {@endtemplate}
class RainbowFramesGenerator extends NoiseFramesGenerator {
  /// {@macro rainbow_frames_generator}
  RainbowFramesGenerator({
    required super.dimension,
  }) : super(
          blur: 20,
          looped: true,
          palette: const [
            0xFF0000,
            0xD52A00,
            0xAB5500,
            0xAB7F00,
            //
            0xABAB00,
            0x56D500,
            0x00FF00,
            0x00D52A,
            //
            0x00AB55,
            0x0056AA,
            0x0000FF,
            0x2A00D5,
            //
            0x5500AB,
            0x7F0081,
            0xAB0055,
            0xD5002B,
          ],
        );
}
