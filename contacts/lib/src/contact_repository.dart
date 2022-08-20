import 'contact.dart';

abstract class ContactService {
  Future<List<Contact>> getContacts();
  Future<void> updateContact(Contact contact);
}
