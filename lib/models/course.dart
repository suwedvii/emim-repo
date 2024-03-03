// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class Course {
  String courseCode;
  String campus;
  String courseName;
  String year;
  String semester;
  String program;
  String instructor;
  String category;

  Course({
    this.courseCode = 'N/A',
    this.campus = 'N/A',
    this.courseName = 'N/A',
    this.year = 'N/A',
    this.semester = 'N/A',
    this.program = 'N/A',
    this.instructor = 'N/A',
    this.category = 'N/A',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'courseCode': courseCode,
      'campus': campus,
      'courseName': courseName,
      'year': year,
      'semester': semester,
      'program': program,
      'instructor': instructor,
      'category': category,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      courseCode: map['courseCode'] as String,
      campus: map['campus'] as String,
      courseName: map['courseName'] as String,
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
      courseCode: courseSnapshot.child('courseCode').value.toString(),
      campus: courseSnapshot.child('campus').value.toString(),
      courseName: courseSnapshot.child('courseName').value.toString(),
      year: courseSnapshot.child('year').value.toString(),
      semester: courseSnapshot.child('semester').value.toString(),
      program: courseSnapshot.child('program').value.toString(),
      instructor: courseSnapshot.child('instructor').value.toString(),
      category: courseSnapshot.child('category').value.toString(),
    );
  }

  factory Course.fromJson(String source) =>
      Course.fromMap(json.decode(source) as Map<String, dynamic>);
}
