import 'contact.dart';

abstract class ContactService {
  Future<List<Contact>> getContacts({bool onlyHidden = false});
  Future<void> updateContact(Contact contact);
  Future<void> hideContact(Contact contact);
  Future<void> showContact(Contact contact);
}
