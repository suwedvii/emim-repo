import 'package:emim/constants.dart';
import 'package:emim/models/building.dart';
import 'package:emim/models/schedule.dart';
import 'package:emim/widgets/custom_drop_down_button.dart';
import 'package:emim/widgets/my_date_holder.dart';
import 'package:emim/widgets/profile/my_toggle_switch.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

List<String> occurance = ['Once', 'Repeat'];

class AddScheduleButtomModal extends StatefulWidget {
  const AddScheduleButtomModal({
    super.key,
  });

  @override
  State<AddScheduleButtomModal> createState() => _AddScheduleButtomModalState();
}

class _AddScheduleButtomModalState extends State<AddScheduleButtomModal> {
  bool isLoading = true;
  final List<Schedule> schedules = [];
  List<String>? programs;
  late DatabaseReference buildingsRef;
  List<String> scheduleLabels = Constants().classSchedules;

  Campuses campus = Campuses.blantyre;

  String? selectedProgram;
  String selectedSchedule = Constants().classSchedules[0];
  String selectedCampus = Constants().campuses[0];
  String selectedBuilding = 'Chikanda';
  String selectedOccurance = occurance[0];
  String selectedroom = '';
  String? selectedDate;
  String? course;
  String? weekDay = Constants().weekDays[0];
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
      padding: EdgeInsets.fromLTRB(12, 16, 12, keyboardSpace + 8),
      child: Form(
          child: SingleChildScrollView(
              child: Column(
        children: [
          Text(
            ('ADD CLASS SCHEDULE').toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          CustomDropdown(
              items: programs!,
              value: programs![0],
              onChanged: (value) {
                setState(() {
                  selectedProgram = value;
                });
              },
              label: 'Program'),
          MyToggleSwitch(
              labels: scheduleLabels,
              onToggled: (index, schedule) {
                setState(() {
                  selectedSchedule = schedule;
                });
              }),
          const SizedBox(
            height: 8,
          ),
          MyToggleSwitch(
              labels: Constants().campuses,
              onToggled: (index, campus) {
                setState(() {
                  selectedCampus = campus;
                });
              }),
          const SizedBox(
            height: 8,
          ),
          CustomDropdown(
              items: buildings.map((building) => building.name).toList(),
              value: buildings.isEmpty ? 'Select Campus' : buildings[0].name,
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
          MyToggleSwitch(
              labels: occurance,
              title: 'Occurance',
              onToggled: (index, occurance) {
                setState(() {
                  selectedOccurance = occurance;
                });
              }),
          const SizedBox(
            height: 8,
          ),
          if (selectedOccurance == occurance[0])
            MyDateHolder(onDateSelected: _getSelectedDate),
          const SizedBox(
            height: 8,
          ),
          if (selectedOccurance != occurance[0])
            MyToggleSwitch(
                labels: Constants().weekDays,
                onToggled: (index, day) {
                  weekDay = day;
                }),
        ],
      ))),
    );
  }

  void _getSelectedDate(String date) {
    setState(() {
      selectedDate = date;
      print(selectedDate);
    });
  }
}
