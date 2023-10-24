import 'package:connection_repository/connection_repository.dart';
import 'package:control_repository/control_repository.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/control/control.dart';
import 'package:gyver_lamp/initial_setup/initial_setup.dart';
import 'package:settings_controller/settings_controller.dart';

class AppData {
  const AppData({
    required this.connectionRepository,
    required this.controlRepository,
    required this.settingsController,
    required this.initialConnectionData,
    required this.initialSetupCompleted,
  });

  final ConnectionRepository connectionRepository;

  final ControlRepository controlRepository;

  final SettingsController settingsController;

  final ConnectionData? initialConnectionData;

  /// Whether to show [InitialSetupPage] or [ControlPage] after startup.
  final bool initialSetupCompleted;
}
