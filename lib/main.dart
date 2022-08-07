import 'package:flutter/material.dart';
import 'package:persistence_hive_impl/persistence_hive_imple.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService(HiveValuesRepositoryImpl()));

  await settingsController.loadSettings();

  runApp(MyApp(settingsController: settingsController));
}
