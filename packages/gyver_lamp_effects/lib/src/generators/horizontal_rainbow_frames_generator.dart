import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/extensions/extensions.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';

/// {@template horizontal_rainbow_frames_generator}
/// A frames generator which produces horizontal rainbow effect frames.
/// {@endtemplate}
final class HorizontalRainbowFramesGenerator extends FramesGenerator {
  /// {@macro horizontal_rainbow_frames_generator}
  HorizontalRainbowFramesGenerator({
    required super.dimension,
  }) : super(blur: 10);

  int _hue = 0;

  @override
  Frame generate({
    required int scale,
    required int speed,
  }) {
    assert(
      scale >= 1 && scale <= 255,
      'the scale value must be in range [1, 255]',
    );

    _hue = (_hue + 2).toUnsigned(8);

    final data = List.generate(
      frameSize,
      (_) => Colors.black,
      growable: false,
    );

    for (var x = 0; x < dimension; x++) {
      final hue = (_hue + x * scale).toUnsigned(8).remap(0, 255, 0, 360);

      final color = HSLColor.fromAHSL(1, hue, 1, 0.7).toColor();

      for (var y = 0; y < dimension; y++) {
        data[y * dimension + x] = color;
      }
    }

    return Frame(
      dimension: dimension,
      data: data,
    );
  }

  @override
  void reset() {
    _hue = 0;
  }
}
