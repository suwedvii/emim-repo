import 'package:emim/constants.dart';
import 'package:emim/models/building.dart';
import 'package:emim/models/course.dart';
import 'package:emim/models/schedule.dart';
import 'package:emim/widgets/custom_drop_down_button.dart';
import 'package:emim/widgets/custom_time_holder.dart';
import 'package:emim/widgets/my_date_holder.dart';
import 'package:emim/widgets/profile/my_toggle_switch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

List<String> occurances = ['Once', 'Repeat'];

class AddCourseScheduleBottomSheetModal extends StatefulWidget {
  const AddCourseScheduleBottomSheetModal({super.key, required this.course});

  final Course course;

  @override
  State<AddCourseScheduleBottomSheetModal> createState() =>
      _AddCourseScheduleBottomSheetModalState();
}

class _AddCourseScheduleBottomSheetModalState
    extends State<AddCourseScheduleBottomSheetModal> {
  final form = GlobalKey<FormState>();
  Course? course;
  bool isLoading = true;
  late Future<List<Building>> buildings;
  List<String> rooms = [];
  String selectedOccurance = occurances[0];
  String selectedBuilding = '';
  String? selectedRoom;
  String? selectedDate;
  String selectedDayOfWeek = Constants().weekDays[0];
  String? startTime;
  String? endTime;
  @override
  void initState() {
    super.initState();
    buildings = _getBuildings();
    course = widget.course;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    // Widget content = isLoading

    return FutureBuilder(
        future: buildings,
        builder: (context, snapshot) {
          Widget content = const Center(
            child: Text('Nothing Here Yet'),
          );

          if (snapshot.connectionState == ConnectionState.waiting) {
            content = const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                text: 'Failed to retrieve data');
          }

          if (snapshot.hasData) {
            final foundBuildings = snapshot.data;

            rooms = foundBuildings!
                .firstWhere((building) =>
                    building.name.toLowerCase() ==
                    selectedBuilding.toLowerCase())
                .rooms!
                .map((room) => room.name)
                .toList();

            content = Container(
                padding: EdgeInsets.fromLTRB(12, 16, 12, keyboardSpace + 8),
                child: Form(
                  key: form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Add Schedule',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomDropdown(
                          items: foundBuildings
                              .map((building) => building.name)
                              .toList(),
                          value: foundBuildings[0].name,
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              selectedBuilding = value;
                            });
                          },
                          label: 'Building'),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomDropdown(
                          items: rooms,
                          value: rooms.isNotEmpty ? rooms[0] : 'No rooms',
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              selectedRoom = value;
                            });
                          },
                          label: 'Room'),
                      const SizedBox(
                        height: 8,
                      ),
                      MyToggleSwitch(
                          labels: occurances,
                          onToggled: (index, occurance) {
                            setState(() {
                              selectedOccurance = occurance;
                            });
                          }),
                      const SizedBox(
                        height: 8,
                      ),
                      if (selectedOccurance.toLowerCase() ==
                          occurances[1].toLowerCase())
                        Column(
                          children: [
                            MyToggleSwitch(
                                labels: Constants().weekDays,
                                onToggled: (index, day) {
                                  setState(() {
                                    selectedDayOfWeek = day;
                                  });
                                }),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      if (selectedOccurance.toLowerCase() ==
                          occurances[0].toLowerCase())
                        Column(
                          children: [
                            MyDateHolder(onDateSelected: (pickedDate) {
                              selectedDate = pickedDate;
                            }),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: CustomTimeHolder(
                                initialValue: '0:00 PM',
                                title: 'FROM',
                                onSelectTime: (time) {
                                  setState(() {
                                    startTime = time;
                                  });
                                },
                                hint: 'FROM'),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: CustomTimeHolder(
                                initialValue: '0:00 PM',
                                title: 'TO',
                                onSelectTime: (time) {
                                  setState(() {
                                    endTime = time;
                                  });
                                },
                                hint: 'TO'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: Theme.of(context).textTheme.bodyMedium!,
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (!isLoading) {
                                _addSchedule();
                              }
                            },
                            child: isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(),
                                  )
                                : const Text(
                                    'Submit',
                                  ),
                          )
                        ],
                      ),
                    ],
                  ),
                ));
          }

          return content;
        });
  }

  Future<List<Building>> _getBuildings() async {
    List<Building> foundBuildings = [];

    try {
      final buildingsSnapshot =
          await FirebaseDatabase.instance.ref().child('buildings').get();

      for (final building in buildingsSnapshot.children) {
        final retrievedBuilding = Building().fromSnapShot(building);
        if (retrievedBuilding.campus.toLowerCase() ==
            widget.course.campus.toLowerCase()) {
          foundBuildings.add(retrievedBuilding);
        }
      }
      setState(() {
        isLoading = false;
        selectedBuilding = foundBuildings[0].name;
        selectedRoom = foundBuildings[0].rooms?[0].name;
      });
    } on FirebaseException catch (error) {
      if (mounted) {
        Constants().showMessage(context, error.message.toString());
      }
    }
    return foundBuildings;
  }

  void _addSchedule() async {
    setState(() {
      isLoading = true;
    });

    if (form.currentState!.validate()) {
      form.currentState!.save();
      final schedulesRef = FirebaseDatabase.instance.ref().child('schedules');

      final scheduleID = schedulesRef.push().key;

      Map<String, dynamic> schedule = {};

      print(selectedOccurance.toLowerCase());

      if (selectedOccurance.toLowerCase() == occurances[0].toLowerCase()) {
        schedule = Schedule(
                scheduleID: scheduleID,
                course: course!.courseCode,
                bulding: selectedBuilding,
                room: selectedRoom,
                date: selectedDate,
                startTime: startTime,
                endTime: endTime)
            .toMap();
      } else {
        schedule = Schedule(
                scheduleID: scheduleID,
                course: course!.courseCode,
                bulding: selectedBuilding,
                room: selectedRoom,
                dayOfWeek: selectedDayOfWeek,
                startTime: startTime,
                endTime: endTime)
            .toMap();
      }
      print(scheduleID);

      if (scheduleID != null) {
        print('Add function called');
        print(schedule);
        await schedulesRef.child(scheduleID).set(schedule).whenComplete(() {
          // QuickAlert.show(context: context, type: QuickAlertType.success);
        }).onError((error, stackTrace) {
          print(stackTrace);
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    form.currentState?.dispose();
  }
}
