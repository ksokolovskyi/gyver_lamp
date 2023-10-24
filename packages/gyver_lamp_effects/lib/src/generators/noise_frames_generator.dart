import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/generators/fast_led/fast_led.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';

/// {@template noise_frames_generator}
/// The base class for a generator that produces frames using Perlin noise.
/// {@endtemplate}
abstract class NoiseFramesGenerator extends FramesGenerator {
  /// {@macro noise_frames_generator}
  NoiseFramesGenerator({
    required super.dimension,
    required this.palette,
    required super.blur,
    this.looped = false,
  }) : assert(palette.length == 16, 'palette length must be equal 16') {
    _init();
  }

  /// The list of 16 colors which will be used to produce frames.
  ///
  /// Each color have to be in RGB format.
  /// The bits are interpreted as follows:
  ///
  /// * Bits 16-23 are the red value.
  /// * Bits 8-15 are the green value.
  /// * Bits 0-7 are the blue value.
  final List<int> palette;

  /// Whether the effect is looped.
  final bool looped;

  int _x = 0;

  int _y = 0;

  int _z = 0;

  int _hue = 0;

  late List<int> _noise;

  void _init() {
    _x = 0;
    _y = 0;
    _z = 0;
    _hue = 0;

    _noise = List.generate(frameSize, (_) => 0);
  }

  @override
  Frame generate({
    required int scale,
    required int speed,
  }) {
    assert(
      scale >= 1 && scale <= 255,
      'the scale value must be in range [1, 255]',
    );

    final dataSmoothing = speed < 50 ? (200 - (speed * 4)).toUnsigned(8) : 0;

    for (var i = 0; i < dimension; i++) {
      final iOffset = scale * i;

      for (var j = 0; j < dimension; j++) {
        final jOffset = scale * j;

        var data = FastLedNoise.inoise8(_x + iOffset, _y + jOffset, _z);

        data = FastLedMath.qsub8(data, 16);
        data = FastLedMath.qadd8(
          data,
          FastLedMath.scale8(data, 39),
        );

        if (dataSmoothing != 0) {
          final old = _noise[i * dimension + j];
          data = FastLedMath.scale8(old, dataSmoothing) +
              FastLedMath.scale8(data, 256 - dataSmoothing);
        }

        _noise[i * dimension + j] = data.toUnsigned(8);
      }
    }

    _z += speed;
    _z = _z.toUnsigned(16);

    // apply slow drift to X and Y, just for visual variation.
    _x += speed ~/ 8;
    _x = _x.toUnsigned(16);
    _y -= speed ~/ 16;
    _y = _y.toUnsigned(16);

    final data = List.generate(
      frameSize,
      (_) => Colors.black,
      growable: false,
    );

    for (var i = 0; i < dimension; i++) {
      for (var j = 0; j < dimension; j++) {
        var index = _noise[j * dimension + i];

        if (looped) {
          index += _hue;
        }

        data[i * dimension + j] = Color(
          FastLedColors.colorFromPalette(
            palette: palette,
            index: index,
            brightness: 255,
          ),
        );
      }
    }

    _hue += 1;
    _hue = _hue.toUnsigned(8);

    return Frame(
      dimension: dimension,
      data: data,
    );
  }

  @override
  void reset() {
    _init();
  }
}
