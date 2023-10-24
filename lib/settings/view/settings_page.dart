import 'package:flutter/material.dart';
import 'package:gyver_lamp/settings/settings.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Route<void> route() {
    return GyverLampPageRoute<void>(
      builder: (_) => const SettingsPage(),
      settings: const RouteSettings(name: 'settings'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}
