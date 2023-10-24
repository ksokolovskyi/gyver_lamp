import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OtherSettings extends StatelessWidget {
  const OtherSettings({
    super.key,
    this.urlLauncher = launchUrlString,
  });

  final AsyncValueSetter<String> urlLauncher;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        SettingTileGroup(
          label: l10n.otherStuff,
          tiles: [
            SettingTile(
              icon: GyverLampIcons.github,
              label: l10n.lampProject,
              action: FlatIconButton.medium(
                icon: GyverLampIcons.arrow_outward,
                onPressed: () {
                  urlLauncher('https://github.com/AlexGyver/GyverLamp');
                },
              ),
            ),
            SettingTile(
              icon: GyverLampIcons.group,
              label: l10n.credits,
              action: const FlatIconButton.medium(
                icon: GyverLampIcons.arrow_outward,
                onPressed: null,
              ),
            ),
            SettingTile(
              icon: GyverLampIcons.policy,
              label: l10n.privacyPolicy,
              action: const FlatIconButton.medium(
                icon: GyverLampIcons.arrow_outward,
                onPressed: null,
              ),
            ),
            SettingTile(
              icon: GyverLampIcons.align_left,
              label: l10n.termsOfUse,
              action: const FlatIconButton.medium(
                icon: GyverLampIcons.arrow_outward,
                onPressed: null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
