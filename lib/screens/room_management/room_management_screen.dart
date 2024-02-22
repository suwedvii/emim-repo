import 'package:emim/models/building.dart';
import 'package:emim/screens/room_management/add_building_modal.dart';
import 'package:emim/screens/room_management/building_details_modal.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class RoomManagementScreen extends StatefulWidget {
  const RoomManagementScreen({super.key});

  @override
  State<RoomManagementScreen> createState() => _RoomManagementScreenState();
}

class _RoomManagementScreenState extends State<RoomManagementScreen> {
  DatabaseReference query = FirebaseDatabase.instance.ref().child('buildings');
  bool isLoading = true;
  List<Building> buildings = [];

  void _openAddBuildingBottomModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => const AddBuildingModal(),
    );
  }

  void _openBuildingDetails(Building building) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => BlockDetailsModal(building: building),
    );
  }

  void _getBuildings() {
    query.onValue.listen((event) {
      for (final building in event.snapshot.children) {
        final retrivedBuilding = Building().fromSnapShot(building);
        setState(() {
          buildings.add(retrivedBuilding);
        });
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getBuildings();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        Expanded(
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : FirebaseAnimatedList(
                  query: query,
                  itemBuilder: (ctx, snapshot, animation, index) {
                    final building = Building().fromSnapShot(snapshot);

                    return GestureDetector(
                      onTap: () {
                        _openBuildingDetails(building);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                        child: ListTile(
                          title: Text(
                            building.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text('Campus: ${building.campus}'),
                          subtitle: Text('Rooms: ${building.rooms!.length}'),
                        ),
                      ),
                    );
                  }),
        ),
      ],
    );

    return Scaffold(
        appBar: AppBar(title: const Text('Room Management')),
        body: content,
        floatingActionButton: FloatingActionButton(
            onPressed: _openAddBuildingBottomModal,
            child: const Icon(Icons.add)));
  }
}
