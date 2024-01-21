import 'package:emim/models/assignment.dart';
import 'package:emim/screens/assignments/add_assignment_screen.dart';
import 'package:flutter/material.dart';

class AssignmentList extends StatelessWidget {
  const AssignmentList({super.key, required this.assignments});

  final List<Assignment> assignments;

  void _goToAssignmentDetails(BuildContext context, Assignment? assignment) {
    Navigator.of(context).push<Assignment>(
      MaterialPageRoute(
        builder: (ctx) => AddAssignmentScreen(selectedAssignment: assignment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: assignments.length,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () {
          _goToAssignmentDetails(context, assignments[index]);
        },
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assignments[index].assignmentTitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Divider(),
                Row(
                  children: [
                    Text(
                      'Course:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      assignments[index].course,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      'Deadline:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      assignments[index].deadline,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
