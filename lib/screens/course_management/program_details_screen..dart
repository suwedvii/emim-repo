import 'package:emim/constants.dart';
import 'package:emim/models/course.dart';
import 'package:emim/models/program.dart';
import 'package:emim/screens/course_management/add_course_bottom_sheet_modal.dart';
import 'package:emim/widgets/course_list.dart';
import 'package:emim/widgets/profile/my_toggle_switch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ProgramDetailsScreen extends StatefulWidget {
  const ProgramDetailsScreen({super.key, required this.program});

  final Program program;

  @override
  State<ProgramDetailsScreen> createState() => _ProgramDetailsScreenState();
}

class _ProgramDetailsScreenState extends State<ProgramDetailsScreen> {
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
    _getCourses();
    yearsOfStudy = _getYears();
    selectedYearOfStudy = yearsOfStudy![0];
    semesters = _getSemesters();
    selectedSemester = semesters![0];
  }

  @override
  Widget build(BuildContext context) {
    final semesterCourses = _getSemesterCourses();
    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyToggleSwitch(
              minHeight: 30,
              labels: yearsOfStudy!,
              onToggled: (index, year) {
                setState(() {
                  selectedYearOfStudy = year;
                });
              }),
          const SizedBox(
            height: 8,
          ),
          MyToggleSwitch(
              minHeight: 30,
              labels: semesters!,
              onToggled: (index, semester) {
                setState(() {
                  selectedSemester = semester;
                });
              }),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: CourseList(courses: semesterCourses, program: program!),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.program.programCode} Courses'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          onPressed: () {
            _openAddCourseBottonSheetModal(context);
          },
          icon: const Icon(Icons.playlist_add),
        ),
      ),
      body: content,
    );
  }

  List<String> _getYears() {
    List<String> years = [];
    final duration = int.parse(program!.duration[0]);
    for (var i = 0; i < duration; i++) {
      years.add('Year ${i + 1}');
    }
    print(years.length);
    return years;
  }

  List<String> _getSemesters() {
    List<String> semesters = [];
    for (var semester in Constants().semesters) {
      semesters.add('Semester ${semester == 'One' ? '1' : '2'}');
    }
    return semesters;
  }

  void _getCourses() async {
    List<Course> foundCourses = [];
    try {
      final coursesSnapshot =
          await FirebaseDatabase.instance.ref().child('courses').get();
      for (final course in coursesSnapshot.children) {
        final retrievedCourse = Course.fromSnapshot(course);
        if (retrievedCourse.campus == program!.campus &&
            retrievedCourse.program == program!.programCode) {
          foundCourses.add(retrievedCourse);
        }
      }
      setState(() {
        courses = foundCourses;
        print(courses.length);
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      return;
    }
  }

  List<Course> _getSemesterCourses() {
    List<Course> foundCourses = [];
    final year = selectedYearOfStudy![selectedYearOfStudy!.length - 1];
    final semester =
        selectedSemester![selectedSemester!.length - 1] == '1' ? 'One' : 'Two';

    for (final course in courses) {
      if (course.semester == semester && course.year == year) {
        foundCourses.add(course);
      }
    }

    return foundCourses;
  }
}
