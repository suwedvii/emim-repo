class User {
  String id;
  String role;
  String username;
  String email;
  String password;
  String cohort;
  String program;
  String campus;

  User(this.role, this.username, this.password, this.email,
      {this.id = '', this.cohort = '', this.program = '', this.campus = ''});
}
