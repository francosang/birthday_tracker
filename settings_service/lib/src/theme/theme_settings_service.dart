import 'package:persistence/persistence.dart';

const _keyTheme = 'SettingsService.Theme';

extension _StringThemeConverterExtension on String {
  AppTheme? toTheme() {
    if (this == AppTheme.light.name) return AppTheme.light;
    if (this == AppTheme.system.name) return AppTheme.system;
    if (this == AppTheme.dark.name) return AppTheme.dark;
    return null;
  }
}

enum AppTheme {
  system,
  light,
  dark
}

class ThemeSettingsService {
  final ValuesRepository _valuesRepository;

  ThemeSettingsService(this._valuesRepository);

  Future<AppTheme> appTheme() async {
    final theme = await _valuesRepository.getString(_keyTheme);
    return theme?.toTheme() ?? AppTheme.system;
  }

  Future<void> updateAppTheme(AppTheme theme) async {
    await _valuesRepository.setString(_keyTheme, theme.name);
  }
}
