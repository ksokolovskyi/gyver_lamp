import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// {@template frame}
/// Representation of the one frame state of the effect.
///
/// Each [Frame] contains [data] which is the the list of colors for each pixel
/// of the rectangular grid with side equal to [dimension].
/// {@endtemplate}
final class Frame extends Equatable {
  /// {@macro frame}
  // ignore: prefer_const_constructors_in_immutables
  Frame({
    required this.dimension,
    required this.data,
  }) : assert(
         dimension > 0,
         'dimension must be greater that 0',
       ),
       assert(
         data.length == dimension * dimension,
         'data length must be equal to dimension^2',
       );

  /// The length of the frame's side.
  final int dimension;

  /// The list of colors for each pixel of the rectangular grid with the side
  /// equal to [dimension].
  final List<Color> data;

  @override
  List<Object> get props => [dimension, data];
}
