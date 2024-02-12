import 'dart:convert';

import 'package:emim/models/program.dart';
import 'package:emim/screens/course_management/program_list.dart';
import 'package:emim/widgets/add_faculty_and_cohort_modal.dart';
import 'package:emim/widgets/add_program_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

class CourseScreen extends ConsumerStatefulWidget {
  const CourseScreen({super.key, this.appBarTitle});

  final String? appBarTitle;

  @override
  ConsumerState<CourseScreen> createState() {
    return _CourseScreenState();
  }
}

class _CourseScreenState extends ConsumerState<CourseScreen> {
  List<Program> programs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrograms();
    print(programs);
  }

  void _loadPrograms() async {
    List<Program> retrievedPrograms = [];
    final url =
        Uri.https('emimbacke-default-rtdb.firebaseio.com', 'programs.json');

    try {
      final response = await http.get(url);

      if (response.body.isEmpty) {
        return;
      }

      final dynamic decodedData = json.decode(response.body);

      if (decodedData == null || decodedData is! Map<String, dynamic>) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No data found')));
        return;
      }

      final Map<String, dynamic> listData = decodedData;

      for (final program in listData.entries) {
        retrievedPrograms.add(
          Program.fromMap(program.value),
        );
      }

      setState(() {
        programs = retrievedPrograms;
        print(programs.length);
        isLoading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  void _openAddFacultyBottomSheet(String mode) {
    showModalBottomSheet(
      // isDismissible: false,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => AddFacultyAndCohortModal(mode: mode),
    );
  }

  void _openAddProgramBottomSheet() async {
    final result = await showModalBottomSheet(
      isDismissible: false,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => const AddProgramModal(),
    );

    if (result == null) return;

    programs.add(result);
    _loadPrograms();
  }

  @override
  Widget build(BuildContext context) {
    // Widget content = Scaffold(
    return Scaffold(
      floatingActionButton: SpeedDial(
        overlayOpacity: 0,
        spacing: 5,
        children: [
          SpeedDialChild(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            label: 'Add Faculty',
            child: const Icon(Icons.library_books_outlined),
            onTap: () {
              _openAddFacultyBottomSheet('Faculty');
            },
          ),
          SpeedDialChild(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            label: 'Add Cohort',
            child: const Icon(Icons.people),
            onTap: () {
              _openAddFacultyBottomSheet('Cohort');
            },
          ),
          SpeedDialChild(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            label: 'Add Program',
            child: const Icon(Icons.my_library_add_outlined),
            onTap: () {
              _openAddProgramBottomSheet();
            },
          ),
        ],
        animatedIcon: AnimatedIcons.menu_close,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProgramList(programs: programs),
    );

    // if (widget.appBarTitle == null) {
    //   return content;
    // }

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('${widget.appBarTitle}'),
    //   ),
    // );
  }
}
