import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const kFadeDuration = Duration(milliseconds: 600);
  static const kAnimationDuration = Duration(milliseconds: 2000);

  @override
  State<SplashPage> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: SplashPage.kFadeDuration,
  );

  @visibleForTesting
  AnimationController? get debugAnimationController {
    AnimationController? controller;

    // ignore: prefer_asserts_with_message
    assert(() {
      controller = _controller;
      return true;
    }());

    return controller;
  }

  late final _animation = TweenSequence<double>(
    [
      TweenSequenceItem(
        tween: CurveTween(curve: Curves.easeInQuad),
        weight: 0.8,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1),
        weight: 0.2,
      ),
    ],
  ).animate(_controller);

  late final StateMachineController? _stateController;

  @override
  void dispose() {
    _controller.dispose();
    _stateController?.dispose();
    super.dispose();
  }

  void _animate(Artboard artboard) {
    final stateController = StateMachineController.fromArtboard(
      artboard,
      'machine',
    )!;

    _stateController = stateController;

    artboard.addController(stateController);

    _controller
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          (stateController.findInput<bool>('connected')! as SMIBool).change(
            false,
          );
        }
      })
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF142230);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: color,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: ColoredBox(
        color: color,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: AspectRatio(
              aspectRatio: 1.6,
              child: ColoredBox(
                color: Colors.transparent,
                child: FadeTransition(
                  opacity: _animation,
                  child: RiveAnimation.asset(
                    'assets/switch.riv',
                    fit: BoxFit.fitWidth,
                    onInit: _animate,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
