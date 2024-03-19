import 'dart:convert';
import 'package:emim/constants.dart';
import 'package:emim/models/program.dart';
import 'package:emim/widgets/custom_drop_down_button.dart';
import 'package:emim/widgets/custom_text_form_field.dart';
import 'package:emim/widgets/profile/my_toggle_switch.dart';
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
  final formKey = GlobalKey<FormState>();
  String programDuration = durations[0];
  String programCode = '';
  String programName = '';
  String description = '';
  String selectedFaculty = '';
  String semesters = '';
  String selecetedCampus = Constants().campuses[0];

  List<String> fetchedFaculties = ['Select Faculty'];

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    double keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 30),
      child: Form(
        key: formKey,
        child: isLoading
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
                  MyTextFormFiled(
                      onValidate: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.trim().length < 8) {
                          return 'Please enter a valid Program Name with Characters not less than 8';
                        }

                        return null;
                      },
                      onValueSaved: (value) {
                        programName = value!;
                      },
                      label: 'Program Name'),
                  const SizedBox(
                    height: 8,
                  ),
                  MyTextFormFiled(
                      onValidate: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a valid Program Code with Characters not less than 1';
                        }

                        return null;
                      },
                      onValueSaved: (value) {
                        programCode = value!;
                      },
                      label: 'Program Code'),
                  const SizedBox(height: 8),
                  MyTextFormFiled(
                      inputType: TextInputType.number,
                      onValidate: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            int.parse(value.trim().toString()) == 0) {
                          return 'Please enter a valid number of semesters for this program';
                        }
                        return null;
                      },
                      onValueSaved: (value) {
                        semesters = value!;
                      },
                      label: 'Semesters'),
                  const SizedBox(
                    height: 8,
                  ),
                  MyTextFormFiled(
                      onValidate: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.trim().length < 15) {
                          return 'Please enter a valid program description with Characters not less than 15';
                        }

                        return null;
                      },
                      onValueSaved: (value) {
                        description = value!;
                      },
                      label: 'Description'),
                  const SizedBox(
                    height: 8,
                  ),
                  // MyDropDownButton(items: facuties, label: 'Faculty'),
                  CustomDropdown(
                      items: fetchedFaculties,
                      value: fetchedFaculties.isEmpty
                          ? 'No Falcuties'
                          : fetchedFaculties[0],
                      onChanged: (value) {
                        selectedFaculty = value!;
                      },
                      label: 'Falcuty'),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomDropdown(
                      items: durations,
                      value: fetchedFaculties.isEmpty
                          ? 'No Durations'
                          : durations[0],
                      onChanged: (value) {
                        programDuration = value!;
                      },
                      label: 'Duration'),
                  const SizedBox(
                    height: 8,
                  ),
                  MyToggleSwitch(
                      labels: Constants().campuses,
                      onToggled: (index, campus) {
                        selecetedCampus = campus;
                      }),
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
      isLoading = false;
    });

    print(fetchedFaculties);
  }

  void _addProgram(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      final newProgram = Program(
              description: description,
              faculty: selectedFaculty,
              campus: selecetedCampus,
              programCode: programCode,
              programName: programName,
              semesters: semesters,
              duration: programDuration)
          .toJson();

      final currentContext = context;

      final url =
          Uri.https('emimbacke-default-rtdb.firebaseio.com', 'programs.json');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: newProgram,
        );

        if (currentContext.mounted) {
          Navigator.of(context).pop<Program>(
            Program(
                programId: response.body,
                description: description,
                duration: programDuration,
                faculty: selectedFaculty,
                programCode: programCode,
                programName: programName,
                semesters: semesters),
          );
        }
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFaculties();
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }
}
