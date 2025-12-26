// ignore_for_file: prefer_const_constructors, document_ignores

import 'package:connection_repository/connection_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/bloc/connection_bloc.dart';

void main() {
  group('ConnectionEvent', () {
    group('ConnectionRequested', () {
      test('supports equality', () {
        expect(
          ConnectionRequested(),
          equals(ConnectionRequested()),
        );
      });
    });

    group('ConnectionRequested', () {
      test('supports equality', () {
        expect(
          ConnectionRequested(),
          equals(ConnectionRequested()),
        );
      });
    });

    group('DisconnectionRequested', () {
      test('supports equality', () {
        expect(
          DisconnectionRequested(),
          equals(DisconnectionRequested()),
        );
      });
    });

    group('IpAddressUpdated', () {
      test('supports equality', () {
        final a = IpAddressUpdated(address: '1');
        final b = IpAddressUpdated(address: '1');
        final c = IpAddressUpdated(address: '2');
        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });
    });

    group('PortUpdated', () {
      test('supports equality', () {
        final a = PortUpdated(port: 1);
        final b = PortUpdated(port: 1);
        final c = PortUpdated(port: 2);
        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });
    });

    group('ConnectionStatusUpdated', () {
      test('supports equality', () {
        final a = ConnectionStatusUpdated(status: ConnectionStatus.connected);
        final b = ConnectionStatusUpdated(status: ConnectionStatus.connected);
        final c = ConnectionStatusUpdated(status: ConnectionStatus.connecting);
        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });
    });
  });
}
