import 'package:emim/models/bulding.dart';
import 'package:emim/models/schedule.dart';
import 'package:emim/widgets/custom_drop_down_button.dart';
import 'package:flutter/material.dart';

class AddScheduleButtomModal extends StatefulWidget {
  const AddScheduleButtomModal({super.key, required this.mode});

  final String mode;

  @override
  State<AddScheduleButtomModal> createState() => _AddScheduleButtomModalState();
}

class _AddScheduleButtomModalState extends State<AddScheduleButtomModal> {
  final List<Schedule> schedules = [];

  Campuses campus = Campuses.blantyre;
  String selectedCampus = '';
  String selectedBuilding = 'Chikanda';
  String selectedroom = '';

  List<Building> buildings = [];

  List<String> rooms = [];

  String? course;
  String? weekDay;

  String? room;
  final listOfBuildings = getBuildings();

  final formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<Campuses>> campusItems = Campuses.values.map((campus) {
    return DropdownMenuItem(
      value: campus,
      child: Text(
        campus.toString(),
      ),
    );
  }).toList();

  final courses = [
    'BICT 1',
    'BICT 2',
    'BICT 3',
    'BICT 4',
    'BICT 5',
  ];

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    buildings = dummyBuildings
        .where((building) => building.campus.name == selectedCampus)
        .toList();

    rooms = dummyBuildings.firstWhere((e) => e.name == selectedBuilding).rooms;

    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, keyboardSpace + 8),
      padding: const EdgeInsets.only(top: 16),
      child: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
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
