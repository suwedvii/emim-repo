// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:emim/models/course.dart';
import 'package:firebase_database/firebase_database.dart';

class CourseSchedule extends Course {
  String? scheduleID;
  String? room;
  String? bulding;
  String? startTime;
  String? endTime;
  String? dayOfWeek;
  String? date;

  CourseSchedule({
    this.scheduleID,
    this.room,
    this.bulding,
    this.startTime,
    this.endTime,
    this.dayOfWeek,
    this.date,
    required super.code,
    required super.campus,
    required super.title,
    required super.year,
    required super.semester,
    required super.program,
    required super.instructor,
    required super.category,
  });

  factory CourseSchedule.fromSnapshot(DataSnapshot snapshot) {
    return CourseSchedule(
        scheduleID: snapshot.child('scheduleID').value.toString(),
        bulding: snapshot.child('bulding').value.toString(),
        date: snapshot.child('date').value.toString(),
        room: snapshot.child('room').value.toString(),
        startTime: snapshot.child('startTime').value.toString(),
        endTime: snapshot.child('endTime').value.toString(),
        dayOfWeek: snapshot.child('dayOfWeek').value.toString(),
        code: snapshot.child('code').value.toString(),
        campus: snapshot.child('campus').value.toString(),
        title: snapshot.child('title').value.toString(),
        year: snapshot.child('year').value.toString(),
        semester: snapshot.child('semester').value.toString(),
        program: snapshot.child('program').value.toString(),
        instructor: snapshot.child('instructor').value.toString(),
        category: snapshot.child('category').value.toString());
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'scheduleID': scheduleID,
      'room': room,
      'bulding': bulding,
      'startTime': startTime,
      'endTime': endTime,
      'dayOfWeek': dayOfWeek,
      'date': date,
      'campus': campus,
      'program': program,
      'code': code,
      'courseName': title,
      'instructor': instructor,
      'year': year,
      'semester': semester,
      'category': category,
    };
  }

  factory CourseSchedule.fromMap(Map<String, dynamic> map) {
    return CourseSchedule(
      scheduleID:
          map['scheduleID'] != null ? map['scheduleID'] as String : null,
      room: map['room'] != null ? map['room'] as String : null,
      bulding: map['bulding'] != null ? map['bulding'] as String : null,
      startTime: map['startTime'] != null ? map['startTime'] as String : null,
      endTime: map['endTime'] != null ? map['endTime'] as String : null,
      dayOfWeek: map['dayOfWeek'] != null ? map['dayOfWeek'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      campus: map['campus'] as String,
      category: map['category'] as String,
      code: map['code'] as String,
      title: map['title'] as String,
      instructor: map['instructor'] as String,
      program: map['program'] as String,
      semester: map['date'] as String,
      year: map['date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseSchedule.fromJson(String source) =>
      CourseSchedule.fromMap(json.decode(source) as Map<String, dynamic>);
}
