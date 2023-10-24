import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';

/// {@template frame_painter}
/// Widget which paints [frame] as a square of pixels.
/// {@endtemplate}
class FramePainter extends StatelessWidget {
  /// {@macro frame_painter}
  const FramePainter({
    required this.frame,
    super.key,
  });

  /// The frame which will be painted.
  final Frame frame;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FrameCustomPainter(frame: frame),
    );
  }
}

class _FrameCustomPainter extends CustomPainter {
  const _FrameCustomPainter({required this.frame});

  final Frame frame;

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide / frame.dimension;

    for (var y = 0; y < frame.dimension; y++) {
      final top = y * side;

      for (var x = 0; x < frame.dimension; x++) {
        final left = x * side;

        final r = Rect.fromLTWH(left, top, side, side);

        canvas.drawRect(
          r,
          Paint()
            ..color = frame.data[y * frame.dimension + x]
            ..isAntiAlias = false,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_FrameCustomPainter oldDelegate) {
    return oldDelegate.frame != frame;
  }
}
