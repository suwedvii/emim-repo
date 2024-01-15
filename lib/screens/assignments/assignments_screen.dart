import 'dart:convert';

import 'package:emim/models/assignment.dart';
import 'package:emim/screens/assignments/add_assignment_screen.dart';
import 'package:emim/screens/assignments/assignment_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AssignMentsScreen extends ConsumerStatefulWidget {
  const AssignMentsScreen({super.key, this.appBarTitle});

  final String? appBarTitle;

  @override
  ConsumerState<AssignMentsScreen> createState() {
    return _AssignMentsScreenState();
  }
}

class _AssignMentsScreenState extends ConsumerState<AssignMentsScreen> {
  bool isLoadingAssignments = true;

  List<Assignment> assignements = [];

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  void _openAddAssignmentScreen() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddAssignmentScreen(selectedAssignment: null),
      ),
    );

    if (result == null) return;

    setState(() {
      assignements.add(result);
      print(result);
    });
  }

  void _loadAssignments() async {
    final url =
        Uri.https('emimbacke-default-rtdb.firebaseio.com', 'assignments.json');

    final response = await http.get(url);

    if (response.body.isEmpty) {
      // Handle the case where the response body is empty or null.
      return;
    }

    try {
      final dynamic decodedData = json.decode(response.body);

      if (decodedData == null || decodedData is! Map<String, dynamic>) {
        // Handle the case where the decoded data is not a Map<String, dynamic>.
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No data found'),
          ),
        );
        return;
      }

      final Map<String, dynamic> listData = decodedData;

      final List<Assignment> retrievedAssignments = [];

      for (final assignment in listData.entries) {
        retrievedAssignments.add(
          Assignment(
            assignmentId: assignment.key,
            assignmentTitle: assignment.value['assignmentTitle'],
            description: assignment.value['description'],
            deadline: assignment.value['deadline'],
            course: assignment.value['course'],
          ),
        );
      }

      setState(() {
        assignements = retrievedAssignments;
        isLoadingAssignments = false;
      });
    } catch (error) {
      // Handle the case where decoding fails.
      print('Error decoding assignments: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddAssignmentScreen();
        },
        child: const Icon(Icons.assignment_add),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: isLoadingAssignments
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : AssignmentList(assignments: assignements),
      ),
    );

    if (widget.appBarTitle == null) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.appBarTitle}'),
      ),
    );
  }
}
