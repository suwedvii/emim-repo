import 'dart:convert';
import 'dart:math';

import 'package:emim/models/bulding.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? error;

  final formKey = GlobalKey<FormState>();
  String firstname = '';
  String surname = '';
  String email = '';
  Campuses selectedCampus = Campuses.blantyre;
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

  void _addUser() async {
    final url =
        Uri.https('emimbacke-default-rtdb.firebaseio.com', 'users.json');

    if (formKey.currentState!.validate()) {
      setState(() {
        addingUser = true;
      });

      formKey.currentState!.save();

      final password = '${firstname[0]}.$surname${Random().nextInt(100000)}';

      try {
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
      } on FirebaseAuthException catch (error) {
        addingUser = false;
        Navigator.of(context).pop<String>(
          error.message,
        );

        return;
      }
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
            {
              'role': widget.userType,
              'username': '$firstname.$surname',
              'email': email,
              'password': password,
              'program': '',
              'cohort': '',
              'campus': ''
            },
          ),
        );

        widget.loadUsers();

        Navigator.of(context).pop();

        print(response.body);
      } on FirebaseAuthException catch (error) {
        Navigator.of(context).pop<String>(
          error.message,
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
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
                ElevatedButton(
                  onPressed: _addUser,
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
