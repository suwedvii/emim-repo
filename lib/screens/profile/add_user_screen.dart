import 'dart:convert';
import 'dart:math';

import 'package:emim/models/course.dart';
import 'package:emim/models/my_user.dart';
import 'package:emim/widgets/custom_drop_down_button.dart';
import 'package:emim/widgets/my_text_form_field.dart';
import 'package:emim/widgets/profile/my_toggle_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final auth = FirebaseAuth.instance;

List<String> campuses = ['Select Campus', 'Blantyre', 'Lilonge'];
List<String> genders = ['Select Gender', 'Male', 'Female', 'Other'];

class AddUserScreen extends ConsumerStatefulWidget {
  const AddUserScreen(
      {super.key, required this.userType, required this.loadUsers});

  final String userType;

  final Function() loadUsers;

  @override
  ConsumerState<AddUserScreen> createState() {
    return _AddUserScreenState();
  }
}

class _AddUserScreenState extends ConsumerState<AddUserScreen> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = true;
  List<String> programs = [];
  List<String> cohorts = [];

  String firstname = '';
  String surname = '';
  String email = '';
  String othernames = '';
  String selectedCampus = '';
  String selectedGender = '';
  String selectModeOfEntry = '';
  String selectModeOfStudy = '';
  String selectedProgram = '';
  String selectedYearOfStudy = '';
  String selectedCohort = '';
  int initialSelectedUserIndex = 0;
  String? userType;
  late DatabaseReference userRef;

  void _addUser(BuildContext ctx, String role) async {
    Map<String, dynamic>? user;

    final usersRef = FirebaseDatabase.instance.ref().child('users');

    final uuid = usersRef.push().key;

    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      formKey.currentState!.save();

      final password = '$firstname${Random().nextInt(100).toString()}';

      if (userType == 'student') {
        user = MyUser(
          uuid: uuid!,
          userId: 'userId',
          username: '${firstname[0]}.$surname',
          emailAddress: email,
          password: password,
          firstName: firstname,
          lastName: surname,
          otherNames: othernames,
          role: role,
          gender: selectedGender,
          userCohort: selectedCohort,
          userCampus: selectedCampus,
          userProgram: selectedProgram,
          yearOdStudy: selectedYearOfStudy,
        ).toMap();
      } else {
        user = MyUser(
                uuid: uuid!,
                userId: 'userId',
                username: '${firstname[0]}.$surname',
                emailAddress: email,
                password: password,
                firstName: firstname,
                lastName: surname,
                otherNames: othernames,
                role: role,
                gender: selectedGender)
            .toMap();
      }
    }
  }

  void _loadCohorts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final List<String> retrievedCohorts = ['Select Cohort'];
      final url =
          Uri.https('emimbacke-default-rtdb.firebaseio.com', 'cohorts.json');
      final response = await http.get(url);
      final Map<String, dynamic> listData = json.decode(response.body);

      // Check if the widget is still mounted before updating the state
      if (mounted) {
        for (final cohort in listData.entries) {
          retrievedCohorts.add(cohort.value['name']);
        }
        setState(() {
          cohorts = retrievedCohorts;
          isLoading = false;
        });
      }
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  void _loadPrograms() async {
    setState(() {
      isLoading = true;
    });
    try {
      final List<String> retrievedPrograms = ['Select Program'];
      final url =
          Uri.https('emimbacke-default-rtdb.firebaseio.com', 'programs.json');
      final response = await http.get(url);
      final Map<String, dynamic> listData = json.decode(response.body);

      // Check if the widget is still mounted before updating the state
      if (mounted) {
        for (final program in listData.entries) {
          retrievedPrograms.add(program.value['programCode']);
        }
        setState(() {
          programs = retrievedPrograms;
          isLoading = false;
        });
      }
    } on Exception catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadCohorts();
    _loadPrograms();
    userRef = FirebaseDatabase.instance.ref().child('users');
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: SizedBox(
          width: double.infinity,
          child: Container(
            margin: EdgeInsets.fromLTRB(12, 16, 16, keyboardSpace + 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Add User',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextFormFiled(
                      onValidate: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter a valid name';
                        }
                        return null;
                      },
                      onValueSaved: (value) {
                        firstname = value!;
                      },
                      label: 'First Name'),
                  const SizedBox(
                    height: 8,
                  ),
                  MyTextFormFiled(
                      onValidate: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter a valid name';
                        }
                        return null;
                      },
                      onValueSaved: (value) {
                        surname = value!;
                      },
                      label: 'Surname'),
                  const SizedBox(
                    height: 8,
                  ),
                  MyTextFormFiled(
                      onValidate: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter a valid name';
                        }
                        return null;
                      },
                      onValueSaved: (value) {
                        othernames = value!;
                      },
                      label: 'Other Names'),
                  const SizedBox(
                    height: 8,
                  ),
                  MyTextFormFiled(
                      onValidate: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.trim().contains('@')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                      onValueSaved: (value) {
                        email = value!;
                      },
                      label: 'Email'),
                  const SizedBox(
                    height: 8,
                  ),
                  MyToggleSwitch(
                      title: 'Gender',
                      labels: const [
                        'Male',
                        'Female',
                        'Other',
                      ],
                      totalSwitches: 3,
                      onToggled: (index) {
                        _selectGender(index);
                        print(selectedGender);
                      }),
                  const SizedBox(
                    height: 8,
                  ),
                  MyToggleSwitch(
                      title: 'Role',
                      labels: const [
                        'Admin',
                        'Student',
                        'Instructor',
                        'Accountant'
                      ],
                      totalSwitches: 4,
                      onToggled: (index) {
                        _selectUSerType(index);
                      }),
                  const SizedBox(
                    height: 8,
                  ),
                  if (userType == 'student')
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MyToggleSwitch(
                          title: 'Campus',
                          labels: const [
                            'Blantyre',
                            'Lilongwe',
                          ],
                          totalSwitches: 2,
                          onToggled: _selectCampus,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            MyToggleSwitch(
                              title: 'Mode of Entry',
                              minWidth: 86,
                              labels: const [
                                'Generic',
                                'Mature',
                              ],
                              totalSwitches: 2,
                              onToggled: _selectModeOfEntry,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            MyToggleSwitch(
                              title: 'Mode of Study',
                              minWidth: 86,
                              labels: const [
                                'Weekdays',
                                'Weekends',
                              ],
                              totalSwitches: 2,
                              onToggled: _selectModeOfStudy,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        CustomDropdown(
                            items: programs,
                            value:
                                programs.isEmpty ? 'No Programs' : programs[0],
                            onChanged: (String? value) {
                              if (value == null) return;
                              setState(() {
                                selectedProgram = value;
                              });
                            },
                            label: 'Program'),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomDropdown(
                                  items: years,
                                  value: years[0],
                                  onChanged: (String? value) {
                                    if (value == null) return;
                                    setState(() {
                                      selectedYearOfStudy = value;
                                    });
                                  },
                                  label: 'Year of Study'),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Expanded(
                              child: CustomDropdown(
                                  items: cohorts,
                                  value: cohorts.isEmpty
                                      ? 'No cohorts'
                                      : cohorts[0],
                                  onChanged: (String? vaule) {
                                    setState(() {
                                      selectedCohort = vaule!;
                                    });
                                  },
                                  label: 'Cohort'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ElevatedButton(
                    onPressed: () {
                      !isLoading
                          ? _addUser(
                              context,
                              widget.userType.toLowerCase(),
                            )
                          : null;
                    },
                    child: isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Add User'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectUSerType(int index) {
    setState(() {
      if (index == 0) {
        userType = 'admin';
      } else if (index == 1) {
        userType = 'student';
      } else if (index == 2) {
        userType = 'instructor';
      } else if (index == 3) {
        userType = 'accountant';
      }
    });
  }

  void _selectGender(int index) {
    setState(() {
      if (index == 0) {
        selectedGender = 'male';
      } else if (index == 1) {
        selectedGender = 'female';
      } else if (index == 2) {
        selectedGender = 'other';
      }
    });
  }

  void _selectCampus(int index) {
    setState(() {
      if (index == 0) {
        selectedCampus = 'blantyre';
      } else if (index == 1) {
        selectedCampus = 'lilongwe';
      }
    });
  }

  void _selectModeOfEntry(int index) {
    setState(() {
      if (index == 0) {
        selectModeOfEntry = 'generic';
      } else if (index == 1) {
        selectModeOfEntry = 'mature';
      }
    });
  }

  void _selectModeOfStudy(int index) {
    setState(() {
      if (index == 0) {
        selectModeOfStudy = 'week days';
      } else if (index == 1) {
        selectModeOfStudy = 'weekends';
      }
    });
  }
}
