// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Room {
  String id;
  String name;
  int capacity;
  Room({
    required this.id,
    required this.name,
    required this.capacity,
  });

  Room copyWith({
    String? id,
    String? name,
    int? capacity,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'capacity': capacity,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] as String,
      name: map['name'] as String,
      capacity: map['capacity'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) =>
      Room.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Room(id: $id, name: $name, capacity: $capacity)';

  @override
  bool operator ==(covariant Room other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.capacity == capacity;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ capacity.hashCode;
}
