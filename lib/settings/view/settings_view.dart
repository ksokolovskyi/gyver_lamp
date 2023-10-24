import 'package:flutter/material.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp/settings/settings.dart';
import 'package:gyver_lamp_icons/gyver_lamp_icons.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        padding: const EdgeInsets.symmetric(
          horizontal: GyverLampSpacings.xlgsm,
        ),
        leading: FlatIconButton.medium(
          icon: GyverLampIcons.arrow_left,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: context.l10n.settings,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: GyverLampSpacings.xlgsm,
          ),
          child: SafeArea(
            child: Column(
              children: [
                GeneralSettings(),
                GyverLampGaps.lg,
                GetInTouchSettings(),
                GyverLampGaps.lg,
                OtherSettings(),
                GyverLampGaps.lg,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
