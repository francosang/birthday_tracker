import 'package:birthday_tracker/settings/settings_controller.dart';
import 'package:contacts/contacts.dart';
import 'package:contacts_impl/contacts_impl.dart';
import 'package:flutter/material.dart';
import 'package:permissions/permissions.dart';
import 'package:permissions_impl/permissions_impl.dart';
import 'package:persistence_hive_impl/persistence_hive_imple.dart';
import 'package:provider/provider.dart';
import 'package:settings/settings.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Move to Provider injection
  // TODO: Move SettingsController to Bloc
  final settingsController =
      SettingsController(ThemeSettingsService(PersistenceServiceImpl()));
  await settingsController.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        Provider<ContactService>(create: (_) => ContactServiceImpl()),
        Provider<PermissionsService>(create: (_) => PermissionsServiceImpl()),
      ],
      child: MyApp(
        settingsController: settingsController,
      ),
    ),
  );
}
