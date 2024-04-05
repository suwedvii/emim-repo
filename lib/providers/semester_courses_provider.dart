import 'package:emim/models/course.dart';
import 'package:emim/models/my_user.dart';
import 'package:emim/providers/courses_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef SemesterCouserParameters = ({
  MyUser user,
  String year,
  String semester
});

final semesterCoursesProvider = FutureProvider.autoDispose
    .family<List<Course>, SemesterCouserParameters>((ref, args) async {
  final courses = ref.watch(coursesProvider).valueOrNull;
  final List<Course> foundCourses = [];
  if (courses != null) {
    for (final course in courses) {
      if (course.campus.toLowerCase() == args.user.userCampus &&
          course.program == args.user.userProgram &&
          course.year == args.year &&
          course.semester == args.semester) {
        foundCourses.add(course);
      }
    }
  }

  return foundCourses;
});
