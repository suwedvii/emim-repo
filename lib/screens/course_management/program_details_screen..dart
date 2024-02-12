import 'package:flutter/material.dart';
import 'package:emim/models/program.dart';

class ProgramDetailsScreen extends StatelessWidget {
  const ProgramDetailsScreen({super.key, required this.program});

  final Program program;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${program.programCode} Courses'),
      ),
    );
  }
}
