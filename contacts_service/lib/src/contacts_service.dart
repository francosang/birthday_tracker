import 'dart:core';

import 'package:domain/domain.dart';
import 'package:contacts_repository/contacts_repository.dart';

class ContactService {
  final ContactRepository _contactRepository;

  const ContactService(this._contactRepository);

  Future<ContactsSeparated> getContacts() async {
    if (!await _contactRepository.requestPermission()) {
      print('fuck');
      return ContactsSeparated.empty();
    }

    final withBirthdays = <Contact>[];
    final allOthers = <Contact>[];

    final contacts = await _contactRepository.getContacts();

    print('contacts: ${contacts.length}');

    for (final c in contacts) {
      if (c.birthdays?.isNotEmpty ?? false) {
        withBirthdays.add(c);
      } else {
        allOthers.add(c);
      }
    }

    return ContactsSeparated(
      withBirthdays: withBirthdays,
      allOthers: allOthers,
    );
  }
}
