import 'package:emim/models/program.dart';
import 'package:flutter/material.dart';

class ProgramList extends StatelessWidget {
  const ProgramList({super.key, required this.programs});

  final List<Program> programs;

  @override
  Widget build(BuildContext context) {
    Widget content = ListView.builder(
      itemCount: programs.length,
      itemBuilder: (ctx, index) => GestureDetector(
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
                const Divider(height: 1),
                Text(
                  programs[index].programName,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 5),
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
