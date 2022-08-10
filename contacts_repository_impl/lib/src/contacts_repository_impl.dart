import 'package:contacts_repository/contacts_repository.dart';
import 'package:domain/domain.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as lib;

class ContactsRepositoryImpl extends ContactRepository {
  @override
  Future<bool> requestPermission() {
    return lib.FlutterContacts.requestPermission(readonly: true);
  }

  @override
  Future<List<Contact>> getContacts() async {
    final contacts = await lib.FlutterContacts.getContacts(withThumbnail: true, withProperties: true);
    return contacts.map((e) {
      return Contact(
          name: e.displayName,
          thumbnail: e.thumbnail,
          birthdays: e.events
              .where((element) => element.label == lib.EventLabel.birthday)
              .map((e) => DateTime(e.year ?? 0, e.month, e.day))
              .toList());
    }).toList();
  }
}
