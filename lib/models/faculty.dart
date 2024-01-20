class Faculty {
  String? name;

  Faculty(this.name);

  Faculty.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> toJson() => {'name': name};
}
