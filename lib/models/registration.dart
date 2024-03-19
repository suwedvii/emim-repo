// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:emim/models/course.dart';
import 'package:firebase_database/firebase_database.dart';

class Registration {
  String id;
  String academicYear;
  String studentId;
  String registeredProgram;
  String registeredYear;
  String registeredSemester;
  List<Course>? registeredCourses;
  String registeredAt;
  Registration({
    required this.id,
    required this.academicYear,
    required this.studentId,
    required this.registeredProgram,
    required this.registeredYear,
    required this.registeredSemester,
    this.registeredCourses,
    required this.registeredAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'academicYear': academicYear,
      'studentId': studentId,
      'registeredProgram': registeredProgram,
      'registeredYear': registeredYear,
      'registeredSemester': registeredSemester,
      'registeredCourses': registeredCourses?.map((x) => x.toMap()).toList(),
      'registeredAt': registeredAt,
    };
  }

  Registration fromSnapshot(
      DataSnapshot snapshot, DataSnapshot coursesSnapshot) {
    return Registration(
      id: snapshot.child('id').value.toString(),
      academicYear: snapshot.child('academicYear').value.toString(),
      studentId: snapshot.child('studentId').value.toString(),
      registeredProgram: snapshot.child('registeredProgram').value.toString(),
      registeredYear: snapshot.child('registeredYear').value.toString(),
      registeredSemester: snapshot.child('registeredSemester').value.toString(),
      registeredAt: snapshot.child('registeredAt').value.toString(),
      registeredCourses: getRegisteredCourses(
          snapshot.child('registeredCourses'), coursesSnapshot),
    );
  }

  List<Course> getRegisteredCourses(
      DataSnapshot registeredCoursesSnapshot, DataSnapshot coursesSnapshot) {
    List<Course> foundCourses = [];

    for (final course in registeredCoursesSnapshot.children) {
      final courseId = course.key;
      final retrivedCourse =
          Course.fromSnapshot(coursesSnapshot.child(courseId!));
      foundCourses.add(retrivedCourse);
    }

    return foundCourses;
  }

  Future<void> registerCourses(List<Course> courses) async {
    final registeredCoursesRef = FirebaseDatabase.instance
        .ref()
        .child('registrations')
        .child(academicYear)
        .child(registeredProgram)
        .child(id)
        .child('registeredCourses');

    for (final course in courses) {
      await registeredCoursesRef.child(course.courseCode).set(
          {'courseCode': course.courseCode, 'courseName': course.courseName});
    }
  }

  factory Registration.fromMap(Map<String, dynamic> map) {
    return Registration(
      id: map['id'] as String,
      academicYear: map['academicYear'] as String,
      studentId: map['studentId'] as String,
      registeredProgram: map['registeredProgram'] as String,
      registeredYear: map['registeredYear'] as String,
      registeredSemester: map['registeredSemester'] as String,
      registeredCourses: map['registeredCourses'] != null
          ? List<Course>.from(
              (map['registeredCourses'] as List<int>).map<Course?>(
                (x) => Course.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      registeredAt: map['registeredAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Registration.fromJson(String source) =>
      Registration.fromMap(json.decode(source) as Map<String, dynamic>);
}
