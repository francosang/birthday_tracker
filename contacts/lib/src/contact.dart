import 'dart:typed_data';

class Contact {
  final String id;
  final String name;
  final Uint8List? thumbnail;
  final List<DateTime>? birthdays;

  Contact({
    required this.id,
    required this.name,
    this.thumbnail,
    this.birthdays,
  });

  Contact copyWith({
    String? id,
    String? name,
    Uint8List? thumbnail,
    List<DateTime>? birthdays,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      birthdays: birthdays ?? this.birthdays,
    );
  }
}
