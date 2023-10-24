// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:gyver_lamp/connection/connection.dart';

void main() {
  group('IpAddressInput', () {
    test('can be instantiated', () {
      expect(IpAddressInput.pure(), isNotNull);
      expect(IpAddressInput.dirty(), isNotNull);
    });

    test('supports equality', () {
      expect(IpAddressInput.pure(), equals(IpAddressInput.pure()));
      expect(IpAddressInput.pure('1'), equals(IpAddressInput.pure('1')));
      expect(IpAddressInput.pure('1'), isNot(equals(IpAddressInput.pure('2'))));
      expect(IpAddressInput.dirty(), equals(IpAddressInput.dirty()));
      expect(IpAddressInput.dirty('1'), equals(IpAddressInput.dirty('1')));
      expect(
        IpAddressInput.dirty('1'),
        isNot(equals(IpAddressInput.dirty('2'))),
      );
    });

    test('validates address correctly', () {
      expect(IpAddressInput.dirty(' ').isValid, isFalse);
      expect(IpAddressInput.dirty('blah').isValid, isFalse);
      expect(IpAddressInput.dirty('1.1.1.1').isValid, isTrue);
      expect(IpAddressInput.dirty('192.169.1.5').isValid, isTrue);
      expect(IpAddressInput.dirty('0.169.1.5').isValid, isTrue);
      expect(IpAddressInput.dirty('192.0.1.5').isValid, isTrue);
      expect(IpAddressInput.dirty('192.168.0.5').isValid, isTrue);
      expect(IpAddressInput.dirty('192.168.1.0').isValid, isTrue);
      expect(IpAddressInput.dirty('192.169.1.256').isValid, isFalse);
    });
  });
}
