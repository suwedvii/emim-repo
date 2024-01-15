class Schedule {
  String? scheduleID;
  String course;
  String room;
  String bulding;
  String startTime;
  String endTime;
  String dayOfWeek;
  String? date;

  Schedule(
      {this.scheduleID = '',
      required this.course,
      required this.room,
      required this.bulding,
      required this.startTime,
      required this.endTime,
      required this.dayOfWeek,
      this.date = ''});
}
