import 'dart:async';

import 'package:emim/models/course.dart';
import 'package:emim/models/my_user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final coursesRef = FirebaseDatabase.instance.ref().child('courses');

class CoursesNotifier extends AsyncNotifier<List<Course>> {
  @override
  FutureOr<List<Course>> build() async {
    await for (final event in coursesRef.onValue) {
      final List<Course> foundCourses = [];
      for (final courseSnapshot in event.snapshot.children) {
        foundCourses.add(Course.fromSnapshot(courseSnapshot));
      }

      return foundCourses;
    }
    return [];
  }

  List<Course> getSemesterCourses(MyUser user, String year, String semester) {
    print('called');
    final courses = state.value;
    final List<Course> foundCourses = [];
    if (courses != null) {
      for (final course in courses) {
        if (course.campus.toLowerCase() == user.userCampus &&
            course.program == user.userProgram &&
            course.year == year &&
            course.semester == semester) {
          foundCourses.add(course);
        }
      }
    }

    return foundCourses;
  }

  Future<void> removeCourse(Course course) async {
    await coursesRef.child(course.code).remove();
    ref.invalidateSelf();
  }

  Future<void> updateCourse(Course course) async {
    await coursesRef.child(course.code).update(course.toMap());
    ref.invalidateSelf();
  }
}

final coursesProvider =
    AsyncNotifierProvider<CoursesNotifier, List<Course>>(CoursesNotifier.new);
