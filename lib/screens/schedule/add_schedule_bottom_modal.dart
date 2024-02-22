import 'package:emim/models/building.dart';
import 'package:emim/models/schedule.dart';
import 'package:emim/widgets/custom_drop_down_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddScheduleButtomModal extends StatefulWidget {
  const AddScheduleButtomModal({super.key, required this.mode});

  final String mode;

  @override
  State<AddScheduleButtomModal> createState() => _AddScheduleButtomModalState();
}

class _AddScheduleButtomModalState extends State<AddScheduleButtomModal> {
  bool isLoading = true;
  final List<Schedule> schedules = [];
  late DatabaseReference buildingsRef;

  Campuses campus = Campuses.blantyre;
  String selectedCampus = '';
  String selectedBuilding = 'Chikanda';
  String selectedroom = '';
  String? course;
  String? weekDay;
  String? room;

  List<Building> buildings = [];
  List<String> rooms = [];

  final formKey = GlobalKey<FormState>();

  void _getBuildings() {
    buildingsRef = FirebaseDatabase.instance.ref().child('buildings');

    List<Building> retrivedBuildings = [];

    buildingsRef.onValue.listen((event) {
      for (final building in event.snapshot.children) {
        final retrivedBuilding = Building().fromSnapShot(building);
        setState(() {
          retrivedBuildings.add(retrivedBuilding);
        });
      }
    });

    setState(() {
      buildings = retrivedBuildings;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getBuildings();
  }

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    if (buildings.isNotEmpty) {
      rooms = buildings
          .firstWhere((building) => building.name == selectedBuilding)
          .rooms!
          .map((room) => room.name)
          .toList();
    }
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, keyboardSpace + 8),
      padding: const EdgeInsets.only(top: 16),
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                ('Add ${widget.mode}').toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              CustomDropdown(
                  items: Campuses.values.map((e) => e.name).toList(),
                  value: campus.name,
                  onChanged: (_campus) {
                    if (_campus == null) return;
                    setState(() {
                      selectedCampus = _campus;
                    });
                  },
                  label: 'Campus'),
              const SizedBox(
                height: 8,
              ),
              CustomDropdown(
                  items: buildings.map((building) => building.name).toList(),
                  value:
                      buildings.isEmpty ? 'Select Campus' : buildings[0].name,
                  onChanged: (_building) {
                    if (_building == null) return;
                    setState(() {
                      selectedBuilding = _building;
                    });
                  },
                  label: 'Building'),
              const SizedBox(
                height: 8,
              ),
              CustomDropdown(
                  items: rooms,
                  value: rooms.isEmpty ? 'Select building first' : rooms[0],
                  onChanged: (_room) {
                    if (_room == null) return;
                    setState(() {
                      selectedroom = _room;
                    });
                  },
                  label: 'Room'),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
