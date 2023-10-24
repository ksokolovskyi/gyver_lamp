import 'dart:async';
import 'dart:developer';

import 'package:connection_repository/connection_repository.dart';
import 'package:control_repository/control_repository.dart';
import 'package:gyver_lamp/app/app.dart';
import 'package:gyver_lamp/bootstrap.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp_client/gyver_lamp_client.dart';
import 'package:settings_controller/settings_controller.dart';

Future<void> main() async {
  unawaited(
    bootstrap(() {
      return AppLoader(
        dataLoader: () async {
          final client = GyverLampClient(
            onSend: (address, port, request) {
              log('client.onSend($request, $address:$port)');
            },
            onResponse: (address, port, response) {
              log('client.onResponse($response, $address:$port)');
            },
            onError: (address, port, error) {
              log('client.onError($error, $address:$port)');
            },
          );

          final settingsController = SettingsController(
            persistence: LocalStorageSettingsPersistence(),
          );

          await settingsController.loadStateFromPersistence();

          final initialSetupCompleted =
              settingsController.initialSetupCompleted.value ?? false;
          final address = settingsController.ipAddress.value;
          final port = settingsController.port.value;

          final initialConnectionData =
              !initialSetupCompleted || address == null || port == null
                  ? null
                  : ConnectionData(address: address, port: port);

          return AppData(
            connectionRepository: ConnectionRepository(client: client),
            controlRepository: ControlRepository(client: client),
            settingsController: settingsController,
            initialConnectionData: initialConnectionData,
            initialSetupCompleted: initialSetupCompleted,
          );
        },
      );
    }),
  );
}
