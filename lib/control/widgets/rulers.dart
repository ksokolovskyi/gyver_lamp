import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class ControlRulers extends StatelessWidget {
  const ControlRulers({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Row(
        children: [
          Column(
            children: [
              _RulerName(
                icon: GyverLampIcons.sun,
                label: l10n.brightness,
              ),
              GyverLampGaps.xlgsm,
              _RulerName(
                icon: GyverLampIcons.speed,
                label: l10n.speed,
              ),
              GyverLampGaps.xlgsm,
              _RulerName(
                icon: GyverLampIcons.scale,
                label: l10n.scale,
              ),
            ],
          ),
          GyverLampGaps.xlgsm,
          Expanded(
            child: Column(
              children: [
                BlocBuilder<ControlBloc, ControlState>(
                  buildWhen: (p, c) => p.brightness != c.brightness,
                  builder: (context, state) {
                    return Ruler(
                      value: state.brightness,
                      maxValue: 255,
                      onChanged: (brightness) {
                        context.read<ControlBloc>().add(
                          BrightnessUpdated(brightness: brightness),
                        );
                      },
                    );
                  },
                ),
                GyverLampGaps.xlgsm,
                BlocBuilder<ControlBloc, ControlState>(
                  buildWhen: (p, c) => p.speed != c.speed,
                  builder: (context, state) {
                    return Ruler(
                      value: state.speed,
                      maxValue: 255,
                      onChanged: (speed) {
                        context.read<ControlBloc>().add(
                          SpeedUpdated(speed: speed),
                        );
                      },
                    );
                  },
                ),
                GyverLampGaps.xlgsm,
                BlocBuilder<ControlBloc, ControlState>(
                  buildWhen: (p, c) => p.scale != c.scale,
                  builder: (context, state) {
                    return Ruler(
                      value: state.scale,
                      maxValue: 255,
                      onChanged: (scale) {
                        context.read<ControlBloc>().add(
                          ScaleUpdated(scale: scale),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RulerName extends StatelessWidget {
  const _RulerName({
    required this.icon,
    required this.label,
  });

  final IconData icon;

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return SizedBox(
      height: 48,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: theme.onBackground,
          ),
          Text(
            label,
            style: GyverLampTextStyles.body2.copyWith(
              color: theme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
