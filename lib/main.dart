import 'package:flutter/material.dart';
import 'package:persistence_hive_impl/persistence_hive_imple.dart';
import 'package:settings_service/settings_service.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';

void main() async {
  final settingsController = SettingsController(ThemeSettingsService(HiveValuesRepositoryImpl()));

  await settingsController.loadSettings();

  runApp(MyApp(settingsController: settingsController));
}
