import 'package:emim/models/course.dart';
import 'package:emim/models/program.dart';
import 'package:emim/screens/course_management/course_details.dart';
import 'package:flutter/material.dart';

class CourseList extends StatelessWidget {
  const CourseList({super.key, required this.courses, required this.program});

  final List<Course> courses;
  final Program program;

  void _goToCourseDetails(
      BuildContext context, Course course, Program program) {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => CourseDetails(
              course: course,
              program: program,
            ));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: courses.length,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () {
          _goToCourseDetails(context, courses[index], program);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Text(
                  courses[index].code,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Text(
                  courses[index].title,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const Divider(),
                Text(
                  courses[index].instructor,
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ],
            ),
          ),
        ),
      ),
    );

    if (courses.isEmpty) {
      content = const Center(
        child: Text('No Programs added'),
      );
    }

    return content;
  }
}
