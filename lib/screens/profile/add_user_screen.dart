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
  List<MyUser>? users;

  String firstname = '';
  String userId = '';
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
  String role = '';
  late DatabaseReference userRef;

  void _addUser() {
    Map<String, dynamic>? user;

    final usersRef = FirebaseDatabase.instance.ref().child('users');

    final uuid = usersRef.push().key;

    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      formKey.currentState!.save();

      final password = '$firstname${Random().nextInt(100).toString()}';

      if (role == 'student') {
        user = MyUser(
                uuid: uuid!,
                userId: _getUserId(),
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
                creationDate: DateTime.now().toString(),
                accountStatus: 'created',
                modeOfEntry: selectModeOfEntry,
                modeOfStudy: selectModeOfStudy)
            .toMap();
      } else {
        user = MyUser(
                uuid: uuid!,
                userId: _getUserId(),
                username: '${firstname[0]}.$surname',
                emailAddress: email,
                password: password,
                firstName: firstname,
                lastName: surname,
                otherNames: othernames,
                role: role,
                gender: selectedGender,
                creationDate: DateTime.now().toString(),
                accountStatus: 'created')
            .toMap();
      }

      userRef.child(uuid).set(user).whenComplete(() {
        isLoading = false;
        Navigator.of(context).pop();
      });
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
    _selectGender(0);
    _selectCampus(0);
    _selectModeOfEntry(0);
    _selectModeOfStudy(0);
    _selectUSerType(0);
    userRef = FirebaseDatabase.instance.ref().child('users');
    users = MyUser().getUsers(userRef);
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
                  if (role == 'student')
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
                    onPressed: !isLoading ? _addUser : null,
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
    String userRole = '';
    if (index == 0) {
      userRole = 'admin';
    } else if (index == 1) {
      userRole = 'student';
    } else if (index == 2) {
      userRole = 'instructor';
    } else if (index == 3) {
      userRole = 'accountant';
    }
    setState(() {
      role = userRole;
    });
  }

  void _selectGender(int index) {
    String gender = '';
    if (index == 0) {
      gender = 'male';
    } else if (index == 1) {
      gender = 'female';
    } else if (index == 2) {
      gender = 'other';
    }
    setState(() {
      selectedGender = gender;
    });
  }

  void _selectCampus(int index) {
    String campus = '';
    if (index == 0) {
      campus = 'blantyre';
    } else if (index == 1) {
      campus = 'lilongwe';
    }
    setState(() {
      selectedCampus = campus;
    });
  }

  void _selectModeOfEntry(int index) {
    String modeOfEntry = '';
    if (index == 0) {
      modeOfEntry = 'generic';
    } else if (index == 1) {
      modeOfEntry = 'mature';
    }
    setState(() {
      selectModeOfEntry = modeOfEntry;
    });
  }

  void _selectModeOfStudy(int index) {
    String modeOfStudy = '';
    if (index == 0) {
      modeOfStudy = 'week days';
    } else if (index == 1) {
      modeOfStudy = 'weekends';
    }
    setState(() {
      selectModeOfStudy = modeOfStudy;
    });
  }

  String _getUserNumber() {
    int numberOfStudents = 0;
    int numberOfStaffs = 0;

    for (final user in users!) {
      if (user.role == 'student') {
        if (user.userProgram == selectedProgram &&
            user.userCampus == selectedCampus &&
            user.modeOfEntry == selectModeOfEntry &&
            user.userCohort == selectedCohort) {
          numberOfStudents += 1;
        }
      } else {
        numberOfStaffs += 1;
      }
    }

    numberOfStaffs += 1;
    numberOfStudents += 1;
    return role == 'student'
        ? '${numberOfStudents < 10 ? '0$numberOfStudents' : numberOfStudents}'
        : numberOfStaffs.toString();
  }

  String _getUserId() {
    final campus = selectedCampus.toLowerCase() == 'blantyre' ? 'BT' : 'LL';
    final modeOfEntry =
        selectModeOfEntry.toLowerCase() == 'generic' ? 'G' : 'M';
    final cohort = selectedCohort == ''
        ? 'C1'
        : '${selectedCohort[0]}${selectedCohort.substring(7)}';
    final userNumber = _getUserNumber();
    final year = DateTime.now().year.toString().substring(2);

    if (role == 'student') {
      userId =
          '$selectedProgram/$campus/$modeOfEntry/$cohort/$userNumber/$year';
    } else {
      userId = 'MSG${userNumber.padLeft(6, '0')}';
    }

    return userId;
  }
}
