import 'package:flutter/material.dart';
import 'package:settings_service/settings_service.dart';

extension _AppThemeConverterExtension on AppTheme {
  ThemeMode toThemeMode() {
    switch (this) {
      case AppTheme.system:
        return ThemeMode.system;
      case AppTheme.light:
        return ThemeMode.light;

      case AppTheme.dark:
        return ThemeMode.dark;
    }
  }
}

extension _ThemeModeConverterExtension on ThemeMode {
  AppTheme toAppTheme() {
    switch (this) {
      case ThemeMode.system:
        return AppTheme.system;
      case ThemeMode.light:
        return AppTheme.light;
      case ThemeMode.dark:
        return AppTheme.dark;
    }
  }
}

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final ThemeSettingsService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    final appTheme = await _settingsService.appTheme();

    _themeMode = appTheme.toThemeMode();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateAppTheme(newThemeMode.toAppTheme());
  }
}
