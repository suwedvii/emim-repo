import 'package:emim/models/bulding.dart';
import 'package:emim/screens/schedule/add_building_modal.dart';
import 'package:emim/screens/schedule/building_details_item.dart';
import 'package:flutter/material.dart';

class ManageRoomsScreen extends StatefulWidget {
  const ManageRoomsScreen({super.key});

  @override
  State<ManageRoomsScreen> createState() => _ManageRoomsScreenState();
}

class _ManageRoomsScreenState extends State<ManageRoomsScreen> {
  List<Building> buildings = [];

  @override
  void initState() {
    super.initState();
    buildings = dummyBuildings;
  }

  void _loadBuildings(List<Building> updatedBuildings) {
    setState(() {
      buildings = updatedBuildings;
    });
  }

  void _openBuildingDetailsBottomSheetModal(Building building) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => BuildingDetailsItem(
        onBuidldingUpdated: _loadBuildings,
        building: building,
      ),
    );
  }

  void _openAddBuildingBottomModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => const AddBuildingModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Buildings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: buildings.length,
                itemBuilder: (ctx, index) => GestureDetector(
                      onTap: () {
                        _openBuildingDetailsBottomSheetModal(buildings[index]);
                      },
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                buildings[index].name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Row(
                                children: [
                                  const Text('Campus:'),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    buildings[index].campus.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  const Text('Rooms:'),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    buildings[index].rooms.length.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
          )
        ],
      ),
    );

    if (buildings.isEmpty) {
      content = const Center(
        child: Text('Oops, no buildings found!'),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Room Management'),
        ),
        body: content,
        floatingActionButton: FloatingActionButton(
          onPressed: _openAddBuildingBottomModal,
          child: const Icon(Icons.add),
        ));
  }
}
