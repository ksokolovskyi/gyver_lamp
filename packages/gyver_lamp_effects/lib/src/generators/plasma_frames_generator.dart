import 'package:gyver_lamp_effects/src/generators/generators.dart';

/// {@template plasma_frames_generator}
/// A frames generator which produces plasma effect frames.
/// {@endtemplate}
class PlasmaFramesGenerator extends NoiseFramesGenerator {
  /// {@macro plasma_frames_generator}
  PlasmaFramesGenerator({
    required super.dimension,
  }) : super(
          blur: 20,
          palette: const [
            0x5500AB,
            0x84007C,
            0xB5004B,
            0xE5001B,
            //
            0xE81700,
            0xB84700,
            0xAB7700,
            0xABAB00,
            //
            0xAB5500,
            0xDD2200,
            0xF2000E,
            0xC2003E,
            //
            0x8F0071,
            0x5F00A1,
            0x2F00D0,
            0x0007F9,
          ],
        );
}
