import 'dart:typed_data';

class Contact {
  final String name;
  final Uint8List? thumbnail;
  final List<DateTime>? birthdays;

  Contact({required this.name, this.thumbnail, this.birthdays});
}

abstract class ContactRepository {
  Future<bool> requestPermission();
  Future<List<Contact>> getContacts();
}
