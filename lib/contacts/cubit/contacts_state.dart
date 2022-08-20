import 'package:birthday_tracker/contacts/model/contact_filter.dart';
import 'package:contacts/contacts.dart';

class ContactsState {
  final List<Contact> contacts;
  final ContactsFilter filter;
  final bool loading;
  final bool hasPermission;
  final String? error;

  const ContactsState({
    this.contacts = const [],
    this.filter = ContactsFilter.withBirthday,
    this.hasPermission = true,
    this.loading = false,
    this.error,
  });

  Iterable<Contact> get filteredContacts => filter.applyAll(contacts);

  ContactsState copyWith({
    List<Contact>? contacts,
    ContactsFilter? filter,
    bool? loading,
    bool? hasPermission,
    String? error,
  }) {
    return ContactsState(
      contacts: contacts ?? this.contacts,
      error: error ?? this.error,
      loading: loading ?? this.loading,
      hasPermission: hasPermission ?? this.hasPermission,
      filter: filter ?? this.filter,
    );
  }
}
