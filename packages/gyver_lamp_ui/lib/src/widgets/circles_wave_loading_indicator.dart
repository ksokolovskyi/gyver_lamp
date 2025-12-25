import 'dart:math' as math show pi, sin;

import 'package:flutter/material.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

/// {@template circles_wave_loading_indicator}
/// Gyver Lamp Circles Wave Loading Indicator.
/// {@endtemplate}
class CirclesWaveLoadingIndicator extends StatefulWidget {
  /// {@macro circles_wave_loading_indicator}
  const CirclesWaveLoadingIndicator({
    this.size = 10.0,
    this.color = Colors.black,
    this.duration = const Duration(seconds: 1),
    super.key,
  });

  /// The size of the circle.
  final double size;

  /// The color of the circle.
  final Color? color;

  /// The duration of the one animation cycle.
  final Duration duration;

  @override
  State<CirclesWaveLoadingIndicator> createState() =>
      _CirclesWaveLoadingIndicatorState();
}

class _CirclesWaveLoadingIndicatorState
    extends State<CirclesWaveLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _animations = [
      _DelayedTween(
        begin: -0.5,
        end: 0.5,
        delay: 0,
      ).animate(_controller),
      _DelayedTween(
        begin: -0.5,
        end: 0.5,
        delay: 0.2,
      ).animate(_controller),
      _DelayedTween(
        begin: -0.5,
        end: 0.5,
        delay: 0.4,
      ).animate(_controller),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: widget.size * 3 + widget.size,
        height: widget.size * 3,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ..._animations
                  .map(
                    (animation) {
                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, widget.size * animation.value),
                            child: child,
                          );
                        },
                        child: SizedBox.square(
                          dimension: widget.size,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.color,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                  .intersperse(
                    SizedBox(width: widget.size / 2),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DelayedTween extends Tween<double> {
  _DelayedTween({
    required this.delay,
    super.begin,
    super.end,
  });

  final double delay;

  @override
  double lerp(double t) {
    return super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);
  }

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
