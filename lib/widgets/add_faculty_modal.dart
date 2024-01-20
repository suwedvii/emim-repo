import 'dart:convert';

// import 'package:emim/providers/faculties_provider.dart';
import 'package:emim/models/cohort.dart';
import 'package:emim/models/faculty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class AddFacultyModal extends ConsumerStatefulWidget {
  const AddFacultyModal({super.key, required this.mode});

  final String mode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _AddFacultyModalState();
  }
}

class _AddFacultyModalState extends ConsumerState<AddFacultyModal> {
  bool isLoading = false;
  final form = GlobalKey<FormState>();

  final facultyNameController = TextEditingController();

  void _addFaculty(String? item) async {
    if (form.currentState!.validate()) {
      isLoading = true;
      final url = Uri.https('emimbacke-default-rtdb.firebaseio.com',
          '${widget.mode.toLowerCase()}s.json');
      final entredItem = widget.mode == 'Faculty'
          ? Faculty(item).toJson()
          : Cohort(item).toJson();
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(entredItem),
      );

      // print(ref.read(facultiesProvider));

      print(response.body);

      Navigator.of(context).pop();
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
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 30),
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
            TextFormField(
              controller: facultyNameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                label: Text('${widget.mode} Name'),
              ),
              keyboardType: TextInputType.name,
              maxLines: 1,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    value.trim().length < 6) {
                  return 'Enter a valived ${widget.mode} name';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                _addFaculty(facultyNameController.text);
              },
              child: !isLoading
                  ? Text('Add ${widget.mode}')
                  : const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
