import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:settings_controller/settings_controller.dart';

/// {@template settings_controller}
/// An class that holds settings like [locale] or [darkModeOn],
/// and saves them to an injected persistence store.
/// {@endtemplate}
class SettingsController {
  /// {@macro settings_controller}
  SettingsController({
    required SettingsPersistence persistence,
  }) : _persistence = persistence;

  final SettingsPersistence _persistence;

  final ValueNotifier<Locale?> _locale = ValueNotifier(null);

  final ValueNotifier<bool?> _darkModeOn = ValueNotifier(null);

  final ValueNotifier<bool?> _initialSetupCompleted = ValueNotifier(null);

  final ValueNotifier<String?> _ipAddress = ValueNotifier(null);

  final ValueNotifier<int?> _port = ValueNotifier(null);

  /// Returns latest saved [Locale] value.
  ValueNotifier<Locale?> get locale => _locale;

  /// Returns latest saved dark mode setting value.
  ValueNotifier<bool?> get darkModeOn => _darkModeOn;

  /// Returns latest saved initial setup completion setting value.
  ValueNotifier<bool?> get initialSetupCompleted => _initialSetupCompleted;

  /// Returns latest saved IP address setting value.
  ValueNotifier<String?> get ipAddress => _ipAddress;

  /// Returns latest saved port setting value.
  ValueNotifier<int?> get port => _port;

  /// Asynchronously loads values from the injected persistence store.
  Future<void> loadStateFromPersistence() async {
    await Future.wait([
      _persistence.getLocale().then((value) => _locale.value = value),
      _persistence.getDarkModeOn().then((value) => _darkModeOn.value = value),
      _persistence
          .getInitialSetupCompleted()
          .then((value) => _initialSetupCompleted.value = value),
      _persistence.getIpAddress().then((value) => _ipAddress.value = value),
      _persistence.getPort().then((value) => _port.value = value),
    ]);
  }

  /// Sets new locale value and saves it in the persistence store.
  void setLocale({required Locale locale}) {
    _locale.value = locale;
    _persistence.saveLocale(locale: locale);
  }

  /// Sets new dark mode setting value and saves it in the persistence store.
  void setDarkModeOn({required bool active}) {
    _darkModeOn.value = active;
    _persistence.saveDarkModeOn(active: active);
  }

  /// Sets new initial setup completion setting value and saves it in the
  /// persistence store.
  void setInitialSetupCompleted({required bool completed}) {
    _initialSetupCompleted.value = completed;
    _persistence.saveInitialSetupCompleted(completed: completed);
  }

  /// Sets new IP address setting value and saves it in the persistence store.
  void setIpAddress({required String? ipAddress}) {
    _ipAddress.value = ipAddress;
    _persistence.saveIpAddress(ipAddress: ipAddress);
  }

  /// Sets new port setting value and saves it in the persistence store.
  void setPort({required int? port}) {
    _port.value = port;
    _persistence.savePort(port: port);
  }

  /// Resets all settings and clears persistence store.
  Future<void> clear() async {
    _locale.value = null;
    _darkModeOn.value = null;
    _initialSetupCompleted.value = null;
    _ipAddress.value = null;
    _port.value = null;

    await _persistence.clear();
  }
}
