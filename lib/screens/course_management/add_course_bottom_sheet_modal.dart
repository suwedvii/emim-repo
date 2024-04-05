import 'package:emim/constants.dart';
import 'package:emim/models/course.dart';
import 'package:emim/models/my_user.dart';
import 'package:emim/models/program.dart';
import 'package:emim/providers/courses_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddCourseBottomSheetModal extends ConsumerStatefulWidget {
  const AddCourseBottomSheetModal(
      {super.key, required this.program, this.course});

  final Program program;
  final Course? course;

  @override
  ConsumerState<AddCourseBottomSheetModal> createState() =>
      _AddCourseBottomSheetModalState();
}

class _AddCourseBottomSheetModalState
    extends ConsumerState<AddCourseBottomSheetModal> {
  final form = GlobalKey<FormBuilderState>();
  Course? course;
  Program? program;
  bool isLoading = true;
  String? error;
  List<String> programs = [];
  List<String> instructors = [];
  List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    _getPrograms();
    _getInstructors();
    course = widget.course;
    program = widget.program;
  }

  @override
  void dispose() {
    if (mounted) {
      super.dispose();
      form.currentState?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(coursesProvider).valueOrNull;

    for (var element in courses!) {
      print(element.title);
    }

    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(14, 16, 14, 8 + keyboardSpace),
      child: FormBuilder(
        key: form,
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${course != null ? 'UPDATE' : 'ADD'} COURSE',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(
              height: 8,
            ),
            const SizedBox(
              height: 8,
            ),
            FormBuilderTextField(
              name: 'title',
              decoration:
                  Constants().dropDownInputDecoration(context, 'Title', null),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.min(8)
              ]),
            ),
            const SizedBox(
              height: 8,
            ),
            FormBuilderDropdown(
              name: 'program',
              items: Constants().getDropDownMenuItems(programs),
              decoration:
                  Constants().dropDownInputDecoration(context, 'Program', null),
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(
              height: 8,
            ),
            FormBuilderDropdown(
              name: 'instructor',
              items: Constants().getDropDownMenuItems(instructors),
              decoration: Constants()
                  .dropDownInputDecoration(context, 'Instructor', null),
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: FormBuilderDropdown(
                    name: 'year',
                    items: Constants().getDropDownMenuItems(Constants().years),
                    validator: FormBuilderValidators.required(),
                    decoration: Constants()
                        .dropDownInputDecoration(context, 'Year', null),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: FormBuilderDropdown(
                    name: 'semester',
                    items:
                        Constants().getDropDownMenuItems(Constants().semesters),
                    validator: FormBuilderValidators.required(),
                    decoration: Constants()
                        .dropDownInputDecoration(context, 'Semester', null),
                  ),
                ),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: FormBuilderDropdown(
                    name: 'category',
                    items: Constants()
                        .getDropDownMenuItems(Constants().courseCategories),
                    validator: FormBuilderValidators.required(),
                    decoration: Constants()
                        .dropDownInputDecoration(context, 'Category', null),
                  ),
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
                  onPressed: isLoading
                      ? null
                      :
                      // _addCourse,
                      () {
                          _addCourse(courses, ref);
                        },
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
        )),
      ),
    );
  }

  void _addCourse(List<Course> existingCources, WidgetRef ref) async {
    final coursesRef = FirebaseDatabase.instance.ref().child('courses');
    setState(() {
      isLoading = true;
    });
    if (form.currentState!.validate()) {
      form.currentState!.save();

      final newCourse = Course.fromMap(
          {'code': '', 'campus': program!.campus, ...form.currentState!.value});

      for (final course in existingCources) {
        if (course.campus == newCourse.campus &&
            course.program == newCourse.program &&
            course.title == newCourse.title) {
          setState(() {
            error = 'Course already exist';
            isLoading = false;
            return;
          });
        } else {
          newCourse.code = _getCode(newCourse, existingCources);

          await coursesRef
              .child(newCourse.code)
              .set(newCourse.toMap())
              .whenComplete(() {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        }
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

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

String _getCode(Course newCourse, List<Course> existingCourses) {
  int numOfCourses = 0;

  for (final course in existingCourses) {
    if (course.campus == newCourse.campus &&
        course.program == newCourse.program &&
        course.year == newCourse.year &&
        course.semester == newCourse.semester) {
      numOfCourses += 1;
    }
  }
  return '${newCourse.program}${newCourse.year}${newCourse.semester}${(numOfCourses + 1).toString().padLeft(2, '0')}';
}
