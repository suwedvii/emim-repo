// import 'package:emim/models/course.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';

// class SemesterCoursesList extends StatefulWidget {
//   const SemesterCoursesList({super.key, required this.courses});

//   final List<Course>? courses;

//   @override
//   State<SemesterCoursesList> createState() => _SemesterCoursesListState();
// }

// class _SemesterCoursesListState extends State<SemesterCoursesList> {
//   final formkey = GlobalKey<FormBuilderState>();

//   @override
//   Widget build(BuildContext context) {
//     final semesterCourses = widget.courses;
//     // return semesterCourses == null || semesterCourses.isEmpty
//     //     ? const 
//     //     : Column(
//     //         children: [
//     //           FormBuilder(
//     //             key: formkey,
//     //             child: SizedBox(
//     //               height: 90 * (semesterCourses.length).toDouble(),
//     //               child: ListView.builder(
//     //                 itemCount: semesterCourses.length,
//     //                 // shrinkWrap: true,
//     //                 itemBuilder: ((context, index) {
//     //                   return FormBuilderSwitch(
//     //                     inactiveThumbColor: Theme.of(context).colorScheme.error,
//     //                     name: semesterCourses[index].code,
//     //                     title: Text(semesterCourses[index].title),
//     //                     subtitle: Text(semesterCourses[index].category),
//     //                   );
//     //                 }),
//     //               ),
//     //             ),
//     //           ),
//     //         ],
//     //       );
//   }

//   @override
//   void initState() {
//     if (mounted) {
//       super.initState();
//     }
//   }

//   @override
//   void dispose() {
//     if (mounted) {
//       super.dispose();
//       formkey.currentState?.dispose();
//     }
//   }
// }
