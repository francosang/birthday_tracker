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

  Future<void> load() async {
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

    emit(state.copyWith(
      loading: false,
      contacts: contacts,
      hasPermission: hasPermissions,
    ));
  }

  Future<void> refresh() async {
    emit(state.copyWith(loading: true));

    final contacts = await _contactService.getContacts();

    emit(state.copyWith(
      loading: false,
      contacts: contacts,
    ));
  }

  void updateFilter(ContactsFilter? filterType) {
    if (filterType == null) return;
    emit(state.copyWith(filter: filterType));
  }

  Future<void> addContactBirthday({
    required Contact contact,
    required DateTime? birthDate,
  }) async {
    emit(state.copyWith(loading: true));

    if (birthDate == null || (contact.birthdays?.isNotEmpty ?? true)) return;

    contact.birthdays?.add(birthDate);

    final update = contact.copyWith(birthdays: contact.birthdays);
    await _contactService.updateContact(update);

    final contacts = await _contactService.getContacts();

    emit(state.copyWith(
      loading: false,
      contacts: contacts,
    ));
  }

  Future<void> hideContact(Contact contact) async {
    _contactService.hideContact(contact);

    final contacts = await _contactService.getContacts();

    emit(state.copyWith(
      loading: false,
      contacts: contacts,
      lastIgnoredContact: contact,
    ));
  }

  Future<void> undoHideContact(Contact contact) async {
    _contactService.showContact(contact);

    final contacts = await _contactService.getContacts();

    emit(state.copyWith(
      loading: false,
      lastIgnoredContact: null,
      contacts: contacts,
    ));
  }
}
