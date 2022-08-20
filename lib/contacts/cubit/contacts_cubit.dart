import 'package:birthday_tracker/contacts/model/contact_filter.dart';
import 'package:bloc/bloc.dart';
import 'package:contacts/contacts.dart';

import 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final ContactService _contactService;
  ContactsCubit(this._contactService) : super(const ContactsState());

  void load() async {
    emit(const ContactsState(loading: true));

    List<Contact> contacts = [];

    final permission = await _contactService.requestPermission();

    print('permission: $permission');

    if (permission) {
      contacts = await _contactService.getContacts();

      print('contacts: $contacts');
    }

    emit(state.copyWith(
      loading: false,
      contacts: contacts,
      hasPermission: permission,
    ));
  }

  void updateFilter(ContactsFilter? filterType) {
    if (filterType == null) return;
    emit(state.copyWith(filter: filterType));
  }
}
