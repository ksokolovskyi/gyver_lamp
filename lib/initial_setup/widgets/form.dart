import 'package:flutter/material.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class InitialSetupForm extends StatelessWidget {
  const InitialSetupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context).extension<GyverLampAppTheme>()!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(GyverLampSpacings.xlgsm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.initialSetupPageTitle,
              style: GyverLampTextStyles.headline5Bold.copyWith(
                color: theme.onBackground,
              ),
            ),
            GyverLampGaps.sm,
            Text(
              l10n.initialSetupFormDescription,
              style: GyverLampTextStyles.body2.copyWith(
                color: theme.textSecondary,
              ),
            ),
            GyverLampGaps.xlg,
            const IpAddressField(),
            GyverLampGaps.lg,
            const PortField(),
          ],
        ),
      ),
    );
  }
}
