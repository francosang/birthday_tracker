import 'package:flutter/material.dart';
import 'package:persistence/persistence.dart';

const _keyTheme = 'SettingsService.Theme';

extension _StringThemeConverterExtension on String {
  ThemeMode? toTheme() {
    if (this == ThemeMode.light.name) return ThemeMode.light;
    if (this == ThemeMode.system.name) return ThemeMode.system;
    if (this == ThemeMode.dark.name) return ThemeMode.dark;
    return null;
  }
}

class SettingsService {
  final ValuesRepository _valuesRepository;

  SettingsService(this._valuesRepository);

  Future<ThemeMode> themeMode() async {
    final theme = await _valuesRepository.getString(_keyTheme);
    return theme?.toTheme() ?? ThemeMode.system;
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    await _valuesRepository.setString(_keyTheme, theme.name);
  }
}
