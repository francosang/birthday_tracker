import 'contact.dart';

abstract class ContactService {
  Future<bool> requestPermission();
  Future<List<Contact>> getContacts();
}
