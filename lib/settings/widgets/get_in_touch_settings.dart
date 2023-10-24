import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GetInTouchSettings extends StatelessWidget {
  const GetInTouchSettings({
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
          label: l10n.getInTouch,
          tiles: [
            SettingTile(
              icon: GyverLampIcons.mail,
              label: l10n.email,
              action: FlatIconButton.medium(
                icon: GyverLampIcons.arrow_outward,
                onPressed: () {
                  urlLauncher('mailto:sokolovskyi.konstantin@gmail.com');
                },
              ),
            ),
            SettingTile(
              icon: GyverLampIcons.x,
              label: l10n.twitter,
              action: FlatIconButton.medium(
                icon: GyverLampIcons.arrow_outward,
                onPressed: () {
                  urlLauncher('https://twitter.com/k_sokolovskyi');
                },
              ),
            ),
            SettingTile(
              icon: GyverLampIcons.dribbble,
              label: l10n.dribbble,
              action: FlatIconButton.medium(
                icon: GyverLampIcons.arrow_outward,
                onPressed: () {
                  urlLauncher('https://dribbble.com/ira_dehtiar');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
