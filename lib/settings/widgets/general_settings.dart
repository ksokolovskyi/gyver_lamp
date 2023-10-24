import 'package:flutter/material.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp/settings/settings.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SettingTileGroup(
      label: l10n.general,
      tiles: [
        SettingTile(
          icon: GyverLampIcons.language,
          label: l10n.language,
          action: const LanguageSelector(),
        ),
        SettingTile(
          icon: GyverLampIcons.moon,
          label: l10n.darkMode,
          action: const DarkModeSwitcher(),
        ),
      ],
    );
  }
}
