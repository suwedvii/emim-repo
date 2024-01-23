import 'dart:convert';
import 'dart:math';

import 'package:emim/models/user.dart';
import 'package:emim/widgets/custom_drop_down_button.dart';
import 'package:emim/widgets/my_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool isLoading = true;
  List<String> programs = [];
  List<String> cohorts = [];
  final formKey = GlobalKey<FormState>();
  String firstname = '';
  String surname = '';
  String email = '';
  String othernames = '';
  String selectedCampus = campuses[0];
  String selectedGender = genders[0];
  String selectedProgram = '';
  String selectedCohort = '';

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
        isLoading = true;
      });

      formKey.currentState!.save();

      final password = '$firstname${Random().nextInt(100).toString()}';

      final user = MyUser(
              userId: 'userId',
              username: '${firstname[0]}.$surname',
              emailAddress: email,
              password: password,
              firstName: firstname,
              lastName: surname,
              otherNames: othernames,
              role: role,
              gender: selectedGender)
          .toJson();

      print('cohort is $selectedCohort');

      if (role == 'student') {
        try {
          final response = await http.post(url,
              headers: {'Content-Type': 'application/json'}, body: user
              // json.encode(user
              //     // {
              //     //   'password': password,
              //     //   'studentId': '',
              //     //   'userCampus': selectedCampus,
              //     //   'userProgram': selectedProgram,
              //     //   'userCohort': selectedCohort,
              //     //   'gender': selectedGender,
              //     //   'username': '$firstname.$surname',
              //     //   'emailAddress': email,
              //     //   'role': widget.userType,
              //     // },
              //     ),
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
                  height: 12,
                ),
                if (widget.userType == 'student')
                  Row(
                    children: [
                      Expanded(
                        child: CustomDropdown(
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
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: CustomDropdown(
                            items: campuses,
                            value: selectedCampus,
                            onChanged: (String? value) {
                              if (value == null) return;
                              setState(() {
                                selectedCampus = value;
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
                            value: cohorts.isEmpty ? 'No cohorts' : cohorts[0],
                            onChanged: (String? vaule) {
                              setState(() {
                                selectedCohort = vaule!;
                              });
                            },
                            label: 'Cohort'),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: CustomDropdown(
                            items: genders,
                            value: selectedGender,
                            onChanged: (String? value) {
                              if (value == null) return;
                              setState(() {
                                selectedGender = value;
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
    );
  }
}
