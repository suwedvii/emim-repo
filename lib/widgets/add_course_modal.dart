import 'package:emim/models/course.dart';
import 'package:emim/providers/programs_provider.dart';
import 'package:emim/widgets/drop_down_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddCourseModal extends ConsumerStatefulWidget {
  const AddCourseModal({super.key});

  @override
  ConsumerState<AddCourseModal> createState() {
    return _AddCourseModalState();
  }
}

class _AddCourseModalState extends ConsumerState<AddCourseModal> {
  String yearOfStudy = years[0];
  String semesterOfStudy = semesters[0];
  String courseCategory = courseCategories[0];
  String campus = campuses[0];
  String weekDayy = weekDays[0];

  TextEditingController? courseNameController;
  TextEditingController? courseCodeController;

  @override
  void dispose() {
    courseNameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final programs = ref.watch(programsProvider);

    final programNames = programs.map((e) => e.programName).toList();

    double keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: courseNameController,
              decoration: const InputDecoration(
                label: Text('Course Name'),
              ),
              keyboardType: TextInputType.name,
              maxLines: 1,
            ),
            TextField(
              controller: courseCodeController,
              decoration: const InputDecoration(
                label: Text('Course Code'),
              ),
              keyboardType: TextInputType.name,
              maxLines: 1,
            ),
            const SizedBox(
              height: 8,
            ),
            MyDropDownButton(items: programNames, label: 'Program')
          ],
        ),
      ),
    );
  }
}
