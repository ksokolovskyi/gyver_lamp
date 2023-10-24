import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/extensions/extensions.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';

/// {@template color_frames_generator}
/// A frames generator which produces solid color frames.
/// {@endtemplate}
final class ColorFramesGenerator extends FramesGenerator {
  /// {@macro color_frames_generator}
  ColorFramesGenerator({
    required super.dimension,
  }) : super(blur: 0);

  int? _previousScale;

  Frame? _previousFrame;

  @override
  Frame generate({
    required int scale,
    required int speed,
  }) {
    assert(
      scale >= 1 && scale <= 255,
      'the scale value must be in range [1, 255]',
    );

    if (scale == _previousScale && _previousFrame != null) {
      return _previousFrame!;
    }

    final color = HSLColor.fromAHSL(
      1,
      (scale.remap(0, 255, 0, 360) * 2.5) % 360,
      1,
      0.7,
    ).toColor();

    final data = List.generate(
      frameSize,
      (_) => color,
      growable: false,
    );

    final frame = Frame(
      dimension: dimension,
      data: data,
    );

    _previousScale = scale;
    _previousFrame = frame;

    return frame;
  }

  @override
  void reset() {
    _previousScale = null;
    _previousFrame = null;
  }
}
