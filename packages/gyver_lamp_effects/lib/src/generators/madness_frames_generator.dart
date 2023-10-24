import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/extensions/extensions.dart';
import 'package:gyver_lamp_effects/src/generators/fast_led/fast_led.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';

/// {@template madness_frames_generator}
/// A frames generator which produces madness effect frames.
/// {@endtemplate}
class MadnessFramesGenerator extends FramesGenerator {
  /// {@macro madness_frames_generator}
  MadnessFramesGenerator({
    required super.dimension,
  }) : super(blur: 20) {
    _init();
  }

  int _z = 0;

  late List<int> _noise;

  void _init() {
    _z = 0;
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

    for (var i = 0; i < dimension; i++) {
      final iOffset = scale * i;

      for (var j = 0; j < dimension; j++) {
        final jOffset = scale * j;

        _noise[i * dimension + j] = FastLedNoise.inoise8(
          iOffset,
          jOffset,
          _z,
        );
      }
    }

    _z += speed;
    _z = _z.toUnsigned(16);

    final data = List.generate(frameSize, (_) => Colors.black);

    for (var i = 0; i < dimension; i++) {
      for (var j = 0; j < dimension; j++) {
        final n1 = _noise[j * dimension + i];
        final n2 = _noise[i * dimension + j];

        data[j * dimension + i] = HSLColor.fromAHSL(
          1,
          n1.remap(0, 255, 0, 360),
          1,
          n2.remap(0, 255, 0.3, 0.8),
        ).toColor();
      }
    }

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
