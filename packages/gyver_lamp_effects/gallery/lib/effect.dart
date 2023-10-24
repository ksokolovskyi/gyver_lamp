import 'package:flutter/material.dart';
import 'package:gyver_lamp_effects/gyver_lamp_effects.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class Effect extends StatefulWidget {
  const Effect({super.key});

  @override
  State<Effect> createState() => _EffectState();
}

class _EffectState extends State<Effect> {
  static const _types = [
    GyverLampEffectType.sparkles,
    GyverLampEffectType.fire,
    GyverLampEffectType.verticalRainbow,
    GyverLampEffectType.horizontalRainbow,
    GyverLampEffectType.colors,
    GyverLampEffectType.madness,
    GyverLampEffectType.clouds,
    GyverLampEffectType.lava,
    GyverLampEffectType.plasma,
    GyverLampEffectType.rainbow,
    GyverLampEffectType.rainbowStripes,
    GyverLampEffectType.zebra,
    GyverLampEffectType.forest,
    GyverLampEffectType.ocean,
    GyverLampEffectType.color,
    GyverLampEffectType.snow,
    GyverLampEffectType.matrix,
    GyverLampEffectType.fireflies,
  ];

  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(60),
          child: AspectRatio(
            aspectRatio: 1,
            child: GyverLampEffect(
              type: _types[_index],
              speed: 30,
              scale: 20,
            ),
          ),
        ),
        GyverLampGaps.lg,
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedElevatedButton.medium(
              child: const Text('<'),
              onPressed: () {
                setState(() {
                  _index = (_index - 1) % _types.length;
                });
              },
            ),
            GyverLampGaps.lg,
            RoundedElevatedButton.medium(
              child: const Text('>'),
              onPressed: () {
                setState(() {
                  _index = (_index + 1) % _types.length;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
