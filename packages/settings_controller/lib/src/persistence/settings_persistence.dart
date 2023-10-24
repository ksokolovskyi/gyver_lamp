import 'dart:ui';

/// An interface of persistence stores for settings.
///
/// Implementations can range from simple in-memory storage through
/// local preferences to cloud-based solutions.
abstract class SettingsPersistence {
  /// Returns the latest saved locale.
  Future<Locale?> getLocale();

  /// Returns the latest saved dark mode setting.
  Future<bool?> getDarkModeOn();

  /// Returns the latest saved initial setup completion setting.
  Future<bool?> getInitialSetupCompleted();

  /// Returns the latest saved IP address setting.
  Future<String?> getIpAddress();

  /// Returns the latest saved port setting.
  Future<int?> getPort();

  /// Saves locale.
  Future<void> saveLocale({required Locale locale});

  /// Saves dark mode setting.
  Future<void> saveDarkModeOn({required bool active});

  /// Saves initial setup completion setting.
  Future<void> saveInitialSetupCompleted({required bool completed});

  /// Saves IP address setting.
  Future<void> saveIpAddress({required String? ipAddress});

  /// Saves port setting.
  Future<void> savePort({required int? port});

  /// Clears the store.
  Future<void> clear();
}
