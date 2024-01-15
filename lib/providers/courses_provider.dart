import 'package:emim/models/course.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseNotifier extends StateNotifier<List<Course>> {
  CourseNotifier() : super([]);

  void addCourse(Course course) {
    var courseExist = state.contains(course);

    if (courseExist) {
      state = state
          .where((e) =>
              e.courseCode != course.courseCode && e.campus != course.campus)
          .toList();
    } else {
      state = [...state, course];
    }
  }
}

final mealsProvider = StateNotifierProvider<CourseNotifier, List<Course>>(
  (ref) => CourseNotifier(),
);
