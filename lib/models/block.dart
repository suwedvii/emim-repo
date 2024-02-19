// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:emim/models/room.dart';
import 'package:firebase_database/firebase_database.dart';

class Block {
  String id;
  String name;
  String campus;
  List<Room>? rooms;

  Block({this.id = 'N/A', this.name = 'N/A', this.campus = 'N/A', this.rooms});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'campus': campus,
      'rooms': rooms,
    };
  }

  factory Block.fromMap(Map<String, dynamic> map) {
    return Block(
      id: map['id'] as String,
      name: map['name'] as String,
      campus: map['campus'] as String,
      rooms: List<Room>.from(
          map['rooms'] as List<Room>), // Fix: added closing parenthesis
    );
  }

  String toJson() => json.encode(toMap());

  factory Block.fromJson(String source) =>
      Block.fromMap(json.decode(source) as Map<String, dynamic>);

  Block fromSnapShot(DataSnapshot snapshot) => Block(
        id: snapshot.child('id').value.toString(),
        name: snapshot.child('name').value.toString(),
        campus: snapshot.child('campus').value.toString(),
        rooms: getRooms(snapshot.child('rooms')),
      );

  List<Room> getRooms(DataSnapshot snapshot) {
    final List<Room> rooms = [];
    if (snapshot.exists) {
      for (final room in snapshot.children) {
        final id = room.child('id').value.toString();
        final name = room.child('name').value.toString();
        final capacity =
            int.tryParse(room.child('capacity').value.toString()) ?? 0;
        rooms.add(Room(id: id, name: name, capacity: capacity));
      }
    }

    return rooms;
  }
}
