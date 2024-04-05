// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'package:emim/models/course.dart';

class Registration {
  String id;
  String academicYear;
  String studentId;
  String registeredProgram;
  String registeredYear;
  String registeredSemester;
  Future<List<Course>>? registeredCourses;
  String registeredAt;
  Registration({
    this.id = 'N/A',
    this.academicYear = 'N/A',
    this.studentId = 'N/A',
    this.registeredProgram = 'N/A',
    this.registeredYear = 'N/A',
    this.registeredSemester = 'N/A',
    this.registeredCourses,
    this.registeredAt = 'N/A',
  });

  Registration fromSnapshot(DataSnapshot snapshot) {
    return Registration(
      id: snapshot.child('id').value.toString(),
      academicYear: snapshot.child('academicYear').value.toString(),
      studentId: snapshot.child('studentId').value.toString(),
      registeredProgram: snapshot.child('registeredProgram').value.toString(),
      registeredYear: snapshot.child('registeredYear').value.toString(),
      registeredSemester: snapshot.child('registeredSemester').value.toString(),
      registeredAt: snapshot.child('registeredAt').value.toString(),
      registeredCourses:
          getRegisteredCourses(snapshot.child('registeredCourses')),
    );
  }

  Future<List<Course>> getRegisteredCourses(
    DataSnapshot registeredCoursesSnapshot,
  ) async {
    List<Course> registredCourses = [];
    final data = Course().getCourses();

    await data.then((courses) {
      for (final registeredCourse in registeredCoursesSnapshot.children) {
        final courseId = registeredCourse.child('code').value.toString();
        for (final course in courses) {
          if (course.code == courseId) {
            registredCourses.add(course);
          }
        }
      }
    });
    return registredCourses;
  }

  Future<void> registerCourses(List<Course> courses) async {
    final registeredCoursesRef = FirebaseDatabase.instance
        .ref()
        .child('registrations')
        .child(id)
        .child('registeredCourses');

    for (final course in courses) {
      await registeredCoursesRef
          .child(course.code)
          .set({'code': course.code, 'courseName': course.title});
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'academicYear': academicYear,
      'studentId': studentId,
      'registeredProgram': registeredProgram,
      'registeredYear': registeredYear,
      'registeredSemester': registeredSemester,
      'registeredAt': registeredAt,
    };
  }

  factory Registration.fromMap(Map<String, dynamic> map) {
    return Registration(
      id: map['id'] as String,
      academicYear: map['academicYear'] as String,
      studentId: map['studentId'] as String,
      registeredProgram: map['registeredProgram'] as String,
      registeredYear: map['registeredYear'] as String,
      registeredSemester: map['registeredSemester'] as String,
      registeredAt: map['registeredAt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Registration.fromJson(String source) =>
      Registration.fromMap(json.decode(source) as Map<String, dynamic>);
}
