import 'package:control_repository/control_repository.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({super.key});

  static Route<void> route() {
    return GyverLampPageRoute<void>(
      builder: (_) => const ControlPage(),
      settings: const RouteSettings(name: 'control'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ControlBloc>(
      lazy: false,
      create: (context) {
        final connectionState = context.read<ConnectionBloc>().state;

        return ControlBloc(
          controlRepository: context.read<ControlRepository>(),
          isConnected: connectionState.isConnected,
          connectionData: connectionState.connectionData,
        )..add(
          const ControlRequested(),
        );
      },
      child: BlocListener<ConnectionBloc, ConnectionState>(
        listenWhen: (p, c) => p.isConnected != c.isConnected,
        listener: (context, state) {
          context.read<ControlBloc>().add(
            ConnectionStateUpdated(
              isConnected: state.isConnected,
              connectionData: state.connectionData,
            ),
          );
        },
        child: const ControlView(),
      ),
    );
  }
}
