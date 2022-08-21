import 'contact.dart';

abstract class ContactService {
  Future<List<Contact>> getContacts();
  Future<void> updateContact(Contact contact);
  Future<void> ignoreContact(Contact contact);
  Future<void> activateContact(Contact contact);
}
