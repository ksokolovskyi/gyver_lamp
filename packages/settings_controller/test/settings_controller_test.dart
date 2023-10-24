// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings_controller/settings_controller.dart';

class _MockSettingsPersistence extends Mock implements SettingsPersistence {}

void main() {
  group('SettingsController', () {
    late SettingsPersistence persistence;
    late SettingsController controller;

    setUpAll(() {
      registerFallbackValue(Locale('en'));
    });

    setUp(() {
      persistence = _MockSettingsPersistence();

      when(persistence.getLocale).thenAnswer((_) async => Locale('uk', 'UA'));
      when(persistence.getDarkModeOn).thenAnswer((_) async => true);
      when(persistence.getInitialSetupCompleted).thenAnswer((_) async => true);
      when(persistence.getIpAddress).thenAnswer((_) async => '192.168.0.1');
      when(persistence.getPort).thenAnswer((_) async => 8888);

      when(
        () => persistence.saveLocale(
          locale: any(named: 'locale'),
        ),
      ).thenAnswer(
        (_) async {},
      );
      when(
        () => persistence.saveDarkModeOn(
          active: any(named: 'active'),
        ),
      ).thenAnswer(
        (_) async {},
      );
      when(
        () => persistence.saveInitialSetupCompleted(
          completed: any(named: 'completed'),
        ),
      ).thenAnswer(
        (_) async {},
      );
      when(
        () => persistence.saveIpAddress(
          ipAddress: any(named: 'ipAddress'),
        ),
      ).thenAnswer(
        (_) async {},
      );
      when(
        () => persistence.savePort(
          port: any(named: 'port'),
        ),
      ).thenAnswer(
        (_) async {},
      );

      when(persistence.clear).thenAnswer((_) async {});

      controller = SettingsController(persistence: persistence);
    });

    test('loadStateFromPersistence', () async {
      await controller.loadStateFromPersistence();

      expect(
        controller.locale.value,
        equals(Locale('uk', 'UA')),
      );
      verify(persistence.getLocale).called(1);

      expect(controller.darkModeOn.value, isTrue);
      verify(persistence.getDarkModeOn).called(1);

      expect(controller.initialSetupCompleted.value, isTrue);
      verify(persistence.getInitialSetupCompleted).called(1);

      expect(
        controller.ipAddress.value,
        equals('192.168.0.1'),
      );
      verify(persistence.getIpAddress).called(1);

      expect(
        controller.port.value,
        equals(8888),
      );
      verify(persistence.getPort).called(1);
    });

    test('can set locale', () async {
      controller.setLocale(locale: Locale('en', 'GB'));

      expect(
        controller.locale.value,
        equals(Locale('en', 'GB')),
      );

      verify(
        () => persistence.saveLocale(locale: Locale('en', 'GB')),
      ).called(1);
    });

    test('can set dark mode setting', () async {
      controller.setDarkModeOn(active: false);

      expect(controller.darkModeOn.value, isFalse);

      verify(
        () => persistence.saveDarkModeOn(active: false),
      ).called(1);
    });

    test('can set initial setup completed setting', () async {
      controller.setInitialSetupCompleted(completed: false);

      expect(controller.initialSetupCompleted.value, isFalse);

      verify(
        () => persistence.saveInitialSetupCompleted(completed: false),
      ).called(1);
    });

    test('can set IP address setting', () async {
      controller.setIpAddress(ipAddress: '192.168.0.2');

      expect(
        controller.ipAddress.value,
        equals('192.168.0.2'),
      );

      verify(
        () => persistence.saveIpAddress(ipAddress: '192.168.0.2'),
      ).called(1);
    });

    test('can set port setting', () async {
      controller.setPort(port: 3333);

      expect(
        controller.port.value,
        equals(3333),
      );

      verify(
        () => persistence.savePort(port: 3333),
      ).called(1);
    });

    group('clear', () {
      test('calls clear() on persistence', () async {
        await controller.clear();
        verify(persistence.clear).called(1);
      });

      test('resets all settings', () async {
        await controller.clear();

        expect(
          controller.locale.value,
          isNull,
        );
        expect(
          controller.darkModeOn.value,
          isNull,
        );
        expect(
          controller.initialSetupCompleted.value,
          isNull,
        );
        expect(
          controller.ipAddress.value,
          isNull,
        );
        expect(
          controller.port.value,
          isNull,
        );
      });
    });
  });
}
