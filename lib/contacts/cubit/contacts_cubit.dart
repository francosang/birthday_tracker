import 'package:birthday_tracker/contacts/model/contact_filter.dart';
import 'package:bloc/bloc.dart';
import 'package:contacts/contacts.dart';
import 'package:permissions/permissions.dart';

import 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  final ContactService _contactService;
  final PermissionsService _permissionsService;

  ContactsCubit(
    this._contactService,
    this._permissionsService,
  ) : super(const ContactsState());

  void load() async {
    emit(const ContactsState(loading: true));

    bool hasPermissions = false;
    List<Contact> contacts = [];

    final permission =
        await _permissionsService.requestPermission(Permission.contacts);

    if (permission == PermissionAccess.granted) {
      hasPermissions = true;
      contacts = await _contactService.getContacts();
    } else if (permission == PermissionAccess.permanentlyDenied) {
      await _permissionsService.openAppSettings();
    }

    print(contacts);

    emit(state.copyWith(
      loading: false,
      contacts: contacts,
      hasPermission: hasPermissions,
    ));
  }

  void updateFilter(ContactsFilter? filterType) {
    if (filterType == null) return;
    emit(state.copyWith(filter: filterType));
  }
}
