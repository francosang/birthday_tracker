import 'contact.dart';

abstract class ContactService {
  Future<List<Contact>> getContacts();
}
