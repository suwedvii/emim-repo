import 'dart:async';

import 'package:emim/models/course_schedule.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final schedulesRef = FirebaseDatabase.instance.ref().child('schedules');

class CourseSchedulesNotifier
    extends AutoDisposeAsyncNotifier<List<CourseSchedule>> {
  @override
  FutureOr<List<CourseSchedule>> build() async {
    await for (final event in schedulesRef.onValue) {
      final List<CourseSchedule> schedules = [];
      for (final scheduleSnapshot in event.snapshot.children) {
        schedules.add(CourseSchedule.fromSnapshot(scheduleSnapshot));
      }
      return schedules;
    }
    return [];
  }
}

final schedulesProvider = AsyncNotifierProvider.autoDispose<
    CourseSchedulesNotifier, List<CourseSchedule>>(CourseSchedulesNotifier.new);
