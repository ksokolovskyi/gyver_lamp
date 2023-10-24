// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:settings_controller/settings_controller.dart';

void main() {
  group('InMemorySettingsPersistence', () {
    group('getLocale', () {
      test('returns null if locale was not saved previously', () async {
        final persistence = InMemorySettingsPersistence();

        final value = await persistence.getLocale();

        expect(value, isNull);
      });

      test('returns value if locale was saved previously', () async {
        final persistence = InMemorySettingsPersistence()
          ..locale = Locale('uk', 'UA');

        final value = await persistence.getLocale();

        expect(
          value,
          equals(Locale('uk', 'UA')),
        );
      });
    });

    group('getDarkModeOn', () {
      test('returns null if setting was not saved previously', () async {
        final persistence = InMemorySettingsPersistence();
        final value = await persistence.getDarkModeOn();
        expect(value, isNull);
      });

      test('returns value if setting was saved previously', () async {
        final persistence = InMemorySettingsPersistence()..darkModeOn = false;
        final value = await persistence.getDarkModeOn();
        expect(value, isFalse);
      });
    });

    group('getInitialSetupCompleted', () {
      test('returns null if setting was not saved previously', () async {
        final persistence = InMemorySettingsPersistence();
        final value = await persistence.getInitialSetupCompleted();
        expect(value, isNull);
      });

      test('returns value if setting was saved previously', () async {
        final persistence = InMemorySettingsPersistence()
          ..initialSetupCompleted = false;

        final value = await persistence.getInitialSetupCompleted();
        expect(value, isFalse);
      });
    });

    group('getIpAddress', () {
      test('returns null if setting was not saved previously', () async {
        final persistence = InMemorySettingsPersistence();
        final value = await persistence.getIpAddress();
        expect(value, isNull);
      });

      test('returns value if setting was saved previously', () async {
        final persistence = InMemorySettingsPersistence()
          ..ipAddress = '192.168.0.1';

        final value = await persistence.getIpAddress();

        expect(
          value,
          equals('192.168.0.1'),
        );
      });
    });

    group('getIpAddress', () {
      test('returns null if setting was not saved previously', () async {
        final persistence = InMemorySettingsPersistence();
        final value = await persistence.getIpAddress();
        expect(value, isNull);
      });

      test('returns value if setting was saved previously', () async {
        final persistence = InMemorySettingsPersistence()
          ..ipAddress = '192.168.0.1';

        final value = await persistence.getIpAddress();

        expect(
          value,
          equals('192.168.0.1'),
        );
      });
    });

    group('getPort', () {
      test('returns null if setting was not saved previously', () async {
        final persistence = InMemorySettingsPersistence();
        final value = await persistence.getPort();
        expect(value, isNull);
      });

      test('returns value if setting was saved previously', () async {
        final persistence = InMemorySettingsPersistence()..port = 8888;

        final value = await persistence.getPort();

        expect(
          value,
          equals(8888),
        );
      });
    });

    test('saveLocale', () async {
      final persistence = InMemorySettingsPersistence();

      await persistence.saveLocale(locale: Locale('uk', 'UA'));

      expect(
        await persistence.getLocale(),
        equals(Locale('uk', 'UA')),
      );
    });

    test('saveDarkModeOn', () async {
      final persistence = InMemorySettingsPersistence();

      await persistence.saveDarkModeOn(active: true);

      expect(
        await persistence.getDarkModeOn(),
        isTrue,
      );
    });

    test('saveInitialSetupCompleted', () async {
      final persistence = InMemorySettingsPersistence();

      await persistence.saveInitialSetupCompleted(completed: true);

      expect(
        await persistence.getInitialSetupCompleted(),
        isTrue,
      );
    });

    test('saveIpAddress', () async {
      final persistence = InMemorySettingsPersistence();

      await persistence.saveIpAddress(ipAddress: '192.168.0.2');

      expect(
        await persistence.getIpAddress(),
        equals('192.168.0.2'),
      );
    });

    test('savePort', () async {
      final persistence = InMemorySettingsPersistence();

      await persistence.savePort(port: 3333);

      expect(
        await persistence.getPort(),
        equals(3333),
      );
    });

    test('clear', () async {
      final persistence = InMemorySettingsPersistence()
        ..locale = Locale('uk', 'UA')
        ..darkModeOn = true
        ..initialSetupCompleted = true
        ..ipAddress = '192.168.0.1'
        ..port = 8888;

      await persistence.clear();

      expect(
        await persistence.getLocale(),
        isNull,
      );

      expect(
        await persistence.getDarkModeOn(),
        isNull,
      );

      expect(
        await persistence.getInitialSetupCompleted(),
        isNull,
      );

      expect(
        await persistence.getIpAddress(),
        isNull,
      );

      expect(
        await persistence.getPort(),
        isNull,
      );
    });
  });
}
