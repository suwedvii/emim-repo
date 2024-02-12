// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

List<String> durations = [
  '3 Months',
  '6 Months',
  '1 Year',
  '2 Years',
  '3 Years',
  '4 Years',
  '5 Years'
];

class Program {
  String programId;
  String programCode;
  String programName;
  String description;
  String faculty;
  String duration;
  int semesters;
  Program(
      {this.programId = 'N/A',
      this.programCode = 'N/A',
      this.programName = 'N/A',
      this.description = 'N/A',
      this.faculty = 'N/A',
      this.duration = 'N/A',
      this.semesters = 0});

  Program copyWith({
    String? programId,
    String? programCode,
    String? programName,
    String? description,
    String? faculty,
    String? duration,
    int? semesters,
  }) {
    return Program(
      programId: programId ?? this.programId,
      programCode: programCode ?? this.programCode,
      programName: programName ?? this.programName,
      description: description ?? this.description,
      faculty: faculty ?? this.faculty,
      duration: duration ?? this.duration,
      semesters: semesters ?? this.semesters,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'programId': programId,
      'programCode': programCode,
      'programName': programName,
      'description': description,
      'faculty': faculty,
      'duration': duration,
      'semesters': semesters,
    };
  }

  factory Program.fromMap(Map<String, dynamic> map) {
    return Program(
      programId: map['programId'] as String,
      programCode: map['programCode'] as String,
      programName: map['programName'] as String,
      description: map['description'] as String,
      faculty: map['faculty'] as String,
      duration: map['duration'] as String,
      semesters: map['semesters'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Program.fromJson(String source) =>
      Program.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Program(programId: $programId, programCode: $programCode, programName: $programName, description: $description, faculty: $faculty, duration: $duration, semesters: $semesters)';
  }

  @override
  bool operator ==(covariant Program other) {
    if (identical(this, other)) return true;

    return other.programId == programId &&
        other.programCode == programCode &&
        other.programName == programName &&
        other.description == description &&
        other.faculty == faculty &&
        other.duration == duration &&
        other.semesters == semesters;
  }

  @override
  int get hashCode {
    return programId.hashCode ^
        programCode.hashCode ^
        programName.hashCode ^
        description.hashCode ^
        faculty.hashCode ^
        duration.hashCode ^
        semesters.hashCode;
  }
}
