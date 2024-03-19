import 'dart:convert';

// import 'package:emim/providers/faculties_provider.dart';
import 'package:emim/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AddFacultyAndCohortModal extends ConsumerStatefulWidget {
  const AddFacultyAndCohortModal({super.key, required this.mode});

  final String mode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddFacultyModalState();
  }
}

class _AddFacultyModalState extends ConsumerState<AddFacultyAndCohortModal> {
  bool isLoading = false;
  final form = GlobalKey<FormState>();

  String enteredText = '';

  void _addMode(String? item) async {
    setState(() {
      isLoading = true;
    });
    if (form.currentState!.validate()) {
      Uri? url = widget.mode == 'Faculty'
          ? Uri.https('emimbacke-default-rtdb.firebaseio.com', 'faculties.json')
          : Uri.https('emimbacke-default-rtdb.firebaseio.com', 'cohorts.json');

      form.currentState!.save();

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'name': enteredText}),
        );

        print(response.body);

        Navigator.of(context).pop();
      } on FirebaseException catch (exception) {
        print(exception);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    form.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
      child: Form(
        key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Add ${widget.mode}',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            MyTextFormFiled(
                onValidate: (value) {
                  if (value == null || value.trim().length < 5) {
                    return 'Please enter a valid ${widget.mode}';
                  }
                  return null;
                },
                onValueSaved: (value) {
                  enteredText = value!;
                },
                label: widget.mode),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  _addMode(enteredText);
                },
                child: isLoading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(),
                      )
                    : Text('Add ${widget.mode}')),
          ],
        ),
      ),
    );
  }
}
