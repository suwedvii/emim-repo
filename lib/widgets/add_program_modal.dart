import 'dart:convert';
import 'dart:ui';

import 'package:emim/models/program.dart';
// import 'package:emim/providers/faculties_provider.dart';
// import 'package:emim/widgets/drop_down_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AddProgramModal extends ConsumerStatefulWidget {
  const AddProgramModal({super.key});

  @override
  ConsumerState<AddProgramModal> createState() {
    return _AddProgramModalState();
  }
}

class _AddProgramModalState extends ConsumerState<AddProgramModal> {
  TextEditingController? programNameController;
  String programDuration = durations[0];
  String programCode = '';
  String programName = '';
  String description = '';
  String? selectedFaculty;

  List<String> fetchedFaculties = ['Select Faculty'];

  bool isLoadingFacultiesAndDurations = true;

  @override
  void initState() {
    super.initState();
    _loadFaculties();
  }

  final formKey = GlobalKey<FormState>();

  void _loadFaculties() async {
    final List<String> loadedFaculties = [];

    final url =
        Uri.https('emimbacke-default-rtdb.firebaseio.com', 'faculties.json');

    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);

    for (final faculty in listData.entries) {
      loadedFaculties.add(faculty.value['name']);
    }

    setState(() {
      fetchedFaculties = loadedFaculties;
      isLoadingFacultiesAndDurations = false;
    });

    print(fetchedFaculties);
  }

  void _addProgram(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      print(programCode);
      print(programName);
      print(selectedFaculty);
      print(programDuration);

      final currentContext = context;

      final url =
          Uri.https('emimbacke-default-rtdb.firebaseio.com', 'programs.json');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'programCode': programCode,
            'programName': programName,
            'description': description,
            'faculty': selectedFaculty,
            'duration': programDuration
          }),
        );

        if (currentContext.mounted) {
          Navigator.of(context).pop<Program>(
            Program(
                programId: response.body,
                description: description,
                duration: programDuration,
                faculty: selectedFaculty.toString(),
                programCode: programCode,
                programName: programName),
          );
        }
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selectedFaculty = fetchedFaculties[0];

    double keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    // List<String>? facuties = ref.read(facultiesProvider);

    if (fetchedFaculties.isEmpty) {
      fetchedFaculties = ['No Faculties'];
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 30),
      child: Form(
        key: formKey,
        child: isLoadingFacultiesAndDurations
            ? const Center(
                child: LinearProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add Program',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // TextField(
                  TextFormField(
                      // controller: programNameController,
                      validator: (programName) {
                        if (programName == null ||
                            programName.isEmpty ||
                            programName.trim().length < 5) {
                          return 'Must be atleast 5 Characters!';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        label: Text('Program Name'),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (name) {
                        programName = name!;
                      }),
                  const SizedBox(
                    height: 8,
                  ),
                  // const SizedBox(
                  //   height: 2,
                  // ),
                  // TextField(
                  TextFormField(
                    // controller: programNameController,
                    validator: (programCode) {
                      if (programCode == null ||
                          programCode.isEmpty ||
                          programCode.trim().length < 5) {
                        return 'Must be atleast 5 Characters!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      label: Text('Program Code'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    onSaved: (code) {
                      programCode = code!;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    // controller: programNameController,
                    validator: (description) {
                      if (description == null ||
                          description.isEmpty ||
                          description.trim().length < 5) {
                        return 'Must be atleast 5 Characters!';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      label: Text('Description'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    maxLines: 3,
                    keyboardType: TextInputType.text,
                    onSaved: (enteredDescription) {
                      description = enteredDescription!;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Column(
                    children: [
                      // MyDropDownButton(items: facuties, label: 'Faculty'),
                      DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          value: selectedFaculty,
                          items: fetchedFaculties
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          // items: [
                          //   for (final faculty in fetchedFaculties)
                          //     DropdownMenuItem(
                          //       value: faculty,
                          //       child: Text(faculty),
                          //     ),
                          // ],
                          onChanged: (faculty) {
                            if (faculty == null || faculty == 'No Faculties') {
                              return;
                            }

                            setState(() {
                              selectedFaculty = faculty;
                            });
                          }),
                      const SizedBox(
                        height: 8,
                      ),
                      // const Spacer(),
                      // MyDropDownButton(items: durations, label: 'Duration')
                      DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          value: programDuration,
                          items: [
                            for (final duration in durations)
                              DropdownMenuItem(
                                value: duration,
                                child: Text(duration),
                              ),
                          ],
                          onChanged: (duration) {
                            if (duration == null) {
                              return;
                            }
                            setState(() {
                              programDuration = duration;
                            });
                          }),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          formKey.currentState!.reset();
                        },
                        child: const Text('Reset'),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _addProgram(context);
                        },
                        child: const Text('Add Program'),
                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
