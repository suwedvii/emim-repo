// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class Course {
  String code;
  String campus;
  String title;
  String year;
  String semester;
  String program;
  String instructor;
  String category;

  Course({
    this.code = 'N/A',
    this.campus = 'N/A',
    this.title = 'N/A',
    this.year = 'N/A',
    this.semester = 'N/A',
    this.program = 'N/A',
    this.instructor = 'N/A',
    this.category = 'N/A',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'campus': campus,
      'title': title,
      'year': year,
      'semester': semester,
      'program': program,
      'instructor': instructor,
      'category': category,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      code: map['code'] as String,
      campus: map['campus'] as String,
      title: map['title'] as String,
      year: map['year'] as String,
      semester: map['semester'] as String,
      program: map['program'] as String,
      instructor: map['instructor'] as String,
      category: map['category'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromSnapshot(DataSnapshot courseSnapshot) {
    return Course(
      code: courseSnapshot.child('code').value.toString(),
      campus: courseSnapshot.child('campus').value.toString(),
      title: courseSnapshot.child('title').value.toString(),
      year: courseSnapshot.child('year').value.toString(),
      semester: courseSnapshot.child('semester').value.toString(),
      program: courseSnapshot.child('program').value.toString(),
      instructor: courseSnapshot.child('instructor').value.toString(),
      category: courseSnapshot.child('category').value.toString(),
    );
  }

  factory Course.fromJson(String source) =>
      Course.fromMap(json.decode(source) as Map<String, dynamic>);

  Future<List<Course>> getCourses() async {
    final coursesRef = FirebaseDatabase.instance.ref().child('courses');

    await for (final event in coursesRef.onValue) {
      List<Course> foundCourses = [];
      for (final snaposhot in event.snapshot.children) {
        final retrievedCourse = Course.fromSnapshot(snaposhot);
        foundCourses.add(retrievedCourse);
      }
      return foundCourses;
    }
    return [];
  }
}
