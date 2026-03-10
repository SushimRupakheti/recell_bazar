import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemePreference {
  auto,
  light,
  dark,
}

class AppThemeController {
  static const String _prefsKey = 'app_theme_preference';

  SharedPreferences? _prefs;

  final ValueNotifier<AppThemePreference> preference =
      ValueNotifier<AppThemePreference>(AppThemePreference.auto);

  Future<void> init(SharedPreferences prefs) async {
    _prefs = prefs;

    final raw = prefs.getString(_prefsKey);
    if (raw == null || raw.trim().isEmpty) {
      preference.value = AppThemePreference.auto;
      return;
    }

    preference.value = AppThemePreference.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => AppThemePreference.auto,
    );
  }

  Future<void> setPreference(AppThemePreference next) async {
    preference.value = next;

    final prefs = _prefs;
    if (prefs == null) return;
    await prefs.setString(_prefsKey, next.name);
  }
}

final appThemeController = AppThemeController();
