import 'package:emim/models/program.dart';
import 'package:emim/screens/course_management/add_course_bottom_sheet_modal.dart';
import 'package:flutter/material.dart';

class ProgramDetailsScreen extends StatelessWidget {
  const ProgramDetailsScreen({super.key, required this.program});

  final Program program;

  void _openAddCourseBottonSheetModal(BuildContext context) {
    showModalBottomSheet(
        useSafeArea: true,
        elevation: 2,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => AddCourseBottomSheetModal(program: program));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${program.programCode} Courses'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          onPressed: () {
            _openAddCourseBottonSheetModal(context);
          },
          icon: const Icon(Icons.playlist_add),
        ),
      ),
    );
  }
}
