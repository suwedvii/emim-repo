import 'dart:async';

import 'package:emim/models/my_user.dart';
import 'package:emim/screens/course_management/change_academic_year_bottom_sheet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:emim/constants.dart';
import 'package:emim/models/program.dart';
import 'package:emim/screens/course_management/program_details_screen..dart';
import 'package:emim/widgets/add_faculty_and_cohort_modal.dart';
import 'package:emim/widgets/add_program_modal.dart';
import 'package:emim/widgets/custom_card_widget.dart';
import 'package:emim/widgets/profile/my_toggle_switch.dart';

class ProgramManagementScreen extends ConsumerStatefulWidget {
  const ProgramManagementScreen(
      {super.key, this.appBarTitle, required this.user});

  final String? appBarTitle;
  final MyUser user;

  @override
  ConsumerState<ProgramManagementScreen> createState() {
    return _CourseManagementScreenState();
  }
}

class _CourseManagementScreenState
    extends ConsumerState<ProgramManagementScreen> {
  late List<Program> foundPrograms;
  late Stream<List<Program>> programs;
  List<Program> filteredPrograms = [];
  bool isLoading = true;
  List<String> campuses = ['All', ...Constants().campuses];
  String? selectedCampus;

  @override
  void initState() {
    super.initState();
    programs = _loadPrograms();
    selectedCampus = campuses[0];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        overlayOpacity: 0,
        spacing: 5,
        children: [
          SpeedDialChild(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            label: 'Change Academic Year',
            child: const Icon(Icons.calendar_month_outlined),
            onTap: () {
              _openChangeAcademicYearBottomSheet();
            },
          ),
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
      body: Container(
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
                child: StreamBuilder(
                    stream: programs,
                    builder: (context, snapshot) {
                      Widget content = const Center(
                        child: Text('Oops, Nothing here yet'),
                      );

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        content = const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (!snapshot.hasData) {
                        content = const Center(
                          child: Text('No Programs found'),
                        );
                      } else if (snapshot.hasError) {
                        Constants()
                            .showMessage(context, snapshot.error.toString());
                      } else if (snapshot.hasData) {
                        foundPrograms = snapshot.data!;

                        if (selectedCampus!.toLowerCase() == 'all') {
                          filteredPrograms = foundPrograms;
                        } else {
                          filteredPrograms = foundPrograms
                              .where((program) =>
                                  program.campus.toLowerCase() ==
                                  selectedCampus!.toLowerCase())
                              .toList();
                        }

                        if (filteredPrograms.isEmpty) {
                          content = const Center(
                            child: Text('No Programs Added yet'),
                          );
                        }
                        if (filteredPrograms.isNotEmpty) {
                          content = ListView.builder(
                              itemCount: filteredPrograms.length,
                              itemBuilder: (ctx, index) {
                                final program = filteredPrograms[index];
                                return InkWell(
                                  onTap: () {
                                    _goToProgramDetails(ctx, program);
                                  },
                                  child: CustomCardWidget(
                                    title: program.programCode,
                                    subtitle: program.programName,
                                    trailing: program.faculty,
                                  ),
                                );
                              });
                        }
                      }
                      return content;
                    }),
              ),
            ],
          )),
    );
  }

  void _openChangeAcademicYearBottomSheet() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => const ChangeAcademicYearBottomSheet(),
    );
  }

  Stream<List<Program>> _loadPrograms() async* {
    List<Program> retrievedPrograms = [];

    try {
      final programsRef = FirebaseDatabase.instance.ref().child('programs');

      programsRef.onValue.listen((event) {
        retrievedPrograms.clear();
        for (final program in event.snapshot.children) {
          final retrievedProgram = Program.fromSnapshot(program);
          print(retrievedProgram.description);
          setState(() {
            retrievedPrograms.add(retrievedProgram);
          });
        }
      });
      setState(() {
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      if (mounted) {
        Constants().showMessage(context, e.message.toString());
      }
    }

    yield retrievedPrograms;
  }

  void _openAddFacultyBottomSheet(String mode) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => AddFacultyAndCohortModal(mode: mode),
    );
  }

  void _openAddProgramBottomSheet() async {
    final result = await showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => const AddProgramModal(),
    );

    if (result == null) return;
  }

  void _goToProgramDetails(BuildContext ctx, Program program) {
    Navigator.of(ctx).push(MaterialPageRoute(
        builder: (context) => ProgramDetailsScreen(program: program)));
  }
}
