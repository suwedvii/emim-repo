import 'package:emim/models/block.dart';
import 'package:emim/models/room.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BlockDetailsModal extends StatefulWidget {
  const BlockDetailsModal(
      {super.key, required this.name, required this.building});

  final String name;
  final Block building;

  @override
  State<BlockDetailsModal> createState() => _BlockDetailsModalState();
}

class _BlockDetailsModalState extends State<BlockDetailsModal> {
  DatabaseReference? databaseRef;
  final form = GlobalKey<FormState>();
  List<Room>? rooms;
  String? newRoom = '';

  void _goToRoomSchedules(String id) {}

  void _deleteRoom(int index) {}

  void _addRoom() {}

  @override
  void dispose() {
    super.dispose();
    form.currentState?.dispose();
  }

  @override
  void initState() {
    super.initState();
    databaseRef = FirebaseDatabase.instance.ref().child('buildings');
    rooms = widget.building.rooms;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.building.rooms!.isNotEmpty) {
      print(widget.building.rooms!.length);
    }

    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: keyboardspace + 8),
      child: Form(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            widget.name.toUpperCase(),
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
                  _goToRoomSchedules(rooms![index].id);
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
                      hintText: 'Add Room',
                    ),
                    validator: (room) {
                      if (room == null || room.trim().length < 5) {
                        return 'Rnter a valid room name.';
                      }

                      return null;
                    },
                    onSaved: (room) {
                      newRoom = room;
                    },
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _addRoom();
                  },
                  icon: const Icon(Icons.add_box_rounded),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
