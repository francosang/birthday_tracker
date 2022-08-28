import 'package:contacts/contacts.dart';

class HiddenContactsState {
  final List<Contact> contacts;
  final bool loading;
  final bool hasPermission;
  final Contact? lastShownContact;
  final String? error;

  const HiddenContactsState({
    this.contacts = const [],
    this.hasPermission = true,
    this.loading = false,
    this.lastShownContact,
    this.error,
  });

  HiddenContactsState copyWith({
    List<Contact>? contacts,
    bool? loading,
    bool? hasPermission,
    Contact? lastShownContact,
    String? error,
  }) {
    return HiddenContactsState(
      contacts: contacts ?? this.contacts,
      error: error ?? this.error,
      loading: loading ?? this.loading,
      hasPermission: hasPermission ?? this.hasPermission,
      lastShownContact: lastShownContact ?? this.lastShownContact,
    );
  }
}
