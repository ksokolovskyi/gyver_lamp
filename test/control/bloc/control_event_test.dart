// ignore_for_file: prefer_const_constructors

import 'package:control_repository/control_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/control/control.dart';

void main() {
  group('ControlEvent', () {
    group('ControlRequested', () {
      test('supports equality', () {
        expect(
          ControlRequested(),
          equals(ControlRequested()),
        );
      });
    });

    group('ConnectionStateUpdated', () {
      test(
        'throws assertion error when connectionData is null and isConnected',
        () {
          expect(
            () => ConnectionStateUpdated(
              isConnected: true,
              connectionData: null,
            ),
            throwsA(
              isA<AssertionError>().having(
                (e) => e.message,
                'message',
                equals('connectionData must not be null when isConnected'),
              ),
            ),
          );
        },
      );

      test('supports equality', () {
        final a = ConnectionStateUpdated(
          isConnected: true,
          connectionData: ConnectionData(
            address: '192.168.1.5',
            port: 3333,
          ),
        );
        final b = ConnectionStateUpdated(
          isConnected: true,
          connectionData: ConnectionData(
            address: '192.168.1.5',
            port: 3333,
          ),
        );
        final c = ConnectionStateUpdated(
          isConnected: true,
          connectionData: ConnectionData(
            address: '192.168.1.5',
            port: 8888,
          ),
        );
        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });
    });

    group('LampMessageReceived', () {
      test('supports equality', () {
        final a = LampMessageReceived(
          message: GyverLampScaleChangedMessage(scale: 1),
        );
        final b = LampMessageReceived(
          message: GyverLampScaleChangedMessage(scale: 1),
        );
        final c = LampMessageReceived(
          message: GyverLampScaleChangedMessage(scale: 2),
        );
        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });
    });

    group('ModeUpdated', () {
      test('supports equality', () {
        final a = ModeUpdated(mode: GyverLampMode.cloud);
        final b = ModeUpdated(mode: GyverLampMode.cloud);
        final c = ModeUpdated(mode: GyverLampMode.color);
        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });
    });

    group('BrightnessUpdated', () {
      test('supports equality', () {
        final a = BrightnessUpdated(brightness: 1);
        final b = BrightnessUpdated(brightness: 1);
        final c = BrightnessUpdated(brightness: 2);
        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });
    });

    group('SpeedUpdated', () {
      test('supports equality', () {
        final a = SpeedUpdated(speed: 1);
        final b = SpeedUpdated(speed: 1);
        final c = SpeedUpdated(speed: 2);
        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });
    });

    group('ScaleUpdated', () {
      test('supports equality', () {
        final a = ScaleUpdated(scale: 1);
        final b = ScaleUpdated(scale: 1);
        final c = ScaleUpdated(scale: 2);
        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });
    });

    group('PowerToggled', () {
      test('supports equality', () {
        final a = PowerToggled(isOn: true);
        final b = PowerToggled(isOn: true);
        final c = PowerToggled(isOn: false);
        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });
    });
  });
}
