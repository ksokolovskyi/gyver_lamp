import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp/initial_setup/initial_setup.dart';
import 'package:gyver_lamp/l10n/l10n.dart';
import 'package:gyver_lamp_ui/gyver_lamp_ui.dart';
import 'package:settings_controller/settings_controller.dart';

class InitialSetupView extends StatelessWidget {
  const InitialSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<ConnectionBloc, ConnectionState>(
      listenWhen: (p, c) => c is ConnectionSuccess || c is ConnectionFailure,
      listener: (context, state) {
        switch (state) {
          case ConnectionSuccess():
            _goToControlPage(context);

          case ConnectionFailure():
            AlertMessenger.of(context).showError(
              message: l10n.connectionFailed,
            );

          default:
          // Ignore.
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            BlocBuilder<ConnectionBloc, ConnectionState>(
              buildWhen: (p, c) => p.isConnecting || c.isConnecting,
              builder: (context, state) {
                return FlatTextButton.medium(
                  onPressed: state.isConnecting
                      ? null
                      : () => _goToControlPage(context),
                  child: Text(context.l10n.skip),
                );
              },
            ),
          ],
        ),
        body: const InitialSetupForm(),
        bottomNavigationBar: const InitialSetupBottomBar(),
      ),
    );
  }

  void _goToControlPage(BuildContext context) {
    // Clear all the alerts.
    AlertMessenger.of(context).clear();

    // Mark initial setup as completed, so on the next launch user will start
    // from the control page.
    context.read<SettingsController>().setInitialSetupCompleted(
      completed: true,
    );

    // Resetting connection data if it is not valid.
    context.read<ConnectionBloc>().add(
      const ConnectionDataCheckRequested(),
    );

    Navigator.of(context).pushReplacement<void, void>(
      ControlPage.route(),
    );
  }
}
