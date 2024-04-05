import 'package:emim/models/my_user.dart';
import 'package:emim/screens/course_management/program_management_screen.dart';
import 'package:flutter/material.dart';

class CourseManagementSwitchScreen extends StatelessWidget {
  const CourseManagementSwitchScreen({super.key, required this.user});

  final MyUser user;

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('Nothing here yet'),
    );

    if (user.role.toLowerCase() == 'admin') {
      content = ProgramManagementScreen(user: user);
    } else if (user.role.toLowerCase() == 'student') {}

    return content;
  }
}
