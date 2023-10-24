import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';
import 'package:gyver_lamp_effects/src/widgets/widgets.dart';

/// {@template frames_builder}
/// The widget which visualizes frames built by [FramesGenerator].
/// {@endtemplate}
class FramesBuilder extends StatefulWidget {
  /// {@macro frames_builder}
  const FramesBuilder({
    required this.generator,
    required this.speed,
    required this.scale,
    required this.paused,
    super.key,
  });

  /// The generator to get frames from.
  final FramesGenerator generator;

  /// The speed value which will be passed to the [generator].
  final int speed;

  /// The scale value which will be passed to the [generator].
  final int scale;

  /// Whether builder is paused.
  final bool paused;

  @override
  State<FramesBuilder> createState() => _FramesBuilderState();
}

class _FramesBuilderState extends State<FramesBuilder> {
  Timer? _timer;

  late Frame _frame;

  @override
  void initState() {
    super.initState();

    if (widget.paused) {
      widget.generator.reset();
    }

    _frame = widget.generator.generate(
      speed: widget.speed,
      scale: widget.scale,
    );

    if (widget.paused) {
      return;
    }

    _startTimer();
  }

  @override
  void didUpdateWidget(FramesBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if ((oldWidget.generator != widget.generator ||
            oldWidget.scale != widget.scale) &&
        widget.paused) {
      _frame = widget.generator.generate(
        speed: widget.speed,
        scale: widget.scale,
      );
    }

    if (oldWidget.paused != widget.paused) {
      if (widget.paused) {
        // If builder is paused then we just cancel timer and stop animation
        // without care of speed change, etc.
        _cancelTimer();
        return;
      }

      _startTimer();
    }

    if (oldWidget.speed != widget.speed && !widget.paused) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void _startTimer() {
    _cancelTimer();

    _timer = Timer.periodic(
      Duration(milliseconds: widget.speed),
      (timer) {
        if (!timer.isActive || !mounted) {
          return;
        }

        setState(() {
          _frame = widget.generator.generate(
            speed: widget.speed,
            scale: widget.scale,
          );
        });
      },
    );
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FramePainter(frame: _frame),
    );
  }
}
