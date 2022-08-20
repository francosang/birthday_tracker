import 'dart:typed_data';

class Contact {
  final String id;
  final String name;
  final Uint8List? thumbnail;
  final List<DateTime>? birthdays;

  Contact({required this.id, required this.name, this.thumbnail, this.birthdays});
}