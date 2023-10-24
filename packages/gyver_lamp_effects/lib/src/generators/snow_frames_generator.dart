import 'dart:math' as math show Random;

import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';

/// {@template snow_frames_generator}
/// A frames generator which produces snow effect frames.
/// {@endtemplate}
final class SnowFramesGenerator extends FramesGenerator {
  /// {@macro snow_frames_generator}
  SnowFramesGenerator({
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

    if (previousFrame == null || previousFrame.dimension != dimension) {
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

    // Shift all the flakes in the bottom direction.
    for (var x = 0; x < dimension; x++) {
      for (var y = dimension - 1; y > 0; y--) {
        data[y * dimension + x] = data[(y - 1) * dimension + x];
      }
    }

    // Randomly fill the top row with the snow flakes.
    for (var x = 0; x < dimension; x++) {
      if (data[dimension + x] == Colors.black && _random.nextInt(scale) == 0) {
        data[x] = Color(
          0xFFE0FFFF - 0x00101010 * _random.nextInt(4),
        );
      } else {
        data[x] = Colors.black;
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
