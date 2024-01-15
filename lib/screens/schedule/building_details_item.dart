import 'package:emim/models/bulding.dart';
import 'package:emim/screens/schedule/room_schedules_screen.dart';
import 'package:flutter/material.dart';

class BuildingDetailsItem extends StatefulWidget {
  const BuildingDetailsItem(
      {super.key, required this.building, required this.onBuidldingUpdated});
  final Building building;
  final Function(List<Building>) onBuidldingUpdated;

  @override
  State<BuildingDetailsItem> createState() => _BuildingDetailsItemState();
}

class _BuildingDetailsItemState extends State<BuildingDetailsItem> {
  String? newRoom;
  final formKey = GlobalKey<FormState>();

  void _addRoom() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        widget.building.rooms.add(newRoom!);
        formKey.currentState!.reset();
        widget.onBuidldingUpdated(dummyBuildings);
      });
    }
  }

  void _deleteRoom(int index) {
    setState(() {
      widget.building.rooms.removeAt(index);
      widget.onBuidldingUpdated(dummyBuildings);
    });
  }

  void _goToRoomSchedules(String room) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => RoomSchedulesScreen(
          room: room,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 8),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${widget.building.name} (${widget.building.campus.name} campus)',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: widget.building.rooms.length.toDouble() * 60,
              ),
              child: ListView.builder(
                itemCount: widget.building.rooms.length,
                itemBuilder: (ctx, index) => GestureDetector(
                  onTap: () {
                    _goToRoomSchedules(widget.building.rooms[index]);
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
                          Text(widget.building.rooms[index]),
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
          ],
        ),
      ),
    );
  }
}
