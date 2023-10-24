import 'package:control_repository/control_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class ModePicker extends StatelessWidget {
  const ModePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ControlBloc, ControlState>(
      buildWhen: (p, c) => p.mode != c.mode,
      builder: (context, state) {
        return CustomDropdownButton<GyverLampMode>(
          items: GyverLampMode.values.map((mode) {
            return CustomDropdownMenuItem(
              value: mode,
              label: switch (mode) {
                GyverLampMode.sparkles => l10n.sparklesMode,
                GyverLampMode.fire => l10n.fireMode,
                GyverLampMode.rainbowVertical => l10n.rainbowVerticalMode,
                GyverLampMode.rainbowHorizontal => l10n.rainbowHorizontalMode,
                GyverLampMode.colors => l10n.colorsMode,
                GyverLampMode.madness => l10n.madnessMode,
                GyverLampMode.cloud => l10n.cloudsMode,
                GyverLampMode.lava => l10n.lavaMode,
                GyverLampMode.plasma => l10n.plasmaMode,
                GyverLampMode.rainbow => l10n.rainbowMode,
                GyverLampMode.rainbowStripes => l10n.rainbowStripesMode,
                GyverLampMode.zebra => l10n.zebraMode,
                GyverLampMode.forest => l10n.forestMode,
                GyverLampMode.ocean => l10n.oceanMode,
                GyverLampMode.color => l10n.colorMode,
                GyverLampMode.snow => l10n.snowMode,
                GyverLampMode.matrix => l10n.matrixMode,
                GyverLampMode.fireflies => l10n.firefliesMode,
              },
            );
          }).toList(),
          selected: state.mode,
          onChanged: (mode) {
            context.read<ControlBloc>().add(ModeUpdated(mode: mode));
          },
        );
      },
    );
  }
}
