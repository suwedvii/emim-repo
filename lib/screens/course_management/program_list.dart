import 'package:emim/models/program.dart';
import 'package:emim/screens/course_management/program_details_screen..dart';
import 'package:emim/widgets/custom_card_widget.dart';
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
          child: CustomCardWidget(
            title: programs[index].programCode,
            subtitle: programs[index].programCode,
          )),
    );

    if (programs.isEmpty) {
      content = const Center(
        child: Text('No Programs added'),
      );
    }

    return content;
  }
}
