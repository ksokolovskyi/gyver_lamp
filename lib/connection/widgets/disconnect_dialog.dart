import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class DisconnectDialog extends StatelessWidget {
  const DisconnectDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final bloc = context.read<ConnectionBloc>();

    return ConfirmationDialog(
      title: l10n.disconnectDialogTitle,
      body: l10n.disconnectDialogBody,
      cancelLabel: l10n.cancel,
      confirmLabel: l10n.disconnect,
      onCancel: () {},
      onConfirm: () {
        bloc.add(
          const DisconnectionRequested(),
        );
      },
    );
  }
}
