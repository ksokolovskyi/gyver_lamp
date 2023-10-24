import 'package:control_repository/control_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp_effects/gyver_lamp_effects.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class Effect extends StatefulWidget {
  const Effect({super.key});

  @override
  State<Effect> createState() => _EffectState();
}

class _EffectState extends State<Effect> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 400,
        maxWidth: 400,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: GyverLampSpacings.xxlg * 2,
          vertical: GyverLampSpacings.xxlg,
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: BlocBuilder<ControlBloc, ControlState>(
            buildWhen: (p, c) {
              return p.mode != c.mode ||
                  p.speed != c.speed ||
                  p.scale != c.scale;
            },
            builder: (context, state) {
              final type = switch (state.mode) {
                GyverLampMode.sparkles => GyverLampEffectType.sparkles,
                GyverLampMode.fire => GyverLampEffectType.fire,
                GyverLampMode.rainbowVertical =>
                  GyverLampEffectType.verticalRainbow,
                GyverLampMode.rainbowHorizontal =>
                  GyverLampEffectType.horizontalRainbow,
                GyverLampMode.colors => GyverLampEffectType.colors,
                GyverLampMode.madness => GyverLampEffectType.madness,
                GyverLampMode.cloud => GyverLampEffectType.clouds,
                GyverLampMode.lava => GyverLampEffectType.lava,
                GyverLampMode.plasma => GyverLampEffectType.plasma,
                GyverLampMode.rainbow => GyverLampEffectType.rainbow,
                GyverLampMode.rainbowStripes =>
                  GyverLampEffectType.rainbowStripes,
                GyverLampMode.zebra => GyverLampEffectType.zebra,
                GyverLampMode.forest => GyverLampEffectType.forest,
                GyverLampMode.ocean => GyverLampEffectType.ocean,
                GyverLampMode.color => GyverLampEffectType.color,
                GyverLampMode.snow => GyverLampEffectType.snow,
                GyverLampMode.matrix => GyverLampEffectType.matrix,
                GyverLampMode.fireflies => GyverLampEffectType.fireflies,
              };

              return GyverLampEffect(
                type: type,
                speed: state.speed,
                scale: state.scale,
              );
            },
          ),
        ),
      ),
    );
  }
}
