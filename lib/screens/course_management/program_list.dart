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
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  programs[index].programCode,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Divider(
                  indent: 32,
                  endIndent: 32,
                  thickness: 2,
                  color: Theme.of(context).colorScheme.primary,
                  // height: 8,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  programs[index].programName,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Divider(
                  indent: 32,
                  endIndent: 32,
                  thickness: 2,
                  color: Theme.of(context).colorScheme.primary,
                  // height: 2,
                ),
                const SizedBox(
                  height: 8,
                ),
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
