import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class ConnectionStatusIndicator extends StatelessWidget {
  const ConnectionStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectionBloc, ConnectionState>(
      buildWhen: (p, c) => p.runtimeType != c.runtimeType,
      builder: (context, state) {
        final l10n = context.l10n;

        final status = switch (state) {
          ConnectionInitial() ||
          ConnectionFailure() => ConnectionStatus.notConnected,
          ConnectionInProgress() => ConnectionStatus.connecting,
          ConnectionSuccess() => ConnectionStatus.connected,
        };

        return ConnectionStatusBadge(
          status: status,
          label: (status) {
            return switch (status) {
              ConnectionStatus.notConnected => l10n.notConnected,
              ConnectionStatus.connecting => l10n.connecting,
              ConnectionStatus.connected => l10n.connected,
            };
          },
          onPressed: switch (status) {
            ConnectionStatus.notConnected => () {
              final bloc = context.read<ConnectionBloc>();

              GyverLampDialog.show(
                context,
                dialog: BlocProvider<ConnectionBloc>.value(
                  value: bloc,
                  child: const ConnectDialog(),
                ),
              );
            },
            ConnectionStatus.connecting => null,
            ConnectionStatus.connected => () {
              final bloc = context.read<ConnectionBloc>();

              GyverLampDialog.show(
                context,
                dialog: BlocProvider<ConnectionBloc>.value(
                  value: bloc,
                  child: const DisconnectDialog(),
                ),
              );
            },
          },
        );
      },
    );
  }
}
