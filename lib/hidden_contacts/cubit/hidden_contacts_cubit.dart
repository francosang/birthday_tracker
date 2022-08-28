import 'package:bloc/bloc.dart';
import 'package:contacts/contacts.dart';
import 'package:permissions/permissions.dart';

import 'hidden_contacts_state.dart';

class HiddenContactsCubit extends Cubit<HiddenContactsState> {
  final ContactService _contactService;
  final PermissionsService _permissionsService;

  HiddenContactsCubit(
    this._contactService,
    this._permissionsService,
  ) : super(const HiddenContactsState());

  Future<void> load() async {
    emit(const HiddenContactsState(loading: true));

    bool hasPermissions = false;
    List<Contact> contacts = [];

    final permission =
        await _permissionsService.requestPermission(Permission.contacts);

    if (permission == PermissionAccess.granted) {
      hasPermissions = true;
      contacts = await _contactService.getContacts(onlyHidden: true);
    } else if (permission == PermissionAccess.permanentlyDenied) {
      await _permissionsService.openAppSettings();
    }

    emit(state.copyWith(
      loading: false,
      contacts: contacts,
      hasPermission: hasPermissions,
    ));
  }

  Future<void> showContact(Contact contact) async {
    await _contactService.showContact(contact);

    final contacts = await _contactService.getContacts(onlyHidden: true);

    emit(state.copyWith(
      loading: false,
      contacts: contacts,
      lastShownContact: contact,
    ));
  }

  Future<void> undoShowContact(Contact contact) async {
    await _contactService.hideContact(contact);

    final contacts = await _contactService.getContacts(onlyHidden: true);

    emit(state.copyWith(
      loading: false,
      lastShownContact: null,
      contacts: contacts,
    ));
  }
}
