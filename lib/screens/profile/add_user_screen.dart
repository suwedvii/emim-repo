import 'dart:convert';
import 'dart:math';

import 'package:emim/models/bulding.dart';
import 'package:emim/models/program.dart';
import 'package:emim/models/student.dart';
import 'package:emim/widgets/custom_drop_down_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

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
  final formKey = GlobalKey<FormState>();
  String firstname = '';
  String surname = '';
  String email = '';
  String password = '';
  Campuses selectedCampus = Campuses.blantyre;
  String? program;
  String? cohort;
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
    if (formKey.currentState!.validate()) {
      setState(() {
        addingUser = true;
      });

      formKey.currentState!.save();

      final password = firstname + Random().nextInt(100).toString();

      try {
        if (role == 'student') {
          final url = Uri.https(
              'emimbacke-default-rtdb.firebaseio.com', 'students.json');
          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: json.encode(Student(
              studentId: Random().nextInt(10000).toString(),
              userCampus: selectedCampus.name,
              userProgram: program!,
              userCohort: cohort!,
              password: password,
            )
                // {
                //   'role': user.role,
                //   'username': user.username,
                //   'email': user.email,
                //   'password': user.password,
                //   'program': user.program,
                //   'cohort': user.cohort,
                //   'campus': user.campus
                // },
                ),
          );

          widget.loadUsers();

          // Navigator.of(ctx).pop();

          print(response.body);
        }
      } catch (e) {
        print(e);
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
      for (final program in listData.entries) {
        retrievedPrograms.add(Program(
          description: program.value['description'],
          duration: program.value['duration'],
          faculty: program.value['faculty'],
          programCode: program.value['programCode'],
          programId: program.key,
          programName: program.value['programName'],
        ));
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
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  // controller: firstnameController,
                  validator: (fname) {
                    return _validator(fname);
                  },
                  decoration: const InputDecoration(
                    label: Text('First Name:'),
                  ),
                  keyboardType: TextInputType.name,
                  onSaved: (value) {
                    firstname = value!;
                    print(firstname);
                  },
                ),
                TextFormField(
                  // controller: surnameController,
                  validator: (sname) {
                    return _validator(sname);
                  },
                  decoration: const InputDecoration(
                    label: Text('Surname:'),
                  ),
                  keyboardType: TextInputType.name,
                  onSaved: (value) {
                    surname = value!;
                    print(surname);
                  },
                ),
                TextFormField(
                  // controller: emailController,
                  validator: (enteredEmail) {
                    return _validator(enteredEmail);
                  },
                  decoration: const InputDecoration(
                    label: Text('Email Address:'),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {
                    email = value!;
                    print(email);
                  },
                ),
                TextFormField(
                  // controller: emailController,
                  validator: (enteredPassword) {
                    return _validator(enteredPassword);
                  },
                  decoration: const InputDecoration(
                    label: Text('Password:'),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {
                    password = value!;
                    print(password);
                  },
                ),
                if (widget.userType == 'student')
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          value: selectedCampus,
                          items: Campuses.values
                              .map(
                                (campus) => DropdownMenuItem(
                                  value: campus,
                                  child: Text(
                                    campus.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (campus) {
                            if (campus == null) {
                              return;
                            }
                            setState(() {
                              selectedCampus = campus;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: selectedCampus,
                          items: Campuses.values
                              .map(
                                (campus) => DropdownMenuItem(
                                  value: campus,
                                  child: Text(
                                    campus.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (campus) {
                            if (campus == null) {
                              return;
                            }
                            setState(
                              () {
                                selectedCampus = campus;
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 8,
                ),
                CustomDropdown(
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
                ElevatedButton(
                  onPressed: () {
                    _addUser(context, widget.userType.toLowerCase());
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
