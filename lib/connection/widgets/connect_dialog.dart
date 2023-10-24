import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class ConnectDialog extends StatelessWidget {
  const ConnectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<ConnectionBloc, ConnectionState>(
      listenWhen: (p, c) => c is ConnectionSuccess || c is ConnectionFailure,
      listener: (context, state) {
        switch (state) {
          case ConnectionSuccess():
            _closeDialog(context);

          case ConnectionFailure():
            AlertMessenger.of(context).showError(
              message: l10n.connectionFailed,
            );

          default:
          // Ignore.
        }
      },
      child: GyverLampDialog(
        title: l10n.connectDialogTitle,
        body: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IpAddressField(),
            GyverLampGaps.lg,
            PortField(),
          ],
        ),
        actions: [
          RoundedOutlinedButton.medium(
            onPressed: () => _closeDialog(context),
            child: Text(l10n.cancel),
          ),
          const ConnectButton.medium(),
        ],
      ),
    );
  }

  void _closeDialog(BuildContext context) {
    // Clear all the alerts.
    AlertMessenger.of(context).clear();

    // Resetting connection data if it is not valid.
    context.read<ConnectionBloc>().add(
          const ConnectionDataCheckRequested(),
        );

    Navigator.of(context).maybePop();
  }
}
