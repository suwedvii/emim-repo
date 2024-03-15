import 'package:emim/models/course.dart';
import 'package:emim/models/program.dart';
import 'package:emim/screens/course_management/add_course_bottom_sheet_modal.dart';
import 'package:emim/screens/course_management/add_course_schedule_bottom_sheet_modal.dart';
import 'package:emim/widgets/profile/detail_item.dart';
import 'package:flutter/material.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({super.key, required this.course, required this.program});

  final Course course;
  final Program program;

  void _goToUpdateCourseDetails(BuildContext context, Course course) {
    Navigator.of(context).pop();
    showModalBottomSheet(
        // useSafeArea: true,
        elevation: 2,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => AddCourseBottomSheetModal(
              program: program,
              course: course,
            ));
  }

  void _goToAddScedule(BuildContext context, Course course) {
    Navigator.of(context).pop();
    showModalBottomSheet(
        useSafeArea: true,
        elevation: 2,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => AddCourseScheduleBottomSheetModal(
              course: course,
            ));
  }

  @override
  Widget build(BuildContext context) {
    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 16, vertical: 16 + keyboardspace),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Course Details',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
          const SizedBox(
            height: 4,
          ),
          DetailItem(description: course.courseName, title: 'Name'),
          const SizedBox(height: 8),
          DetailItem(description: course.courseCode, title: 'Code'),
          const SizedBox(height: 8),
          DetailItem(description: course.program, title: 'Program'),
          const SizedBox(height: 8),
          DetailItem(description: course.campus, title: 'Campus'),
          const SizedBox(height: 8),
          DetailItem(description: course.year, title: 'Year'),
          const SizedBox(height: 8),
          DetailItem(description: course.semester, title: 'Semester'),
          const SizedBox(height: 8),
          DetailItem(description: course.instructor, title: 'Instructor'),
          const SizedBox(height: 8),
          DetailItem(description: course.category, title: 'Category'),
          const SizedBox(
            height: 8,
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _goToUpdateCourseDetails(context, course);
                },
                icon: const Icon(Icons.edit_note_rounded),
                label: const Text('Edit'),
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _goToAddScedule(context, course);
                },
                icon: const Icon(Icons.alarm_add_outlined),
                label: const Text('Schedule'),
              ),
              const SizedBox(
                width: 8,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  _goToAddScedule(context, course);
                },
                icon: const Icon(Icons.delete_forever_sharp, color: Colors.red),
                label: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
