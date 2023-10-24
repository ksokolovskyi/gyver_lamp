import 'dart:ui';

import 'package:settings_controller/settings_controller.dart';

/// An in-memory implementation of [SettingsPersistence].
/// Useful for testing.
class InMemorySettingsPersistence implements SettingsPersistence {
  /// The saved locale.
  Locale? locale;

  /// The saved dark mode setting.
  bool? darkModeOn;

  /// The saved initial setup completion setting.
  bool? initialSetupCompleted;

  /// The saved IP address setting.
  String? ipAddress;

  /// The saved port setting.
  int? port;

  @override
  Future<Locale?> getLocale() async => locale;

  @override
  Future<bool?> getDarkModeOn() async => darkModeOn;

  @override
  Future<bool?> getInitialSetupCompleted() async => initialSetupCompleted;

  @override
  Future<String?> getIpAddress() async => ipAddress;

  @override
  Future<int?> getPort() async => port;

  @override
  Future<void> saveLocale({required Locale locale}) async =>
      this.locale = locale;

  @override
  Future<void> saveDarkModeOn({required bool active}) async =>
      darkModeOn = active;

  @override
  Future<void> saveInitialSetupCompleted({required bool completed}) async =>
      initialSetupCompleted = completed;

  @override
  Future<void> saveIpAddress({required String? ipAddress}) async =>
      this.ipAddress = ipAddress;

  @override
  Future<void> savePort({required int? port}) async => this.port = port;

  @override
  Future<void> clear() async {
    locale = null;
    darkModeOn = null;
    initialSetupCompleted = null;
    ipAddress = null;
    port = null;
  }
}
