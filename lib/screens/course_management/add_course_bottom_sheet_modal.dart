import 'package:emim/constants.dart';
import 'package:emim/models/course.dart';
import 'package:emim/models/my_user.dart';
import 'package:emim/models/program.dart';
import 'package:emim/widgets/custom_drop_down_button.dart';
import 'package:emim/widgets/my_text_form_field.dart';
import 'package:emim/widgets/profile/my_toggle_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddCourseBottomSheetModal extends StatefulWidget {
  const AddCourseBottomSheetModal(
      {super.key, required this.program, this.course});

  final Program program;
  final Course? course;

  @override
  State<AddCourseBottomSheetModal> createState() =>
      _AddCourseBottomSheetModalState();
}

class _AddCourseBottomSheetModalState extends State<AddCourseBottomSheetModal> {
  final form = GlobalKey<FormState>();
  Course? course;
  bool isLoading = true;
  String? error;
  String semester = '';
  String selectedCategory = Constants().courseCategories[0];
  String selectedCampus = Constants().campuses[0];
  String selectedYear = Constants().years[0];
  String selectedSemester = Constants().semesters[0];
  String selectedProgram = '';
  String selectedInstructor = '';
  String enteredCoourseName = '';
  List<String> programs = [];
  List<String> instructors = [];
  List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    _getPrograms();
    _getInstructors();
    _getCourses();
    course = widget.course;
  }

  @override
  void dispose() {
    super.dispose();
    form.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(14, 16, 14, 8 + keyboardSpace),
      child: Form(
        key: form,
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${course != null ? 'UPDATE' : 'ADD'} COURSE',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 8,
                  ),
                  MyTextFormFiled(
                      initialValue: course?.courseName,
                      onValidate: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.trim().length < 5) {
                          return 'Please enter a valid course name';
                        }
                        return null;
                      },
                      onValueSaved: (value) {
                        enteredCoourseName = value!;
                      },
                      label: 'Course Name'),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (!isLoading)
                    CustomDropdown(
                      items: programs,
                      value: programs.isEmpty ? 'No Programs' : programs[0],
                      label: 'Program',
                      onChanged: (String? value) {
                        if (value == null) return;
                        setState(() {
                          selectedProgram = value;
                        });
                      },
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (!isLoading)
                    CustomDropdown(
                      items: instructors,
                      label: 'Instructor',
                      value:
                          instructors.isEmpty ? 'No Programs' : instructors[0],
                      onChanged: (String? value) {
                        if (value == null) return;
                        setState(() {
                          selectedInstructor = value;
                        });
                      },
                    ),
                  const SizedBox(
                    height: 8,
                  ),
                  MyToggleSwitch(
                      title: 'Course Category',
                      labels: Constants().courseCategories,
                      onToggled: (index, item) {
                        selectedCategory = item;
                      }),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(children: [
                    Expanded(
                      child: MyToggleSwitch(
                          maxWidth: maxWidth,
                          title: 'Campus',
                          labels: Constants().campuses,
                          onToggled: (index, campus) {
                            selectedCampus = campus;
                          }),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: MyToggleSwitch(
                          maxWidth: maxWidth,
                          title: 'Semester',
                          labels: Constants().semesters,
                          onToggled: (index, semester) {
                            selectedSemester = semester;
                          }),
                    )
                  ]),
                  const SizedBox(
                    height: 8,
                  ),
                  MyToggleSwitch(
                      title: 'Year of Study',
                      labels: Constants().years,
                      onToggled: (index, year) {
                        selectedYear = year;
                      }),
                  const SizedBox(
                    height: 8,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 8,
                  ),
                  if (error != null)
                    Text(
                      error!,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  Row(
                    children: [
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            form.currentState!.reset();
                          },
                          child: const Text('Reset')),
                      ElevatedButton(
                        onPressed: isLoading ? null : _addCourse,
                        child: isLoading
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(),
                              )
                            : const Text('Add Course'),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _addCourse() async {
    setState(() {
      isLoading = true;
    });
    if (form.currentState!.validate()) {
      form.currentState!.save();

      try {
        final coursesRef = FirebaseDatabase.instance.ref().child('courses');

        if (_getCourseCode() != null) {
          final courseCode = _getCourseCode();
          await coursesRef
              .child(courseCode!)
              .set(Course(
                courseName: enteredCoourseName,
                courseCode: courseCode,
                program: selectedProgram,
                campus: selectedCampus,
                category: selectedCategory,
                instructor: selectedInstructor,
                semester: selectedSemester,
                year: selectedYear,
              ).toMap())
              .whenComplete(() {
            setState(() {
              isLoading = false;
              Navigator.of(context).pop();
            });
          });
        } else {
          setState(() {
            error = 'Course already exist!!';
            isLoading = false;
          });
        }
      } on FirebaseException catch (e) {
        setState(() {
          isLoading = false;
          error = e.message.toString();
          return;
        });
      }
    }
  }

  void _getPrograms() async {
    List<String> foundprograms = [];

    try {
      final programsSnapshot =
          await FirebaseDatabase.instance.ref().child('programs').get();

      for (final program in programsSnapshot.children) {
        final retrievedProgram = Program.fromSnapshot(program);
        foundprograms.add(retrievedProgram.programCode);
      }

      setState(() {
        programs = foundprograms;
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        error = e.message.toString();
        return;
      });
    }
  }

  void _getInstructors() async {
    List<String> foundInstructors = [];

    try {
      final usersSnapshot =
          await FirebaseDatabase.instance.ref().child('users').get();

      for (final user in usersSnapshot.children) {
        final retrievedUser = MyUser().fromSnapshot(user);
        if (retrievedUser.role.toLowerCase() == 'instructor') {
          foundInstructors.add(MyUser().getFullName(retrievedUser));
        }
      }
      setState(() {
        instructors = foundInstructors;
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        error = e.message.toString();
        return;
      });
    }
  }

  String? _getCourseCode() {
    final year = selectedYear;
    final semester = selectedSemester.toLowerCase() == 'one' ? '1' : '2';
    int numberOfCourses = 0;

    for (final course in courses) {
      if (course.courseName == enteredCoourseName &&
          course.campus == selectedCampus &&
          course.program == selectedProgram) {
        return null;
      } else if (course.campus == selectedCampus &&
          course.year == selectedYear &&
          course.semester == selectedSemester &&
          course.program == selectedProgram &&
          course.category == selectedCategory) {
        numberOfCourses += 1;
      }
    }
    return '$selectedProgram$year$semester${(numberOfCourses + 1).toString().padLeft(2, '0')}';
  }

  void _getCourses() async {
    List<Course> foundCourses = [];
    try {
      final cousresSnapshot =
          await FirebaseDatabase.instance.ref().child('courses').get();
      for (final course in cousresSnapshot.children) {
        foundCourses.add(Course.fromSnapshot(course));
      }
      setState(() {
        courses = foundCourses;
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
        error = e.message.toString();
        return;
      });
    }
  }
}
