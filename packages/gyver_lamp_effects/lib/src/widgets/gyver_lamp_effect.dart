import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/src/generators/generators.dart';
import 'package:gyver_lamp_effects/src/models/models.dart';
import 'package:gyver_lamp_effects/src/widgets/widgets.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

/// {@template gyver_lamp_effect}
/// The widget which visualizes [GyverLampEffectType] effect.
/// {@endtemplate}
class GyverLampEffect extends StatefulWidget {
  /// {@macro gyver_lamp_effect}
  const GyverLampEffect({
    required this.type,
    required this.speed,
    required this.scale,
    this.dimension = 16,
    super.key,
  });

  /// The type of effect to show.
  final GyverLampEffectType type;

  /// The speed of the effect.
  final int speed;

  /// The scale of the effect.
  final int scale;

  /// The dimension of the effect frame.
  final int dimension;

  @override
  State<GyverLampEffect> createState() => _GyverLampEffectState();
}

class _GyverLampEffectState extends State<GyverLampEffect> {
  static const _generators = {
    GyverLampEffectType.sparkles: SparklesFramesGenerator.new,
    GyverLampEffectType.fire: FireFramesGenerator.new,
    GyverLampEffectType.verticalRainbow: VerticalRainbowFramesGenerator.new,
    GyverLampEffectType.horizontalRainbow: HorizontalRainbowFramesGenerator.new,
    GyverLampEffectType.colors: ColorsFramesGenerator.new,
    GyverLampEffectType.madness: MadnessFramesGenerator.new,
    GyverLampEffectType.clouds: CloudsFramesGenerator.new,
    GyverLampEffectType.lava: LavaFramesGenerator.new,
    GyverLampEffectType.plasma: PlasmaFramesGenerator.new,
    GyverLampEffectType.rainbow: RainbowFramesGenerator.new,
    GyverLampEffectType.rainbowStripes: RainbowStripesFramesGenerator.new,
    GyverLampEffectType.zebra: ZebraFramesGenerator.new,
    GyverLampEffectType.forest: ForestFramesGenerator.new,
    GyverLampEffectType.ocean: OceanFramesGenerator.new,
    GyverLampEffectType.color: ColorFramesGenerator.new,
    GyverLampEffectType.snow: SnowFramesGenerator.new,
    GyverLampEffectType.matrix: MatrixFramesGenerator.new,
    GyverLampEffectType.fireflies: FirefliesFramesGenerator.new,
  };

  final ValueNotifier<bool> _paused = ValueNotifier(true);

  late FramesGenerator _generator;

  @override
  void initState() {
    super.initState();
    _generator = _generators[widget.type]!(dimension: widget.dimension);
  }

  @override
  void didUpdateWidget(GyverLampEffect oldWidget) {
    if (oldWidget.type != widget.type) {
      _generator = _generators[widget.type]!(dimension: widget.dimension);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _paused.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return Fidgeter(
      foregroundChild: Positioned(
        bottom: GyverLampSpacings.md,
        right: GyverLampSpacings.md,
        child: ValueListenableBuilder(
          valueListenable: _paused,
          builder: (context, paused, _) {
            return FlatIconButton.large(
              icon: paused ? GyverLampIcons.play : GyverLampIcons.pause,
              onPressed: () {
                _paused.value = !paused;
              },
            );
          },
        ),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [theme.shadows.shadow4],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            reverseDuration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            layoutBuilder: (
              Widget? currentChild,
              List<Widget> previousChildren,
            ) {
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ...previousChildren.map(
                    (e) => Positioned.fill(child: e),
                  ),
                  if (currentChild != null)
                    Positioned.fill(child: currentChild),
                ],
              );
            },
            child: Transform.scale(
              key: ValueKey(widget.type),
              scale: 1.1,
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.compose(
                  outer: ui.ImageFilter.blur(
                    sigmaX: _generator.blur,
                    sigmaY: _generator.blur,
                    tileMode: TileMode.mirror,
                  ),
                  inner: ui.ColorFilter.mode(
                    Colors.white.withOpacity(0.05),
                    BlendMode.lighten,
                  ),
                ),
                child: ValueListenableBuilder(
                  valueListenable: _paused,
                  builder: (context, paused, _) {
                    return FramesBuilder(
                      generator: _generator,
                      speed: widget.speed,
                      scale: widget.scale,
                      paused: paused,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
