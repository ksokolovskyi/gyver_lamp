// ignore_for_file: prefer_const_constructors, document_ignores

import 'package:control_repository/control_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';
import 'package:gyver_lamp/control/control.dart';

void main() {
  group('ControlState', () {
    final connectionData1 = ConnectionData(
      address: '192.168.1.5',
      port: 3333,
    );
    final connectionData2 = ConnectionData(
      address: '192.168.1.6',
      port: 8888,
    );

    test('can be instantiated', () {
      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        isNotNull,
      );
    });

    test(
      'throws assertion error when connectionData is null and isConnected',
      () {
        expect(
          () => ControlState(
            isConnected: true,
            connectionData: null,
            mode: GyverLampMode.color,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
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
      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        equals(
          ControlState(
            isConnected: false,
            connectionData: connectionData1,
            mode: GyverLampMode.color,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ),
      );

      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        isNot(
          equals(
            ControlState(
              isConnected: true,
              connectionData: connectionData1,
              mode: GyverLampMode.color,
              brightness: 1,
              speed: 2,
              scale: 3,
              isOn: false,
            ),
          ),
        ),
      );

      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        isNot(
          equals(
            ControlState(
              isConnected: false,
              connectionData: connectionData2,
              mode: GyverLampMode.color,
              brightness: 1,
              speed: 2,
              scale: 3,
              isOn: false,
            ),
          ),
        ),
      );

      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        isNot(
          equals(
            ControlState(
              isConnected: false,
              connectionData: connectionData1,
              mode: GyverLampMode.cloud,
              brightness: 1,
              speed: 2,
              scale: 3,
              isOn: false,
            ),
          ),
        ),
      );

      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        isNot(
          equals(
            ControlState(
              isConnected: false,
              connectionData: connectionData1,
              mode: GyverLampMode.color,
              brightness: 4,
              speed: 2,
              scale: 3,
              isOn: false,
            ),
          ),
        ),
      );

      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        isNot(
          equals(
            ControlState(
              isConnected: false,
              connectionData: connectionData1,
              mode: GyverLampMode.color,
              brightness: 1,
              speed: 4,
              scale: 3,
              isOn: false,
            ),
          ),
        ),
      );

      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        isNot(
          equals(
            ControlState(
              isConnected: false,
              connectionData: connectionData1,
              mode: GyverLampMode.color,
              brightness: 1,
              speed: 2,
              scale: 4,
              isOn: false,
            ),
          ),
        ),
      );

      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ),
        isNot(
          equals(
            ControlState(
              isConnected: false,
              connectionData: connectionData1,
              mode: GyverLampMode.color,
              brightness: 1,
              speed: 2,
              scale: 3,
              isOn: true,
            ),
          ),
        ),
      );
    });

    test('copyWith returns a new instance with copied values', () {
      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ).copyWith(isConnected: true),
        equals(
          ControlState(
            isConnected: true,
            connectionData: connectionData1,
            mode: GyverLampMode.color,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ),
      );

      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ).copyWith(connectionData: connectionData2),
        equals(
          ControlState(
            isConnected: false,
            connectionData: connectionData2,
            mode: GyverLampMode.color,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ),
      );

      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ).copyWith(mode: GyverLampMode.cloud),
        equals(
          ControlState(
            isConnected: false,
            connectionData: connectionData1,
            mode: GyverLampMode.cloud,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ),
      );

      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ).copyWith(brightness: 4),
        equals(
          ControlState(
            isConnected: false,
            connectionData: connectionData1,
            mode: GyverLampMode.color,
            brightness: 4,
            speed: 2,
            scale: 3,
            isOn: false,
          ),
        ),
      );

      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ).copyWith(speed: 4),
        equals(
          ControlState(
            isConnected: false,
            connectionData: connectionData1,
            mode: GyverLampMode.color,
            brightness: 1,
            speed: 4,
            scale: 3,
            isOn: false,
          ),
        ),
      );

      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ).copyWith(scale: 4),
        equals(
          ControlState(
            isConnected: false,
            connectionData: connectionData1,
            mode: GyverLampMode.color,
            brightness: 1,
            speed: 2,
            scale: 4,
            isOn: false,
          ),
        ),
      );

      expect(
        ControlState(
          isConnected: false,
          connectionData: connectionData1,
          mode: GyverLampMode.color,
          brightness: 1,
          speed: 2,
          scale: 3,
          isOn: false,
        ).copyWith(isOn: true),
        equals(
          ControlState(
            isConnected: false,
            connectionData: connectionData1,
            mode: GyverLampMode.color,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: true,
          ),
        ),
      );
    });

    test(
      'copyWithConnectionState returns a new instance with copied values',
      () {
        expect(
          ControlState(
            isConnected: false,
            connectionData: connectionData1,
            mode: GyverLampMode.color,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ).copyWithConnectionState(
            isConnected: true,
            connectionData: connectionData2,
          ),
          equals(
            ControlState(
              isConnected: true,
              connectionData: connectionData2,
              mode: GyverLampMode.color,
              brightness: 1,
              speed: 2,
              scale: 3,
              isOn: false,
            ),
          ),
        );

        expect(
          ControlState(
            isConnected: false,
            connectionData: connectionData1,
            mode: GyverLampMode.color,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ).copyWithConnectionState(
            isConnected: false,
            connectionData: connectionData2,
          ),
          equals(
            ControlState(
              isConnected: false,
              connectionData: connectionData2,
              mode: GyverLampMode.color,
              brightness: 1,
              speed: 2,
              scale: 3,
              isOn: false,
            ),
          ),
        );

        expect(
          ControlState(
            isConnected: false,
            connectionData: connectionData1,
            mode: GyverLampMode.color,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ).copyWithConnectionState(
            isConnected: false,
            connectionData: null,
          ),
          equals(
            ControlState(
              isConnected: false,
              connectionData: null,
              mode: GyverLampMode.color,
              brightness: 1,
              speed: 2,
              scale: 3,
              isOn: false,
            ),
          ),
        );

        expect(
          ControlState(
            isConnected: false,
            connectionData: connectionData1,
            mode: GyverLampMode.color,
            brightness: 1,
            speed: 2,
            scale: 3,
            isOn: false,
          ).copyWithConnectionState(
            isConnected: false,
            connectionData: connectionData1,
          ),
          equals(
            ControlState(
              isConnected: false,
              connectionData: connectionData1,
              mode: GyverLampMode.color,
              brightness: 1,
              speed: 2,
              scale: 3,
              isOn: false,
            ),
          ),
        );
      },
    );
  });
}
