import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/extensions/extensions.dart';

/// The maximal rotation in radians.
const kMaxRotation = 0.1;

/// {@template fidgeter}
/// Widget which adds interactivity to the [child]. Interactivity means, that
/// [child] starts to slightly rotate according to the taps on the sides.
/// {@endtemplate}
class Fidgeter extends StatefulWidget {
  /// {@macro fidgeter}
  const Fidgeter({
    required this.child,
    this.foregroundChild,
    super.key,
  });

  /// The child widget which will be rotated.
  final Widget child;

  /// The widget which will be painted above the [child].
  final Widget? foregroundChild;

  @override
  State<Fidgeter> createState() => _FidgeterState();
}

class _FidgeterState extends State<Fidgeter>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 150),
    vsync: this,
  );

  static const _startPosition = Offset(0.5, 0.5);

  final _tapCenterTween = Tween<Offset>(
    begin: _startPosition,
    end: _startPosition,
  );

  Offset get _tapCenter => _tapCenterTween
      .chain(CurveTween(curve: Curves.easeInOut))
      .evaluate(_controller);

  Matrix4 get _transformation {
    final tapCenter = _tapCenter;

    final xRotation = tapCenter.dy.remap(0, 1, -kMaxRotation, kMaxRotation);
    final yRotation = tapCenter.dx.remap(0, 1, kMaxRotation, -kMaxRotation);

    return Matrix4.identity()
      ..setEntry(3, 2, 0.005)
      ..multiply(Matrix4.rotationX(xRotation))
      ..multiply(Matrix4.rotationY(yRotation));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _transform({
    required Offset localPosition,
    required Size size,
  }) {
    _tapCenterTween
      ..begin = _tapCenterTween.end
      ..end = Offset(
        (localPosition.dx / size.width).clamp(0, 1),
        (localPosition.dy / size.height).clamp(0, 1),
      );

    _controller
      ..reset()
      ..forward();
  }

  void _reset() {
    if (_tapCenterTween.end == _startPosition) {
      return;
    }

    _tapCenterTween
      ..begin = _tapCenterTween.end
      ..end = _startPosition;

    _controller
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: _transformation,
            child: child,
          );
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.biggest;

                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTapDown: (d) => _transform(
                        localPosition: d.localPosition,
                        size: size,
                      ),
                      onPanStart: (d) => _transform(
                        localPosition: d.localPosition,
                        size: size,
                      ),
                      onPanUpdate: (d) => _transform(
                        localPosition: d.localPosition,
                        size: size,
                      ),
                      onPanCancel: _reset,
                      onPanEnd: (_) => _reset(),
                      onTapUp: (_) => _reset(),
                      behavior: HitTestBehavior.opaque,
                      child: widget.child,
                    ),
                  );
                },
              ),
            ),
            if (widget.foregroundChild != null) widget.foregroundChild!,
          ],
        ),
      ),
    );
  }
}
