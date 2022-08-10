import 'package:bloc/bloc.dart';
import 'package:contacts_service/contacts_service.dart';

import 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final ContactService _contactService;
  ContactsCubit(this._contactService) : super(const ContactsState.empty());

  void load() async {
    final separated = await _contactService.getContacts();

    emit(state.copyWith(
      contacts: separated.withBirthdays + separated.allOthers,
    ));
  }

  void updateFilter(FilterType? value) {
    if (value == null) return;

    emit(state.copyWith(filterType: value));
  }
}
