import 'package:emim/models/course.dart';
import 'package:emim/models/program.dart';
import 'package:emim/screens/course_management/add_course_bottom_sheet_modal.dart';
import 'package:emim/widgets/profile/detail_item.dart';
import 'package:flutter/material.dart';

class CourseDetails extends StatelessWidget {
  const CourseDetails({super.key, required this.course, required this.program});

  final Course course;
  final Program program;

  void _goToUpdateCourseDetails(BuildContext context, Course course) {
    Navigator.of(context).pop();
    showModalBottomSheet(
        useSafeArea: true,
        elevation: 2,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => AddCourseBottomSheetModal(
              program: program,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Course Details',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  _goToUpdateCourseDetails(context, course);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Text(
                        'Edit',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      const Icon(Icons.edit_note)
                    ],
                  ),
                ),
              ),
            ],
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
        ],
      ),
    );
  }
}
