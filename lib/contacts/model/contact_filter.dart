import 'package:contacts/contacts.dart';

enum ContactsFilter {
  knownBirthdays,
  missingBirthdays,
}

extension ContactsFilterX on ContactsFilter {
  bool apply(Contact contact) {
    switch (this) {
      case ContactsFilter.knownBirthdays:
        return contact.birthdays?.isNotEmpty ?? false;
      case ContactsFilter.missingBirthdays:
        return contact.birthdays?.isEmpty ?? true;
    }
  }

  Iterable<Contact> applyAll(Iterable<Contact> contacts) {
    return contacts.where(apply);
  }
}

int tabIndex(ContactsFilter filter) {
  switch (filter) {
    case ContactsFilter.knownBirthdays:
      return 0;
    case ContactsFilter.missingBirthdays:
      return 1;
  }
}

ContactsFilter tabFilter(int index) {
  switch (index) {
    case 0:
      return ContactsFilter.knownBirthdays;
    case 1:
    default:
      return ContactsFilter.missingBirthdays;
  }
}
