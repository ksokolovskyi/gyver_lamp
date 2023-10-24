import 'dart:ui';

import 'package:intl/locale.dart' as intl;
import 'package:settings_controller/settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An implementation of [SettingsPersistence] that uses
/// `package:shared_preferences`.
class LocalStorageSettingsPersistence implements SettingsPersistence {
  final Future<SharedPreferences> _instanceFuture =
      SharedPreferences.getInstance();

  /// Parses [rawLocale] to produce [Locale].
  static Locale? _parseLocale(String rawLocale) {
    final intlLocale = intl.Locale.tryParse(rawLocale);

    if (intlLocale != null) {
      return Locale.fromSubtags(
        languageCode: intlLocale.languageCode,
        countryCode: intlLocale.countryCode,
        scriptCode: intlLocale.scriptCode,
      );
    }

    return null;
  }

  @override
  Future<Locale?> getLocale() async {
    final prefs = await _instanceFuture;
    final rawLocale = prefs.getString('locale');

    if (rawLocale == null) {
      return null;
    }

    return _parseLocale(rawLocale);
  }

  @override
  Future<bool?> getDarkModeOn() async {
    final prefs = await _instanceFuture;
    return prefs.getBool('darkModeOn');
  }

  @override
  Future<bool?> getInitialSetupCompleted() async {
    final prefs = await _instanceFuture;
    return prefs.getBool('initialSetupCompleted');
  }

  @override
  Future<String?> getIpAddress() async {
    final prefs = await _instanceFuture;
    return prefs.getString('ipAddress');
  }

  @override
  Future<int?> getPort() async {
    final prefs = await _instanceFuture;
    return prefs.getInt('port');
  }

  @override
  Future<void> saveLocale({required Locale locale}) async {
    final prefs = await _instanceFuture;
    await prefs.setString('locale', locale.toLanguageTag());
  }

  @override
  Future<void> saveDarkModeOn({required bool active}) async {
    final prefs = await _instanceFuture;
    await prefs.setBool('darkModeOn', active);
  }

  @override
  Future<void> saveInitialSetupCompleted({required bool completed}) async {
    final prefs = await _instanceFuture;
    await prefs.setBool('initialSetupCompleted', completed);
  }

  @override
  Future<void> saveIpAddress({required String? ipAddress}) async {
    final prefs = await _instanceFuture;

    if (ipAddress == null) {
      await prefs.remove('ipAddress');
    } else {
      await prefs.setString('ipAddress', ipAddress);
    }
  }

  @override
  Future<void> savePort({required int? port}) async {
    final prefs = await _instanceFuture;

    if (port == null) {
      await prefs.remove('port');
    } else {
      await prefs.setInt('port', port);
    }
  }

  @override
  Future<void> clear() async {
    final prefs = await _instanceFuture;
    await prefs.clear();
  }
}
