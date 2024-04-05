import 'dart:convert';
import 'package:emim/constants.dart';
import 'package:emim/models/program.dart';
import 'package:emim/providers/programs_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
  String? error;
  final formKey = GlobalKey<FormBuilderState>();

  List<String> fetchedFaculties = ['Select Faculty'];

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    double keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final List<Program>? programsData = ref.watch(programsProvider).valueOrNull;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 30),
      child: FormBuilder(
        key: formKey,
        child: Column(
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
            FormBuilderTextField(
              valueTransformer: (value) => value.toString().trim(),
              enableSuggestions: true,
              decoration: Constants().dropDownInputDecoration(
                context,
                'Program Name',
                null,
              ),
              autovalidateMode: AutovalidateMode.disabled,
              name: 'program_name',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(5),
              ]),
            ),
            const SizedBox(
              height: 8,
            ),
            FormBuilderTextField(
              valueTransformer: (value) => value.toString().trim(),
              enableSuggestions: true,
              decoration: Constants().dropDownInputDecoration(
                context,
                'Program Code',
                null,
              ),
              autovalidateMode: AutovalidateMode.disabled,
              name: 'program_code',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(4),
              ]),
            ),
            const SizedBox(
              height: 8,
            ),
            FormBuilderTextField(
              keyboardType: TextInputType.number,
              decoration: Constants().dropDownInputDecoration(
                context,
                'Semesters',
                null,
              ),
              autovalidateMode: AutovalidateMode.disabled,
              name: 'semesters',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.integer(),
              ]),
            ),
            const SizedBox(
              height: 8,
            ),
            FormBuilderTextField(
              valueTransformer: (value) => value.toString().trim(),
              enableSuggestions: true,
              decoration: Constants().dropDownInputDecoration(
                context,
                'Description',
                null,
              ),
              autovalidateMode: AutovalidateMode.disabled,
              name: 'description',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.minLength(5),
              ]),
            ),
            const SizedBox(
              height: 8,
            ),
            // MyDropDownButton(items: facuties, label: 'Faculty'),
            FormBuilderDropdown(
              validator: FormBuilderValidators.required(),
              decoration:
                  Constants().dropDownInputDecoration(context, 'Faculty', null),
              name: 'faculty',
              items: Constants().getDropDownMenuItems(fetchedFaculties),
            ),
            const SizedBox(
              height: 8,
            ),
            FormBuilderDropdown(
              validator: FormBuilderValidators.required(),
              decoration: Constants()
                  .dropDownInputDecoration(context, 'Duration', null),
              name: 'duration',
              items: Constants().getDropDownMenuItems(durations),
            ),
            const SizedBox(
              height: 8,
            ),
            FormBuilderChoiceChip(
              validator: FormBuilderValidators.required(),
              alignment: WrapAlignment.spaceBetween,
              decoration:
                  Constants().dropDownInputDecoration(context, 'Campus', null),
              name: 'campus',
              options: Constants()
                  .campuses
                  .map(
                    (e) => FormBuilderChipOption(value: e),
                  )
                  .toList(),
            ),
            const SizedBox(
              height: 8,
            ),
            if (error != null)
              Column(
                children: [
                  Text(
                    'Error: $error',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
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
                if (!isLoading)
                  ElevatedButton(
                    onPressed: () {
                      _addProgram(programsData);
                    },
                    child: const Text('Add Program'),
                  ),
                if (isLoading)
                  const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(),
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
  }

  void _addProgram(List<Program>? programData) async {
    final programsRef = FirebaseDatabase.instance.ref().child('programs');

    if (formKey.currentState!.validate()) {
      setState(() {
        error = null;
        isLoading = true;
      });
      formKey.currentState!.save();
      final data = formKey.currentState!.value;
      final programCode = data['program_code'].toString();
      final campus = data['campus'].toString();

      try {
        if (programNotExist(programData, programCode, campus)) {
          final programId = programsRef.push().key;
          if (programId != null) {
            final newProgram = Program(
              programId: programId,
              programCode: programCode,
              programName: data['program_name'].toString(),
              description: data['description'].toString(),
              faculty: data['faculty'].toString(),
              duration: data['duration'].toString(),
              semesters: data['semesters'].toString(),
              campus: campus,
            ).toMap();

            await programsRef.child(programId).set(newProgram).whenComplete(() {
              Navigator.of(context).pop();
            });
          }
        }
      } on FirebaseException catch (e) {
        setState(() {
          error = e.message;
          isLoading = false;
        });
      }
    }
  }

  bool programNotExist(
    List<Program>? data,
    String code,
    String campus,
  ) {
    if (data != null) {
      for (final program in data) {
        if (program.campus == campus) {
          setState(() {
            isLoading = false;
            error = 'Program already exist';
          });
          return false;
        }
      }
    }

    return true;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    if (mounted) {
      super.initState();
      _loadFaculties();
    }
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }
}
