import 'package:domain/domain.dart';

abstract class ContactRepository {
  Future<bool> requestPermission();
  Future<List<Contact>> getContacts();
}
