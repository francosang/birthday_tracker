import 'package:contacts/contacts.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as lib;
import 'package:persistence/persistence.dart';

const _ignoredContactsKey = 'ignored_contacts';

class ContactServiceImpl extends ContactService {
  final PersistenceService _persistenceService;

  ContactServiceImpl(this._persistenceService);

  @override
  Future<List<Contact>> getContacts() async {
    final contacts = await lib.FlutterContacts.getContacts(
      withThumbnail: true,
      withProperties: true,
    );

    final ignoredContacts = (await _persistenceService.getStringArray(
            _ignoredContactsKey, () => []))
        .toSet();

    return contacts
        .where((element) => !ignoredContacts.contains(element.id))
        .map((e) {
      return Contact(
        id: e.id,
        name: e.displayName,
        thumbnail: e.thumbnail,
        birthdays: e.events
            .where((element) => element.label == lib.EventLabel.birthday)
            .map((e) => DateTime(e.year ?? 0, e.month, e.day))
            .toList(),
      );
    }).toList();
  }

  @override
  Future<void> updateContact(Contact contact) async {
    final bd = contact.birthdays;
    if (bd == null) return;

    final fetched = await lib.FlutterContacts.getContact(
      contact.id,
      withThumbnail: true,
      withProperties: true,
      withAccounts: true,
    );

    if (fetched == null) return;

    fetched.events = contact.birthdays
            ?.map((bd) => lib.Event(
                  year: bd.year,
                  month: bd.month,
                  day: bd.day,
                  label: lib.EventLabel.birthday,
                ))
            .toList() ??
        [];

    await lib.FlutterContacts.updateContact(fetched);
  }

  @override
  Future<void> ignoreContact(Contact contact) async {
    final ignoredContacts =
        await _persistenceService.getStringArray(_ignoredContactsKey, () => []);
    ignoredContacts.add(contact.id);
    _persistenceService.setStringArray(_ignoredContactsKey, ignoredContacts);
  }

  @override
  Future<void> activateContact(Contact contact) async {
    final ignoredContacts =
        await _persistenceService.getStringArray(_ignoredContactsKey, () => []);
    ignoredContacts.removeWhere((element) => element == contact.id);
    _persistenceService.setStringArray(_ignoredContactsKey, ignoredContacts);
  }
}
