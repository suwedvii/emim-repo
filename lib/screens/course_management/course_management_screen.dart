import 'package:emim/constants.dart';
import 'package:emim/models/program.dart';
import 'package:emim/screens/course_management/program_list.dart';
import 'package:emim/widgets/add_faculty_and_cohort_modal.dart';
import 'package:emim/widgets/add_program_modal.dart';
import 'package:emim/widgets/profile/my_toggle_switch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
  List<Program> filteredPrograms = [];
  bool isLoading = true;
  List<String> campuses = ['All', ...Constants().campuses];
  String? selectedCampus;

  @override
  void initState() {
    super.initState();
    _loadPrograms();
    selectedCampus = campuses[0];
  }

  void _loadPrograms() async {
    List<Program> retrievedPrograms = [];

    try {
      final programsRef = FirebaseDatabase.instance.ref().child('programs');

      programsRef.onValue.listen((event) {
        for (final program in event.snapshot.children) {
          final retrievedProgram = Program.fromSnapshot(program);
          print(retrievedProgram.description);
          setState(() {
            retrievedPrograms.add(retrievedProgram);
          });
        }
      });

      setState(() {
        programs = retrievedPrograms;
        print(programs.length);
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      if (mounted) {
        Constants().showMessage(context, e);
      }
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
    if (selectedCampus!.toLowerCase() == 'all') {
      filteredPrograms = programs;
    } else {
      filteredPrograms = programs
          .where((program) =>
              program.campus.toLowerCase() == selectedCampus!.toLowerCase())
          .toList();
    }
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
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                children: [
                  MyToggleSwitch(
                      labels: campuses,
                      minHeight: 30,
                      onToggled: (index, campus) {
                        setState(() {
                          selectedCampus = campus;
                        });
                      }),
                  Expanded(
                    child: ProgramList(programs: filteredPrograms),
                  ),
                ],
              )),
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
