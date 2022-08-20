import 'package:persistence/persistence.dart';

import 'app_theme.dart';

const _keyTheme = 'SettingsService.Theme';

class ThemeSettingsService {
  final PersistenceService _persistenceService;

  ThemeSettingsService(this._persistenceService);

  Future<AppTheme> appTheme() async {
    final theme = await _persistenceService.getString(_keyTheme);
    return theme?.toTheme() ?? AppTheme.system;
  }

  Future<void> updateAppTheme(AppTheme theme) async {
    await _persistenceService.setString(_keyTheme, theme.name);
  }
}

extension _StringThemeConverterExtension on String {
  AppTheme? toTheme() {
    if (this == AppTheme.light.name) return AppTheme.light;
    if (this == AppTheme.system.name) return AppTheme.system;
    if (this == AppTheme.dark.name) return AppTheme.dark;
    return null;
  }
}
