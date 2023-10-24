// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';

void main() {
  group('ConnectionData', () {
    const address1 = '192.168.1.5';
    const address2 = '192.168.1.6';
    const port1 = 3333;
    const port2 = 8888;

    test('can be instantiated', () {
      expect(
        ConnectionData(address: address1, port: port1),
        isNotNull,
      );
    });

    test('supports equality', () {
      expect(
        ConnectionData(address: address1, port: port1),
        equals(ConnectionData(address: address1, port: port1)),
      );

      expect(
        ConnectionData(address: address1, port: port1),
        isNot(equals(ConnectionData(address: address1, port: port2))),
      );

      expect(
        ConnectionData(address: address1, port: port1),
        isNot(equals(ConnectionData(address: address2, port: port1))),
      );
    });
  });
}
