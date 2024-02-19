import 'package:emim/models/block.dart';
import 'package:emim/screens/schedule/add_building_modal.dart';
import 'package:emim/screens/schedule/block_details_modal.dart';
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
  List<Map<String, dynamic>> buildings = [];

  void _openAddBuildingBottomModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => const AddBuildingModal(),
    );
  }

  void _openBuildingDetails(String name, Block building) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => BlockDetailsModal(name: name, building: building),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        Expanded(
          child: FirebaseAnimatedList(
              query: query,
              itemBuilder: (ctx, snapshot, animation, index) {
                final building = Block().fromSnapShot(snapshot);

                return GestureDetector(
                  onTap: () {
                    _openBuildingDetails(building.name, building);
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: ListTile(
                      title: Text(
                        building.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(building.campus),
                      subtitle: Text(building.id),
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
