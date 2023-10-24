import 'package:connection_repository/connection_repository.dart';
import 'package:control_repository/control_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/app/app.dart';
import 'package:gyver_lamp/connection/models/connection_data.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:settings_controller/settings_controller.dart';

class _MockConnectionRepository extends Mock implements ConnectionRepository {}

class _MockControlRepository extends Mock implements ControlRepository {}

class _MockSettingsController extends Mock implements SettingsController {}

void main() {
  group('AppData', () {
    test('can be instantiated', () {
      expect(
        AppData(
          connectionRepository: _MockConnectionRepository(),
          controlRepository: _MockControlRepository(),
          settingsController: _MockSettingsController(),
          initialConnectionData: const ConnectionData(
            address: '192.168.1.5',
            port: 8888,
          ),
          initialSetupCompleted: true,
        ),
        isNotNull,
      );
    });
  });
}
