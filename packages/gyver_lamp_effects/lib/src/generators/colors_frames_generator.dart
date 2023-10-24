import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/extensions/extensions.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';

/// {@template colors_frames_generator}
/// A frames generator which produces colored frames.
/// {@endtemplate}
final class ColorsFramesGenerator extends FramesGenerator {
  /// {@macro colors_frames_generator}
  ColorsFramesGenerator({
    required super.dimension,
  }) : super(blur: 0);

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

    _hue = (_hue + scale).toUnsigned(8);

    final color = HSLColor.fromAHSL(
      1,
      _hue.remap(0, 255, 0, 360),
      1,
      0.7,
    ).toColor();

    final data = List.generate(
      frameSize,
      (_) => color,
      growable: false,
    );

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
