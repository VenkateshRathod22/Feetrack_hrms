import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemePreference {
  static const String _themeModeKey = 'app_theme_mode';

  static Future<ThemeMode> load() async {
    final prefs = await SharedPreferences.getInstance();

    switch (prefs.getString(_themeModeKey)) {
      case 'light':
        return ThemeMode.light;

      case 'dark':
        return ThemeMode.dark;

      case 'system':
        return ThemeMode.system;

      default:
        return ThemeMode.system;
    }
  }

  static Future<void> save(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    String value;

    switch (mode) {
      case ThemeMode.light:
        value = 'light';
        break;

      case ThemeMode.dark:
        value = 'dark';
        break;

      case ThemeMode.system:
        value = 'system';
        break;
    }

    await prefs.setString(_themeModeKey, value);
  }
}