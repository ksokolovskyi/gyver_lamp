import 'dart:math' as math show Random;

import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';

const _kMaxFirefliesCount = 100;

/// {@template fireflies_frames_generator}
/// A frames generator which produces fireflies effect frames.
/// {@endtemplate}
final class FirefliesFramesGenerator extends FramesGenerator {
  /// {@macro fireflies_frames_generator}
  FirefliesFramesGenerator({
    required super.dimension,
    math.Random? random,
  })  : _random = random ?? math.Random(),
        super(blur: 3) {
    _init();
  }

  final math.Random _random;

  late int _counter;

  late List<({int x, int y})> _position;
  late List<({int h, int v})> _speed;
  late List<Color> _color;

  void _init() {
    _counter = 0;

    _position = List.generate(
      _kMaxFirefliesCount,
      (_) => (x: 0, y: 0),
    );

    _speed = List.generate(
      _kMaxFirefliesCount,
      (_) => (h: 0, v: 0),
    );

    _color = List.generate(
      _kMaxFirefliesCount,
      (_) => Colors.black,
    );

    for (var i = 0; i < _kMaxFirefliesCount; i++) {
      _position[i] = (
        x: _random.nextInt(dimension * 10),
        y: _random.nextInt(dimension * 10),
      );

      _speed[i] = (
        h: _random.nextInt(20) - 10,
        v: _random.nextInt(20) - 10,
      );

      _color[i] = HSLColor.fromAHSL(
        1,
        _random.nextInt(360).toDouble(),
        1,
        0.6,
      ).toColor();
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

    _counter = (_counter + 1) % 20;

    final data = List.generate(
      frameSize,
      (_) => Colors.black,
      growable: false,
    );

    final amount = scale.clamp(1, _kMaxFirefliesCount);

    for (var i = 0; i < amount; i++) {
      if (_counter == 0) {
        final speed = _speed[i];

        final dh = _random.nextInt(8) - 4;
        final dv = _random.nextInt(8) - 4;

        _speed[i] = (
          h: (speed.h + dh).clamp(-20, 20),
          v: (speed.v + dv).clamp(-20, 20),
        );
      }

      var position = _position[i];
      var speed = _speed[i];

      var newX = position.x + speed.h;
      var newY = position.y + speed.v;

      if (newX < 0) {
        newX = (dimension - 1) * 10;
      } else if (newX >= dimension * 10) {
        newX = 0;
      }

      if (newY < 0) {
        newY = 0;
        speed = (h: speed.h, v: -speed.v);
      } else if (newY >= dimension * 10) {
        newY = (dimension - 1) * 10;
        speed = (h: speed.h, v: -speed.v);
      }

      position = (x: newX, y: newY);

      _position[i] = position;
      _speed[i] = speed;

      final x = position.x ~/ 10;
      final y = position.y ~/ 10;

      data[y * dimension + x] = _color[i];
    }

    final frame = Frame(
      dimension: dimension,
      data: data,
    );

    return frame;
  }

  @override
  void reset() {
    _init();
  }
}
