import 'package:emim/models/block.dart';
import 'package:emim/models/room.dart';
import 'package:emim/screens/schedule/room_schedules_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BlockDetailsModal extends StatefulWidget {
  const BlockDetailsModal({super.key, required this.building});

  final Block building;

  @override
  State<BlockDetailsModal> createState() => _BlockDetailsModalState();
}

class _BlockDetailsModalState extends State<BlockDetailsModal> {
  bool isLoading = false;
  DatabaseReference? databaseRef;
  final form = GlobalKey<FormState>();
  List<Room>? rooms;
  String? newRoom = '';
  int? newRoomCapacity = 0;

  void _goToRoomSchedules(Room room) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => RoomSchedulesScreen(room: room)));
  }

  void _deleteRoom(int index) async {
    setState(() {
      isLoading = true;
    });

    await databaseRef!.child(rooms![index].id).remove().whenComplete(() {
      setState(() {
        rooms!.removeAt(index);
        isLoading = false;
      });
    });
  }

  void _addRoom() async {
    if (form.currentState!.validate()) {
      form.currentState!.save();
      setState(() {
        isLoading = true;
      });

      final id = databaseRef!.push().key!;

      final room = Room(id: id, name: newRoom!, capacity: newRoomCapacity!);

      await databaseRef!.child(room.id).set(room.toMap()).whenComplete(() {
        setState(() {
          rooms!.add(Room(capacity: newRoomCapacity!, name: newRoom!));
          isLoading = false;
          form.currentState!.reset();
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    form.currentState?.dispose();
  }

  @override
  void initState() {
    super.initState();
    databaseRef = FirebaseDatabase.instance
        .ref()
        .child('buildings')
        .child(widget.building.id)
        .child('rooms');
    rooms = widget.building.rooms;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.building.id);
    if (widget.building.rooms!.isNotEmpty) {
      print(widget.building.rooms!.length);
    }

    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: keyboardspace + 8),
      child: Form(
        key: form,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            widget.building.name.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: rooms!.length.toDouble() * 60,
            ),
            child: ListView.builder(
              itemCount: rooms!.length,
              itemBuilder: (ctx, index) => GestureDetector(
                onTap: () {
                  _goToRoomSchedules(rooms![index]);
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 8),
                  margin: const EdgeInsets.only(bottom: 8),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Text(rooms![index].name),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            _deleteRoom(index);
                          },
                          icon: Icon(
                            Icons.delete_forever,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Divider(
            indent: 32,
            endIndent: 32,
            thickness: 2,
            color: Theme.of(context).colorScheme.primary,
            height: 8,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Add Room',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter Name',
                    ),
                    validator: (room) {
                      if (room == null || room.trim().length < 5) {
                        return 'Enter a valid room name.';
                      }

                      return null;
                    },
                    onSaved: (room) {
                      newRoom = room;
                    },
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter Capacity',
                    ),
                    validator: (room) {
                      if (room == null || room.trim().isEmpty) {
                        return 'Enter a valid number for capicity.';
                      }

                      return null;
                    },
                    onSaved: (room) {
                      newRoomCapacity = int.tryParse(room!);
                    },
                  ),
                ),
                IconButton(
                  onPressed: _addRoom,
                  icon: const Icon(Icons.add_box_rounded),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(),
                  )
                : const Text('Close'),
          )
        ]),
      ),
    );
  }
}
