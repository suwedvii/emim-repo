// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Evant {
  String id;
  String title;
  String category;
  String date;
  String startTime;
  String endTime;
  Evant({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'category': category,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory Evant.fromMap(Map<String, dynamic> map) {
    return Evant(
      id: map['id'] as String,
      title: map['title'] as String,
      category: map['category'] as String,
      date: map['date'] as String,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Evant.fromJson(String source) =>
      Evant.fromMap(json.decode(source) as Map<String, dynamic>);
}
