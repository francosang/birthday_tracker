import 'package:contacts_feature/contacts_feature.dart';
import 'package:contacts_repository/contacts_repository.dart';
import 'package:contacts_repository_impl/contacts_repository_impl.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:persistence_hive_impl/persistence_hive_imple.dart';
import 'package:provider/provider.dart';
import 'package:settings_feature/settings_feature.dart';
import 'package:settings_service/settings_service.dart';

import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsController = SettingsController(ThemeSettingsService(HiveValuesRepositoryImpl()));
  await settingsController.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        Provider<ContactRepository>(create: (_) => ContactsRepositoryImpl()),
        Provider<ContactService>(create: (bc) => ContactService(bc.read())),
      ],
      child: MyApp(
        settingsController: settingsController,
      ),
    ),
  );
}
