import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';

void main() {
  group('ConnectionState', () {
    final address1 = IpAddressInput.dirty('192.168.1.5');
    final address2 = IpAddressInput.dirty('192.168.1.6');
    final port1 = PortInput.dirty(3333);
    final port2 = PortInput.dirty(8888);

    test('isConnected is true only for ConnectionSuccess', () {
      expect(
        ConnectionInitial(address: address1, port: port1).isConnected,
        isFalse,
      );
      expect(
        ConnectionInProgress(address: address1, port: port1).isConnected,
        isFalse,
      );
      expect(
        ConnectionSuccess(address: address1, port: port1).isConnected,
        isTrue,
      );
      expect(
        ConnectionFailure(address: address1, port: port1).isConnected,
        isFalse,
      );
    });

    test('isConnecting is true only for ConnectionInProgress', () {
      expect(
        ConnectionInitial(address: address1, port: port1).isConnecting,
        isFalse,
      );
      expect(
        ConnectionInProgress(address: address1, port: port1).isConnecting,
        isTrue,
      );
      expect(
        ConnectionSuccess(address: address1, port: port1).isConnecting,
        isFalse,
      );
      expect(
        ConnectionFailure(address: address1, port: port1).isConnecting,
        isFalse,
      );
    });

    test(
      'isLampDataValid returns true only when address and port are valid',
      () {
        expect(
          ConnectionInitial(address: address1, port: port1).isLampDataValid,
          isTrue,
        );
        expect(
          ConnectionInitial(
            address: IpAddressInput.pure(),
            port: port1,
          ).isLampDataValid,
          isFalse,
        );
        expect(
          ConnectionInitial(
            address: address1,
            port: PortInput.pure(),
          ).isLampDataValid,
          isFalse,
        );
        expect(
          ConnectionInitial(
            address: IpAddressInput.pure(),
            port: PortInput.pure(),
          ).isLampDataValid,
          isFalse,
        );
      },
    );

    test(
      'connectionData returns data only when address and port are valid',
      () {
        expect(
          ConnectionInitial(address: address1, port: port1).connectionData,
          equals(
            ConnectionData(address: address1.value, port: port1.value),
          ),
        );
        expect(
          ConnectionInitial(
            address: IpAddressInput.pure(),
            port: port1,
          ).connectionData,
          isNull,
        );
        expect(
          ConnectionInitial(
            address: address1,
            port: PortInput.pure(),
          ).connectionData,
          isNull,
        );
        expect(
          ConnectionInitial(
            address: IpAddressInput.pure(),
            port: PortInput.pure(),
          ).connectionData,
          isNull,
        );
      },
    );

    group('ConnectionInitial', () {
      test('can be instantiated', () {
        expect(
          ConnectionInitial(address: address1, port: port1),
          isNotNull,
        );
      });

      test('supports equality', () {
        expect(
          ConnectionInitial(address: address1, port: port1),
          equals(ConnectionInitial(address: address1, port: port1)),
        );

        expect(
          ConnectionInitial(address: address1, port: port1),
          isNot(equals(ConnectionInitial(address: address1, port: port2))),
        );

        expect(
          ConnectionInitial(address: address1, port: port1),
          isNot(equals(ConnectionInitial(address: address2, port: port1))),
        );
      });

      test('copyWith returns a new instance with copied values', () {
        expect(
          ConnectionInitial(address: address1, port: port1).copyWith(
            address: address2,
          ),
          equals(ConnectionInitial(address: address2, port: port1)),
        );

        expect(
          ConnectionInitial(address: address1, port: port1).copyWith(
            port: port2,
          ),
          equals(ConnectionInitial(address: address1, port: port2)),
        );

        expect(
          ConnectionInitial(address: address1, port: port1).copyWith(
            address: address2,
            port: port2,
          ),
          equals(ConnectionInitial(address: address2, port: port2)),
        );
      });
    });

    group('ConnectionInProgress', () {
      test('can be instantiated', () {
        expect(
          ConnectionInProgress(address: address1, port: port1),
          isNotNull,
        );
      });

      test('supports equality', () {
        expect(
          ConnectionInProgress(address: address1, port: port1),
          equals(ConnectionInProgress(address: address1, port: port1)),
        );

        expect(
          ConnectionInProgress(address: address1, port: port1),
          isNot(equals(ConnectionInProgress(address: address1, port: port2))),
        );

        expect(
          ConnectionInProgress(address: address1, port: port1),
          isNot(equals(ConnectionInProgress(address: address2, port: port1))),
        );
      });

      test('copyWith returns a new instance with copied values', () {
        expect(
          ConnectionInProgress(address: address1, port: port1).copyWith(
            address: address2,
          ),
          equals(ConnectionInProgress(address: address2, port: port1)),
        );

        expect(
          ConnectionInProgress(address: address1, port: port1).copyWith(
            port: port2,
          ),
          equals(ConnectionInProgress(address: address1, port: port2)),
        );

        expect(
          ConnectionInProgress(address: address1, port: port1).copyWith(
            address: address2,
            port: port2,
          ),
          equals(ConnectionInProgress(address: address2, port: port2)),
        );
      });
    });

    group('ConnectionSuccess', () {
      test('can be instantiated', () {
        expect(
          ConnectionSuccess(address: address1, port: port1),
          isNotNull,
        );
      });

      test('supports equality', () {
        expect(
          ConnectionSuccess(address: address1, port: port1),
          equals(ConnectionSuccess(address: address1, port: port1)),
        );

        expect(
          ConnectionSuccess(address: address1, port: port1),
          isNot(equals(ConnectionSuccess(address: address1, port: port2))),
        );

        expect(
          ConnectionSuccess(address: address1, port: port1),
          isNot(equals(ConnectionSuccess(address: address2, port: port1))),
        );
      });

      test('copyWith returns a new instance with copied values', () {
        expect(
          ConnectionSuccess(address: address1, port: port1).copyWith(
            address: address2,
          ),
          equals(ConnectionSuccess(address: address2, port: port1)),
        );

        expect(
          ConnectionSuccess(address: address1, port: port1).copyWith(
            port: port2,
          ),
          equals(ConnectionSuccess(address: address1, port: port2)),
        );

        expect(
          ConnectionSuccess(address: address1, port: port1).copyWith(
            address: address2,
            port: port2,
          ),
          equals(ConnectionSuccess(address: address2, port: port2)),
        );
      });
    });

    group('ConnectionFailure', () {
      test('can be instantiated', () {
        expect(
          ConnectionFailure(address: address1, port: port1),
          isNotNull,
        );
      });

      test('supports equality', () {
        expect(
          ConnectionFailure(address: address1, port: port1),
          equals(ConnectionFailure(address: address1, port: port1)),
        );

        expect(
          ConnectionFailure(address: address1, port: port1),
          isNot(equals(ConnectionFailure(address: address1, port: port2))),
        );

        expect(
          ConnectionFailure(address: address1, port: port1),
          isNot(equals(ConnectionFailure(address: address2, port: port1))),
        );
      });

      test('copyWith returns a new instance with copied values', () {
        expect(
          ConnectionFailure(address: address1, port: port1).copyWith(
            address: address2,
          ),
          equals(ConnectionFailure(address: address2, port: port1)),
        );

        expect(
          ConnectionFailure(address: address1, port: port1).copyWith(
            port: port2,
          ),
          equals(ConnectionFailure(address: address1, port: port2)),
        );

        expect(
          ConnectionFailure(address: address1, port: port1).copyWith(
            address: address2,
            port: port2,
          ),
          equals(ConnectionFailure(address: address2, port: port2)),
        );
      });
    });
  });
}
