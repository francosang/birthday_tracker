import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactsController with ChangeNotifier {
  // Make SettingsService a private variable so it is not used directly.
  final ContactService _contactsService;

  var _contacts = ContactsSeparated.empty();
  String? _error;

  ContactsController(this._contactsService) {
    _contactsService.getContacts().then((value) {
      _contacts = value;
    }).catchError((error) {
      _error = error.toString();
    }).whenComplete(() {
      notifyListeners();
    });
  }

  ContactsSeparated get contacts => _contacts;

  String? get error => _error;
}
