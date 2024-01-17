import 'dart:convert';
import 'dart:math';

import 'package:emim/models/bulding.dart';
import 'package:emim/models/program.dart';
import 'package:emim/models/user.dart';
import 'package:emim/widgets/custom_drop_down_button.dart';
import 'package:emim/widgets/my_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final auth = FirebaseAuth.instance;

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
  List<Program> programs = [];
  List<String> cohorts = [];
  final formKey = GlobalKey<FormState>();
  String? firstname = '';
  String surname = '';
  String email = '';
  Campuses selectedCampus = Campuses.blantyre;
  String campus = '';
  Gender selectedGender = Gender.male;
  String gender = '';
  String program = '';
  String cohort = '';
  var addingUser = false;

  String? _validator(String? value) {
    if (value == null ||
        value == '' ||
        value.trim().length < 5 ||
        value.trim().length >= 50) {
      return 'Please make sure to enter characters between 5 and 50';
    }
    return null;
  }

  void _addUser(BuildContext ctx, String role) async {
    final url =
        Uri.https('emimbacke-default-rtdb.firebaseio.com', 'users.json');

    if (formKey.currentState!.validate()) {
      setState(() {
        addingUser = true;
      });

      formKey.currentState!.save();

      final password = '$firstname${Random().nextInt(100).toString()}';

      if (role == 'student') {
        try {
          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(
              {
                'password': password,
                'studentId': '',
                'userCampus': selectedCampus.name,
                'userProgram': program,
                'userCohort': cohort,
                'gender': selectedGender.name,
                'username': '$firstname.$surname',
                'emailAddress': email,
                'role': widget.userType,
              },
            ),
          );

          widget.loadUsers();

          Navigator.of(ctx).pop();

          print(response.body);
        } on FirebaseException catch (e) {
          print(e);
        }
      }
    }
  }

  void _loadCohorts() async {
    final List<String> retrievedCohorts = [];
    final url =
        Uri.https('emimbacke-default-rtdb.firebaseio.com', 'cohorts.json');

    try {
      final response = await http.get(url);
      final Map<String, dynamic> listData = json.decode(response.body);

      // Check if the widget is still mounted before updating the state
      if (mounted) {
        for (final cohort in listData.entries) {
          retrievedCohorts.add(cohort.value['name']);
        }
        setState(() {
          cohorts = retrievedCohorts;
        });
      }
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  void _loadPrograms() async {
    final List<Program> retrievedPrograms = [];
    final url =
        Uri.https('emimbacke-default-rtdb.firebaseio.com', 'programs.json');

    try {
      final response = await http.get(url);
      final Map<String, dynamic> listData = json.decode(response.body);

      // Check if the widget is still mounted before updating the state
      if (mounted) {
        for (final program in listData.entries) {
          retrievedPrograms.add(Program(
            description: program.value['description'],
            duration: program.value['duration'],
            faculty: program.value['faculty'],
            programCode: program.value['programCode'],
            programId: program.key,
            programName: program.value['programName'],
          ));
        }
        setState(() {
          programs = retrievedPrograms;
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
    _loadPrograms();
    _loadCohorts();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Form(
      key: formKey,
      child: SizedBox(
        width: double.infinity,
        child: Container(
          margin: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Add ${widget.userType}',
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
                      firstname = value;
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
                      firstname = value;
                    },
                    label: 'Surname'),
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
                      firstname = value;
                    },
                    label: 'Email'),
                const SizedBox(
                  height: 12,
                ),
                if (widget.userType == 'student')
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown(
                            items: programs.map((e) => e.programCode).toList(),
                            value: programs.isNotEmpty
                                ? programs[0].programCode
                                : 'No programs',
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                program = value;
                              });
                            },
                            label: 'Program'),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: CustomDropdown(
                            items: Campuses.values
                                .map((e) => e.name.toUpperCase())
                                .toList(),
                            value: selectedCampus.name.toUpperCase(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                campus = value;
                              });
                            },
                            label: 'Campus'),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 12,
                ),
                if (widget.userType == 'student')
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown(
                            items: cohorts,
                            value:
                                cohorts.isNotEmpty ? cohorts[0] : 'No cohorts',
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                cohort = value;
                              });
                            },
                            label: 'Cohort'),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: CustomDropdown(
                            items: Gender.values
                                .map((e) => e.name.toUpperCase())
                                .toList(),
                            value: selectedGender.name.toUpperCase(),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                gender = value;
                              });
                            },
                            label: 'Gender'),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    _addUser(
                      context,
                      widget.userType.toLowerCase(),
                    );
                  },
                  child: addingUser
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
    );
  }
}
