import 'dart:math' as math show Random;

import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';

/// {@template matrix_frames_generator}
/// A frames generator which produces matrix effect frames.
/// {@endtemplate}
final class MatrixFramesGenerator extends FramesGenerator {
  /// {@macro matrix_frames_generator}
  MatrixFramesGenerator({
    required super.dimension,
    math.Random? random,
  })  : _random = random ?? math.Random(),
        super(blur: 3);

  final math.Random _random;

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

    final previousFrame = _previousFrame;

    if (previousFrame == null) {
      final frame = Frame(
        dimension: dimension,
        data: List.generate(
          frameSize,
          (_) => Colors.black,
          growable: false,
        ),
      );

      _previousFrame = frame;

      return frame;
    }

    final data = List<Color>.from(
      previousFrame.data,
      growable: false,
    );

    // Fill the top row.
    for (var x = 0; x < dimension; x++) {
      final color = data[x].value;

      if (color == 0xFF000000) {
        data[x] = _random.nextInt(scale) == 0
            ? const Color(0xFF00FF00)
            : Colors.black;
      } else if (color < 0xFF002000) {
        data[x] = Colors.black;
      } else {
        data[x] = Color(color - 0x00002000);
      }
    }

    // Shift cells in the bottom direction.
    for (var x = 0; x < dimension; x++) {
      for (var y = dimension - 1; y > 0; y--) {
        data[y * dimension + x] = data[(y - 1) * dimension + x];
      }
    }

    final frame = Frame(
      dimension: dimension,
      data: data,
    );

    _previousFrame = frame;

    return frame;
  }

  @override
  void reset() {
    _previousFrame = null;
  }
}
