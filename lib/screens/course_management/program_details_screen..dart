import 'package:emim/constants.dart';
import 'package:emim/models/course.dart';
import 'package:emim/models/program.dart';
import 'package:emim/providers/courses_provider.dart';
import 'package:emim/screens/course_management/add_course_bottom_sheet_modal.dart';
import 'package:emim/widgets/course_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class ProgramDetailsScreen extends ConsumerStatefulWidget {
  const ProgramDetailsScreen({super.key, required this.program});

  final Program program;

  @override
  ConsumerState<ProgramDetailsScreen> createState() =>
      _ProgramDetailsScreenState();
}

class _ProgramDetailsScreenState extends ConsumerState<ProgramDetailsScreen> {
  final form = GlobalKey<FormBuilderState>();
  bool isLoading = true;
  Program? program;
  List<String>? yearsOfStudy;
  List<String>? semesters;
  List<Course> courses = [];
  String? selectedYearOfStudy;
  String? selectedSemester;

  void _openAddCourseBottonSheetModal(BuildContext context) {
    showModalBottomSheet(
        useSafeArea: true,
        elevation: 2,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => AddCourseBottomSheetModal(program: widget.program));
  }

  @override
  void initState() {
    super.initState();
    program = widget.program;
    yearsOfStudy = _getYears();
  }

  @override
  Widget build(BuildContext context) {
    final value = ref.watch(coursesProvider);
    Widget content = value.when(
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
        error: (error, stackTrace) {
          Constants().showMessage(context, error.toString());
          return const Center(
            child: Text('Oops'),
          );
        },
        data: (data) {
          courses = data;
          yearsOfStudy = _getYears();
          List<Course> filteredCourses = _getFilteredCourses();

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            child: FormBuilder(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderDropdown(
                          decoration: Constants()
                              .dropDownInputDecoration(context, 'Year', null),
                          name: 'year',
                          items: Constants().getDropDownMenuItems(
                            _getYears(),
                          ),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              selectedYearOfStudy = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: FormBuilderDropdown(
                          validator: FormBuilderValidators.required(),
                          decoration: Constants().dropDownInputDecoration(
                              context, 'Semester', null),
                          name: 'semester',
                          items: Constants()
                              .getDropDownMenuItems(Constants().semesters),
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
                  const Divider(),
                  Expanded(
                    child:
                        CourseList(courses: filteredCourses, program: program!),
                  ),
                ],
              ),
            ),
          );
        });

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.program.programCode} Courses'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add Course'),
        onPressed: () {
          _openAddCourseBottonSheetModal(context);
        },
        icon: const Icon(Icons.playlist_add),
      ),
      body: content,
    );
  }

  List<String> _getYears() {
    List<String> years = [];
    final duration = int.parse(program!.duration[0]);
    for (var i = 0; i < duration; i++) {
      years.add((i + 1).toString());
    }
    print(years.length);
    return years;
  }

  List<Course> _getFilteredCourses() {
    List<Course> filteredCourses = [];

    print('Was called');

    if (courses.isNotEmpty) {
      final List<Course> foundCourses = [];
      for (final course in courses) {
        print(selectedYearOfStudy);
        if (selectedYearOfStudy == null) {
          print(program!.toMap());
          if (course.program == program!.programCode &&
              course.campus == program!.campus) {
            print(course.title);
            foundCourses.add(course);
            print(course);
          }
        } else {
          if (selectedSemester == null) {
            print(selectedYearOfStudy);
            if (course.campus == program!.campus &&
                course.program == program!.programCode &&
                course.year == selectedYearOfStudy) {
              foundCourses.add(course);
            }
          } else {
            if (course.campus == program!.campus &&
                course.program == program!.programCode &&
                course.year == selectedYearOfStudy &&
                course.semester == selectedSemester) {
              foundCourses.add(course);
            }
          }
        }
      }

      filteredCourses = foundCourses;
    }
    return filteredCourses;
  }

  @override
  void dispose() {
    super.dispose();
    form.currentState?.dispose();
  }
}
