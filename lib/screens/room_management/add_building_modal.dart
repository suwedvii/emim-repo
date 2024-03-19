import 'package:emim/constants.dart';
import 'package:emim/models/building.dart';
import 'package:emim/widgets/custom_drop_down_button.dart';
import 'package:emim/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddBuildingModal extends StatefulWidget {
  const AddBuildingModal({super.key});

  @override
  State<AddBuildingModal> createState() => _AddBuildingModalState();
}

class _AddBuildingModalState extends State<AddBuildingModal> {
  bool isLoading = false;
  final form = GlobalKey<FormState>();
  String enteredText = '';
  String selectedCampus = Constants().campuses[0];
  String buildingId = 'B01';

  void _addBuilding(BuildContext ctx) {
    final DatabaseReference ref =
        FirebaseDatabase.instance.ref().child('buildings');

    try {
      if (form.currentState!.validate()) {
        form.currentState!.save();
        final id = ref.push().key;

        final building =
            Building(id: id!, campus: selectedCampus, name: enteredText);
        setState(() {
          isLoading = true;
        });
        ref.child(id).set(building.toMap()).whenComplete(() {
          setState(() {
            isLoading = false;
            Navigator.of(ctx).pop();
          });
        });
      }
    } on FirebaseException catch (exception) {
      print(exception);
    }
  }

  @override
  void dispose() {
    super.dispose();
    form.currentState?.dispose();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return Container(
        margin: EdgeInsets.only(bottom: 16 + keyboardSpace),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add a Building',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              MyTextFormFiled(
                  onValidate: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a valid building name';
                    }
                    return null;
                  },
                  onValueSaved: (value) {
                    enteredText = value!.trim();
                  },
                  label: 'Building Name'),
              const SizedBox(height: 8),
              CustomDropdown(
                  items: Constants().campuses,
                  value: selectedCampus,
                  onChanged: (String? value) {
                    if (value == null) return;
                    setState(() {
                      selectedCampus = value;
                    });
                  },
                  label: 'Campus'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!isLoading)
                    TextButton(
                      onPressed: () {
                        form.currentState!.reset();
                      },
                      child: const Text('Reset'),
                    ),
                  const SizedBox(
                    width: 2,
                  ),
                  if (!isLoading)
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
                      _addBuilding(context);
                    },
                    child: isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Add Building'),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
