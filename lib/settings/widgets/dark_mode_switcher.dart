import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:settings_controller/settings_controller.dart';

class DarkModeSwitcher extends StatelessWidget {
  const DarkModeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<SettingsController>();

    return ValueListenableBuilder(
      valueListenable: controller.darkModeOn,
      builder: (context, active, _) {
        return Switcher(
          value: active ?? false,
          onChanged: (active) {
            controller.setDarkModeOn(active: active);
          },
        );
      },
    );
  }
}
