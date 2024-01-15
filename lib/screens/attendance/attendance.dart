import 'package:flutter/material.dart';

class Attendance extends StatefulWidget {
  const Attendance({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _AttendanceState();
  }
}

class _AttendanceState extends State<Attendance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // Add your attendance-related UI components here
    );
  }
}
