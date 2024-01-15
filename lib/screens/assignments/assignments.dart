import 'dart:convert';

import 'package:emim/models/assignment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Assignments extends StatefulWidget {
  const Assignments({Key? key, required this.title}) : super(key: key);

  final String? title;

  @override
  State<StatefulWidget> createState() {
    return _AssignmentsState();
  }
}

class _AssignmentsState extends State<Assignments> {
  List<Assignment> assignements = [];

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  void _loadAssignments() async {
    final url =
        Uri.https('emimbacke-default-rtdb.firebaseio.com', 'assignments.json');

    final response = await http.get(url);

    final Map<String, dynamic> listData = json.decode(response.body);

    final List<Assignment> retrievedAssignments = [];

    for (final assignment in listData.entries) {
      retrievedAssignments.add(Assignment(
          assignmentId: assignment.key,
          assignmentTitle: assignment.value['assignmentTitle'],
          description: assignment.value['description'],
          deadline: assignment.value['deadline'],
          course: assignment.value['course']));
    }

    setState(() {
      assignements = retrievedAssignments;
      print(assignements.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      // Add your assignment-related UI components here
    );
  }
}
