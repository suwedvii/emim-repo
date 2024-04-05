import 'dart:core';

import 'package:emim/constants.dart';
import 'package:emim/models/course.dart';
import 'package:emim/models/my_user.dart';
import 'package:emim/models/program.dart';
import 'package:emim/models/registration.dart';
import 'package:emim/providers/semester_courses_provider.dart';
import 'package:emim/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class StudentRegistrationScreen extends ConsumerStatefulWidget {
  const StudentRegistrationScreen({super.key, required this.user});

  final MyUser user;

  @override
  ConsumerState<StudentRegistrationScreen> createState() =>
      _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState
    extends ConsumerState<StudentRegistrationScreen> {
  bool isLoading = true;
  final form = GlobalKey<FormBuilderState>();
  MyUser? user;
  Program? program;
  String selectedYear = '';
  String selectedSemester = '';
  List<String> years = [];

  @override
  void initState() {
    if (mounted) {
      super.initState();
      user = widget.user;
      _loadYears();
    }
  }

  @override
  void dispose() {
    if (mounted) {
      form.currentState?.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(years);

    final user = ref
        .watch(userProvider(FirebaseAuth.instance.currentUser!.uid))
        .valueOrNull;

    final semesterCourses = ref
        .watch(semesterCoursesProvider((
          semester: selectedSemester,
          user: user,
          year: selectedYear
        ) as SemesterCouserParameters))
        .valueOrNull;

    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;
    return isLoading
        ? const LinearProgressIndicator()
        : FormBuilder(
            key: form,
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8 + keyboardspace),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Register',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 8,
                  ),
                  if (years.isNotEmpty)
                    Row(
                      children: [
                        Expanded(
                          child: FormBuilderDropdown(
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                selectedYear = value[5];
                              });
                            },
                            validator: FormBuilderValidators.required(),
                            name: 'year',
                            items: Constants().getDropDownMenuItems(years),
                            decoration: Constants()
                                .dropDownInputDecoration(context, 'Year', null),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: FormBuilderDropdown(
                            validator: FormBuilderValidators.required(),
                            name: 'semester',
                            items: Constants()
                                .getDropDownMenuItems(Constants().semesters),
                            decoration: Constants().dropDownInputDecoration(
                                context, 'Semester', null),
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                selectedSemester = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: customBoxDecoration(context),
                    child: Column(
                      children: [
                        Text(
                          'Semester Courses',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Divider(),
                        if (semesterCourses == null || semesterCourses.isEmpty)
                          const SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                  textAlign: TextAlign.center,
                                  'No courses found yet, please make sure you have selected Year and semester'),
                            ),
                          ),
                        if (semesterCourses != null &&
                            semesterCourses.isNotEmpty)
                          Column(
                            children: [
                              SizedBox(
                                height:
                                    90 * (semesterCourses.length).toDouble(),
                                child: ListView.builder(
                                  itemCount: semesterCourses.length,
                                  // shrinkWrap: true,
                                  itemBuilder: ((context, index) {
                                    return FormBuilderSwitch(
                                      inactiveThumbColor:
                                          Theme.of(context).colorScheme.error,
                                      name: semesterCourses[index].code,
                                      title: Text(semesterCourses[index].title),
                                      subtitle:
                                          Text(semesterCourses[index].category),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        register(user!, selectedYear, selectedSemester,
                            semesterCourses!);
                      },
                      icon: const Icon(Icons.library_add),
                      label: const Text('Register'))
                ],
              ),
            ),
          );
  }

  BoxDecoration customBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: Theme.of(context).colorScheme.primary,
        style: BorderStyle.solid,
      ),
    );
  }

  Future<void> _loadYears() async {
    program = await Program().getProgramByCode(user!.userProgram);
    if (program != null) {
      List<String> foundYears = [];
      int _foundYears = int.parse(program!.duration[0]);
      for (var i = 0; i < _foundYears; i++) {
        foundYears.add('Year ${i + 1}');
      }
      setState(() {
        years = foundYears;
        isLoading = false;
      });
    }
  }

  void register(MyUser user, String year, String semester,
      List<Course> semesterCourses) async {
    if (form.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      form.currentState!.save();
      final data = form.currentState!.value;
      print(data);

      final dbref = FirebaseDatabase.instance.ref();

      final academicYearRef =
          await dbref.child('activeYear').child('academicYear').get();
      String academicYear = '';
      for (final child in academicYearRef.children) {
        academicYear = child.value.toString();
      }

      final id = dbref.child('registrations').push().key;

      if (id == null) {
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        final registration = Registration(
          id: id,
          studentId: user.userId,
          academicYear: academicYear,
          registeredProgram: user.userProgram,
          registeredYear: year,
          registeredSemester: semester,
          registeredAt: DateTime.now().toString(),
        );

        if (mounted) {
          await dbref
              .child('registrations')
              .child(id)
              .set(registration.toMap())
              .whenComplete(() async {
            await dbref
                .child('registrations')
                .child(id)
                .child('registeredCourses')
                .set(
                  _getCourses(data, semesterCourses),
                )
                .whenComplete(() {
              Navigator.of(context).pop();
            });
          });
        }
      }
    }
  }

  Map _getCourses(Map<String, dynamic> data, List<Course> semesterCourses) {
    final courses = {};
    for (final map in data.entries) {
      if (map.key != 'year' && map.key != 'semester' && map.value != null) {
        final course =
            semesterCourses.firstWhere((element) => element.code == map.key);
        courses.putIfAbsent(map.key, () => course.title);
        print(map);
      }
    }

    return courses;
  }
}
