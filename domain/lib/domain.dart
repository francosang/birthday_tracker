library domain;

import 'dart:typed_data';

class Contact {
  final String name;
  final Uint8List? thumbnail;
  final List<DateTime>? birthdays;

  Contact({required this.name, this.thumbnail, this.birthdays});
}

class ContactsSeparated {
  final List<Contact> withBirthdays;
  final List<Contact> allOthers;

  ContactsSeparated({
    required this.withBirthdays,
    required this.allOthers,
  });

  ContactsSeparated.empty() : this(withBirthdays: [], allOthers: []);
}