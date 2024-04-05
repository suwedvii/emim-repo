import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Schedule {
  String? scheduleID;
  String? course;
  String? room;
  String? bulding;
  String? startTime;
  String? endTime;
  String? dayOfWeek;
  String? date;

  Schedule({
    this.scheduleID,
    this.course,
    this.room,
    this.bulding,
    this.startTime,
    this.endTime,
    this.dayOfWeek,
    this.date,
  });

  Schedule copyWith({
    String? scheduleID,
    String? course,
    String? room,
    String? bulding,
    String? startTime,
    String? endTime,
    String? dayOfWeek,
    String? date,
  }) {
    return Schedule(
      scheduleID: scheduleID ?? this.scheduleID,
      course: course ?? this.course,
      room: room ?? this.room,
      bulding: bulding ?? this.bulding,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'scheduleID': scheduleID,
      'course': course,
      'room': room,
      'bulding': bulding,
      'startTime': startTime,
      'endTime': endTime,
      'dayOfWeek': dayOfWeek,
      'date': date,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      scheduleID:
          map['scheduleID'] != null ? map['scheduleID'] as String : null,
      course: map['course'] != null ? map['course'] as String : null,
      room: map['room'] != null ? map['room'] as String : null,
      bulding: map['bulding'] != null ? map['bulding'] as String : null,
      startTime: map['startTime'] != null ? map['startTime'] as String : null,
      endTime: map['endTime'] != null ? map['endTime'] as String : null,
      dayOfWeek: map['dayOfWeek'] != null ? map['dayOfWeek'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Schedule.fromSnashot(DataSnapshot snapshot) {
    return Schedule(
      scheduleID: snapshot.child('scheduleID').value.toString(),
      bulding: snapshot.child('bulding').value.toString(),
      room: snapshot.child('room').value.toString(),
      course: snapshot.child('course').value.toString(),
      date: snapshot.child('date').value.toString(),
      dayOfWeek: snapshot.child('dayOfWeek').value.toString(),
      startTime: snapshot.child('startTime').value.toString(),
      endTime: snapshot.child('endTime').value.toString(),
    );
  }

  factory Schedule.fromJson(String source) =>
      Schedule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Schedule(scheduleID: $scheduleID, course: $course, room: $room, bulding: $bulding, startTime: $startTime, endTime: $endTime, dayOfWeek: $dayOfWeek, date: $date)';
  }

  @override
  bool operator ==(covariant Schedule other) {
    if (identical(this, other)) return true;

    return other.scheduleID == scheduleID &&
        other.course == course &&
        other.room == room &&
        other.bulding == bulding &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.dayOfWeek == dayOfWeek &&
        other.date == date;
  }

  @override
  int get hashCode {
    return scheduleID.hashCode ^
        course.hashCode ^
        room.hashCode ^
        bulding.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        dayOfWeek.hashCode ^
        date.hashCode;
  }
}
