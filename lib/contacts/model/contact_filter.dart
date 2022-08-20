import 'package:contacts/contacts.dart';

enum ContactsFilter {
  all,
  withBirthday,
  missingBirthday,
}

extension ContactsFilterX on ContactsFilter {
  bool apply(Contact contact) {
    switch (this) {
      case ContactsFilter.all:
        return true;
      case ContactsFilter.withBirthday:
        return contact.birthdays?.isNotEmpty ?? false;
      case ContactsFilter.missingBirthday:
        return contact.birthdays?.isEmpty ?? true;
    }
  }

  Iterable<Contact> applyAll(Iterable<Contact> contacts) {
    return contacts.where(apply);
  }
}
