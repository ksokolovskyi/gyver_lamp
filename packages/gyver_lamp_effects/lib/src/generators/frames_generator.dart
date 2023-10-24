import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';

/// {@template frames_generator}
/// The base class for a generator that produces frames.
/// {@endtemplate}
abstract class FramesGenerator {
  /// {@macro frames_generator}
  const FramesGenerator({
    required this.dimension,
    required this.blur,
  });

  /// The length of the frame's side.
  final int dimension;

  /// The blur value which need to be applied onto a frame.
  final double blur;

  /// The size of the produced frame.
  @protected
  int get frameSize => dimension * dimension;

  /// Produces the next frame considering the [dimension], [speed], and [scale].
  Frame generate({
    required int speed,
    required int scale,
  });

  /// Resets generator to the initial state.
  void reset();
}
