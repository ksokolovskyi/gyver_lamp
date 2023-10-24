import 'dart:math' as math show Random, max;

import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/extensions/extensions.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';

const _kMaxX = 16;
const _kMaxY = 8;

/// {@template fire_frames_generator}
/// A frames generator which produces fire effect frames.
/// {@endtemplate}
final class FireFramesGenerator extends FramesGenerator {
  /// {@macro fire_frames_generator}
  FireFramesGenerator({
    required super.dimension,
    math.Random? random,
  })  : assert(
          dimension >= 16,
          'dimension must be >= 16',
        ),
        _random = random ?? math.Random(),
        super(blur: 5) {
    _init();
  }

  final math.Random _random;

  late int _counter;

  late List<int> _line;

  late List<int> _previousData;

  Frame? _previousFrame;

  static const _valueMask = [
    [32, 0, 0, 0, 0, 0, 0, 32, 32, 0, 0, 0, 0, 0, 0, 32],
    [64, 0, 0, 0, 0, 0, 0, 64, 64, 0, 0, 0, 0, 0, 0, 64],
    [96, 32, 0, 0, 0, 0, 32, 96, 96, 32, 0, 0, 0, 0, 32, 96],
    [128, 64, 32, 0, 0, 32, 64, 128, 128, 64, 32, 0, 0, 32, 64, 128],
    [160, 96, 64, 32, 32, 64, 96, 160, 160, 96, 64, 32, 32, 64, 96, 160],
    [192, 128, 96, 64, 64, 96, 128, 192, 192, 128, 96, 64, 64, 96, 128, 192],
    [
      255,
      160,
      128,
      96,
      96,
      128,
      160,
      255,
      255,
      160,
      128,
      96,
      96,
      128,
      160,
      255,
    ],
    [
      255,
      192,
      160,
      128,
      128,
      160,
      192,
      255,
      255,
      192,
      160,
      128,
      128,
      160,
      192,
      255,
    ],
  ];

  static const _hueMask = [
    [1, 11, 19, 25, 25, 22, 11, 1, 1, 11, 19, 25, 25, 22, 11, 1],
    [1, 8, 13, 19, 25, 19, 8, 1, 1, 8, 13, 19, 25, 19, 8, 1],
    [1, 8, 13, 16, 19, 16, 8, 1, 1, 8, 13, 16, 19, 16, 8, 1],
    [1, 5, 11, 13, 13, 13, 5, 1, 1, 5, 11, 13, 13, 13, 5, 1],
    [1, 5, 11, 11, 11, 11, 5, 1, 1, 5, 11, 11, 11, 11, 5, 1],
    [0, 1, 5, 8, 8, 5, 1, 0, 0, 1, 5, 8, 8, 5, 1, 0],
    [0, 0, 1, 5, 5, 1, 0, 0, 0, 0, 1, 5, 5, 1, 0, 0],
    [0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0],
  ];

  void _init() {
    _counter = 0;

    _line = List.generate(
      dimension,
      (_) => 0,
      growable: false,
    );

    _previousData = List.generate(
      frameSize,
      (_) => 0,
      growable: false,
    );

    _generateLine(_line);
  }

  void _generateLine(List<int> line) {
    for (var x = 0; x < dimension; x++) {
      line[x] = _random.nextInt(255 - 64) + 64;
    }
  }

  void _shiftUp(List<int> data) {
    for (var y = dimension - 1 - _kMaxY; y < dimension - 1; y++) {
      final offset = y * dimension;

      for (var x = 0; x < dimension; x++) {
        data[offset + x] = data[(y + 1) * dimension + x];
      }
    }

    final offset = dimension * (dimension - 1);

    for (var x = 0; x < dimension; x++) {
      data[offset + x] = _line[x];
    }
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

    if (_counter >= 100) {
      _shiftUp(_previousData);
      _generateLine(_line);
      _counter = 0;
    }

    final frameData = List.generate(
      frameSize,
      (_) => Colors.black,
      growable: false,
    );

    for (var y = 0; y < dimension - 1; y++) {
      for (var x = 0; x < dimension; x++) {
        // Index of the current pixel.
        final currentIndex = y * dimension + x;
        // Index of the previous pixel (bottom one).
        final prevIndex = (y + 1) * dimension + x;

        switch (dimension - 1 - y) {
          case > _kMaxY:
            final color = _previousFrame?.data[prevIndex];
            frameData[currentIndex] = color ?? Colors.black;

          case == _kMaxY:
            final color = _previousFrame?.data[prevIndex] ?? Colors.black;
            final random = _random.nextInt(20);

            if (random == 0 && color != Colors.black) {
              frameData[currentIndex] = color;
            } else {
              frameData[currentIndex] = Colors.black;
            }

          default:
            final maskX = x % _kMaxX;
            final maskY = dimension - 2 - y;

            final hueMask = _hueMask[maskY][maskX];
            final valueMask = _valueMask[maskY][maskX];

            final hue = (scale * 2.5 + hueMask).toInt();

            final d1 = _previousData[currentIndex];
            final d2 = _previousData[(y + 1) * dimension + x];
            final value =
                (((100 - _counter) * d1 + _counter * d2) ~/ 100) - valueMask;

            final color = HSVColor.fromAHSV(
              1,
              hue.toUnsigned(8).remap(0, 255, 0, 360),
              1,
              math.max(0, value).toUnsigned(8).remap(0, 255, 0, 1),
            );

            frameData[currentIndex] = color.toColor();
        }
      }
    }

    final offset = dimension * (dimension - 1);

    for (var x = 0; x < dimension; x++) {
      final maskX = x % _kMaxX;
      final hueMask = _hueMask[0][maskX];

      final hue = (scale * 2.5 + hueMask).toInt();

      final d = _previousData[offset + x];
      final l = _line[x];
      final value = ((100 - _counter) * d + _counter * l) ~/ 100;

      final color = HSVColor.fromAHSV(
        1,
        hue.toUnsigned(8).remap(0, 255, 0, 360),
        1,
        value.toUnsigned(8).remap(0, 255, 0, 1),
      );

      frameData[offset + x] = color.toColor();
    }

    _counter += 30;

    final frame = Frame(
      dimension: dimension,
      data: frameData,
    );

    _previousFrame = frame;

    return frame;
  }

  @override
  void reset() {
    _previousFrame = null;
    _init();
  }
}
