import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AttendaceRecord {
  String? attendanceId;
  String? course;
  AttendaceRecord({
    this.attendanceId,
    this.course,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'attendanceId': attendanceId,
      'course': course,
    };
  }

  factory AttendaceRecord.fromMap(Map<String, dynamic> map) {
    return AttendaceRecord(
      attendanceId:
          map['attendanceId'] != null ? map['attendanceId'] as String : null,
      course: map['course'] != null ? map['course'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendaceRecord.fromJson(String source) =>
      AttendaceRecord.fromMap(json.decode(source) as Map<String, dynamic>);
}
