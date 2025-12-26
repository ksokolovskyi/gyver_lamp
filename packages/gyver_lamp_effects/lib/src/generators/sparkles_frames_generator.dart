import 'dart:math' as math show Random;

import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/generators/fast_led/fast_led.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';

/// {@template sparkles_frames_generator}
/// A frames generator which produces sparkles effect frames.
/// {@endtemplate}
final class SparklesFramesGenerator extends FramesGenerator {
  /// {@macro sparkles_frames_generator}
  SparklesFramesGenerator({
    required super.dimension,
    math.Random? random,
  }) : _random = random ?? math.Random(),
       super(blur: 3);

  final math.Random _random;

  List<Color>? _sparkles;

  @override
  Frame generate({
    required int scale,
    required int speed,
  }) {
    assert(
      scale >= 1 && scale <= 255,
      'the scale value must be in range [1, 255]',
    );

    final sparkles = _sparkles;

    if (sparkles == null) {
      _sparkles = List<Color>.generate(
        frameSize,
        (_) => Colors.black,
        growable: false,
      );

      return Frame(
        dimension: dimension,
        data: List<Color>.from(_sparkles!),
      );
    }

    for (var i = 0; i < scale; i++) {
      final x = _random.nextInt(dimension);
      final y = _random.nextInt(dimension);

      final index = y * dimension + x;

      final sparkle = sparkles[index];

      if (sparkle == Colors.black) {
        sparkles[index] = HSLColor.fromAHSL(
          1,
          _random.nextInt(360).toDouble(),
          1,
          0.6,
        ).toColor();
      }
    }

    final frame = Frame(
      dimension: dimension,
      data: List<Color>.from(sparkles),
    );

    for (var y = 0; y < dimension; y++) {
      for (var x = 0; x < dimension; x++) {
        final index = y * dimension + x;

        final color = sparkles[index];

        final r = (color.r * 255.0).round().clamp(0, 255);
        final g = (color.g * 255.0).round().clamp(0, 255);
        final b = (color.b * 255.0).round().clamp(0, 255);

        if (r >= 30 || g >= 30 || b >= 30) {
          sparkles[index] = Color.fromARGB(
            (color.a * 255.0).round().clamp(0, 255),
            FastLedMath.scale8(r, 70),
            FastLedMath.scale8(g, 70),
            FastLedMath.scale8(b, 70),
          );
        } else {
          sparkles[index] = Colors.black;
        }
      }
    }

    return frame;
  }

  @override
  void reset() {
    _sparkles = null;
  }
}
