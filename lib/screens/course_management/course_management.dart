import 'package:flutter/material.dart';

class CourseManagement extends StatefulWidget {
  const CourseManagement({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<CourseManagement> createState() {
    return _CourseManagementState();
  }
}

class _CourseManagementState extends State<CourseManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Courses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Add your course-related UI components here
            // Example: Course list, enrollment options, etc.
          ],
        ),
      ),
    );
  }
}
