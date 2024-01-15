List<String> weekDays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

List<String> campuses = ['Blantyre', 'Lilongwe'];

List<String> courseCategories = ['Core', 'Selective'];

List<String> semesters = ['One', 'Two'];

List<String> years = ['One', 'Two', 'Three', 'Four', 'Five'];

class Course {
  String courseCode;
  String campus;
  String courseName;
  int year;
  int semester;
  String program;
  String instructor;
  String scheduleWeekDay;
  String scheduleTime;
  String category;
  int capacity;

  Course({
    this.courseCode = "",
    this.campus = "",
    this.courseName = "",
    this.year = 0,
    this.semester = 0,
    this.program = "",
    this.instructor = "",
    this.scheduleWeekDay = "",
    this.scheduleTime = "",
    this.category = "",
    this.capacity = 0,
  });
}
