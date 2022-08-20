import 'package:contacts/contacts.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as lib;

class ContactServiceImpl extends ContactService {
  @override
  Future<List<Contact>> getContacts() async {
    final contacts = await lib.FlutterContacts.getContacts(
        withThumbnail: true, withProperties: true);
    return contacts.map((e) {
      return Contact(
          id: e.id,
          name: e.displayName,
          thumbnail: e.thumbnail,
          birthdays: e.events
              .where((element) => element.label == lib.EventLabel.birthday)
              .map((e) => DateTime(e.year ?? 0, e.month, e.day))
              .toList());
    }).toList();
  }
}
