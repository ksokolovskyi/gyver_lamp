// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';

void main() {
  group('PortInput', () {
    test('can be instantiated', () {
      expect(PortInput.pure(), isNotNull);
      expect(PortInput.dirty(), isNotNull);
    });

    test('supports equality', () {
      expect(PortInput.pure(), equals(PortInput.pure()));
      expect(PortInput.pure(1), equals(PortInput.pure(1)));
      expect(PortInput.pure(1), isNot(equals(PortInput.pure(2))));
      expect(PortInput.dirty(), equals(PortInput.dirty()));
      expect(PortInput.dirty(1), equals(PortInput.dirty(1)));
      expect(PortInput.dirty(1), isNot(equals(PortInput.dirty(2))));
    });

    test('validates port correctly', () {
      expect(PortInput.dirty(-2).isValid, isFalse);
      expect(PortInput.dirty(1).isValid, isTrue);
      expect(PortInput.dirty(3333).isValid, isTrue);
      expect(PortInput.dirty(65535).isValid, isTrue);
      expect(PortInput.dirty(65536).isValid, isFalse);
    });
  });
}
