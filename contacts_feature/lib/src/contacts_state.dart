import 'package:domain/domain.dart';

enum FilterType {
  all,
  withBirthdays,
  withoutBirthdays,
}

class ContactsState {
  final List<Contact> _unfilteredContacts;
  final FilterType filterType;
  final String? error;

  const ContactsState({
    required List<Contact> contacts,
    required this.filterType,
    this.error,
  }) : _unfilteredContacts = contacts;

  const ContactsState.empty()
      : this(
          contacts: const [],
          filterType: FilterType.all,
        );

  List<Contact> get contacts => _unfilteredContacts.where((element) {
        if (filterType == FilterType.all) return true;
        final hasBDay = element.birthdays?.isNotEmpty ?? false;
        if (filterType == FilterType.withBirthdays && hasBDay) return true;
        if (filterType == FilterType.withoutBirthdays && !hasBDay) return true;
        return false;
      }).toList();

  ContactsState copyWith({
    List<Contact>? contacts,
    FilterType? filterType,
    String? error,
  }) {
    return ContactsState(
      contacts: contacts ?? _unfilteredContacts,
      error: error ?? this.error,
      filterType: filterType ?? this.filterType,
    );
  }
}
