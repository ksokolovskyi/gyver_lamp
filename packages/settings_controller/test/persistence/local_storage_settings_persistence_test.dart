// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:settings_controller/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LocalStorageSettingsPersistence', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    group('getLocale', () {
      test('returns null if locale was not saved previously', () async {
        final persistence = LocalStorageSettingsPersistence();

        expect(
          await persistence.getLocale(),
          isNull,
        );
      });

      test('returns value if locale was saved previously', () async {
        SharedPreferences.setMockInitialValues({
          'locale': 'uk_UA',
        });

        final persistence = LocalStorageSettingsPersistence();

        expect(
          await persistence.getLocale(),
          equals(Locale('uk', 'UA')),
        );
      });

      test('returns null if locale is not valid', () async {
        SharedPreferences.setMockInitialValues({
          'locale': '123',
        });

        final persistence = LocalStorageSettingsPersistence();

        expect(
          await persistence.getLocale(),
          isNull,
        );
      });
    });

    group('getDarkModeOn', () {
      test('returns null if setting was not saved previously', () async {
        final persistence = LocalStorageSettingsPersistence();

        expect(
          await persistence.getDarkModeOn(),
          isNull,
        );
      });

      test('returns value if setting was saved previously', () async {
        SharedPreferences.setMockInitialValues({
          'darkModeOn': false,
        });

        final persistence = LocalStorageSettingsPersistence();

        expect(
          await persistence.getDarkModeOn(),
          isFalse,
        );
      });
    });

    group('getInitialSetupCompleted', () {
      test('returns null if setting was not saved previously', () async {
        final persistence = LocalStorageSettingsPersistence();

        expect(
          await persistence.getInitialSetupCompleted(),
          isNull,
        );
      });

      test('returns value if setting was saved previously', () async {
        SharedPreferences.setMockInitialValues({
          'initialSetupCompleted': false,
        });

        final persistence = LocalStorageSettingsPersistence();

        expect(
          await persistence.getInitialSetupCompleted(),
          isFalse,
        );
      });
    });

    group('getIpAddress', () {
      test('returns null if setting was not saved previously', () async {
        final persistence = LocalStorageSettingsPersistence();

        expect(
          await persistence.getIpAddress(),
          isNull,
        );
      });

      test('returns value if setting was saved previously', () async {
        SharedPreferences.setMockInitialValues({
          'ipAddress': '192.168.0.1',
        });

        final persistence = LocalStorageSettingsPersistence();

        expect(
          await persistence.getIpAddress(),
          equals('192.168.0.1'),
        );
      });
    });

    group('getPort', () {
      test('returns null if setting was not saved previously', () async {
        final persistence = LocalStorageSettingsPersistence();

        expect(
          await persistence.getPort(),
          isNull,
        );
      });

      test('returns value if setting was saved previously', () async {
        SharedPreferences.setMockInitialValues({
          'port': 8888,
        });

        final persistence = LocalStorageSettingsPersistence();

        expect(
          await persistence.getPort(),
          equals(8888),
        );
      });
    });

    test('saveLocale', () async {
      final persistence = LocalStorageSettingsPersistence();

      await persistence.saveLocale(
        locale: Locale('uk', 'UA'),
      );

      expect(
        await persistence.getLocale(),
        equals(Locale('uk', 'UA')),
      );
    });

    test('saveDarkModeOn', () async {
      final persistence = LocalStorageSettingsPersistence();

      await persistence.saveDarkModeOn(active: true);

      expect(
        await persistence.getDarkModeOn(),
        isTrue,
      );
    });

    test('saveInitialSetupCompleted', () async {
      final persistence = LocalStorageSettingsPersistence();

      await persistence.saveInitialSetupCompleted(completed: true);

      expect(
        await persistence.getInitialSetupCompleted(),
        isTrue,
      );
    });

    group('saveIpAddress', () {
      test('saves IP address if value is not null', () async {
        final persistence = LocalStorageSettingsPersistence();

        await persistence.saveIpAddress(ipAddress: '192.168.0.2');

        expect(
          await persistence.getIpAddress(),
          equals('192.168.0.2'),
        );
      });

      test('removes IP address if value is null', () async {
        SharedPreferences.setMockInitialValues({
          'ipAddress': '192.168.0.1',
        });

        final persistence = LocalStorageSettingsPersistence();

        expect(
          await persistence.getIpAddress(),
          equals('192.168.0.1'),
        );

        await persistence.saveIpAddress(ipAddress: null);

        expect(
          await persistence.getIpAddress(),
          isNull,
        );
      });
    });

    group('savePort', () {
      test('saves port if value is not null', () async {
        final persistence = LocalStorageSettingsPersistence();

        await persistence.savePort(port: 3333);

        expect(
          await persistence.getPort(),
          equals(3333),
        );
      });

      test('removes port if value is null', () async {
        SharedPreferences.setMockInitialValues({
          'port': 8888,
        });

        final persistence = LocalStorageSettingsPersistence();

        expect(
          await persistence.getPort(),
          equals(8888),
        );

        await persistence.savePort(port: null);

        expect(
          await persistence.getPort(),
          isNull,
        );
      });
    });

    test('clear', () async {
      SharedPreferences.setMockInitialValues({
        'locale': 'uk_UA',
        'darkModeOn': true,
        'initialSetupCompleted': true,
        'ipAddress': '192.168.0.1',
        'port': 8888,
      });

      final persistence = LocalStorageSettingsPersistence();

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
