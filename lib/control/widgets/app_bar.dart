import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp/settings/view/view.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class ControlAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ControlAppBar({super.key});

  @override
  Size get preferredSize => kCustomAppBarSize;

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      padding: const EdgeInsets.symmetric(
        horizontal: GyverLampSpacings.xlgsm,
      ),
      leading: const ConnectionStatusIndicator(),
      actions: [
        FlatIconButton.medium(
          icon: GyverLampIcons.settings,
          onPressed: () {
            Navigator.of(context).push(
              SettingsPage.route(),
            );
          },
        ),
        BlocBuilder<ControlBloc, ControlState>(
          buildWhen: (p, c) => p.isOn != c.isOn,
          builder: (context, state) {
            return Switcher(
              value: state.isOn,
              onChanged: (isOn) {
                context.read<ControlBloc>().add(
                  PowerToggled(isOn: isOn),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
