import 'package:emim/models/program.dart';
import 'package:emim/screens/course_management/program_details_screen..dart';
import 'package:flutter/material.dart';

class ProgramList extends StatelessWidget {
  const ProgramList({super.key, required this.programs});

  final List<Program> programs;

  void _goToProgramDetails(BuildContext ctx, Program program) {
    Navigator.of(ctx).push(MaterialPageRoute(
        builder: (context) => ProgramDetailsScreen(program: program)));
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: programs.length,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () {
          _goToProgramDetails(context, programs[index]);
        },
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Text(
                  programs[index].programCode,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Text(
                  programs[index].programName,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const Divider(),
                Text(
                  programs[index].faculty,
                  style: Theme.of(context).textTheme.labelMedium,
                )
              ],
            ),
          ),
        ),
      ),
    );

    if (programs.isEmpty) {
      content = const Center(
        child: Text('No Programs added'),
      );
    }

    return content;
  }
}
