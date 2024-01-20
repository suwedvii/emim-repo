import 'dart:core';

class Cohort {
  late String? name;

  Cohort(this.name);

  Cohort.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJson() => {'name': name};
}
