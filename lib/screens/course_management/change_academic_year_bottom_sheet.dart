import 'package:emim/widgets/custom_text_form_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChangeAcademicYearBottomSheet extends StatefulWidget {
  const ChangeAcademicYearBottomSheet({super.key});

  @override
  State<ChangeAcademicYearBottomSheet> createState() =>
      _ChangeAcademicYearBottomSheetState();
}

class _ChangeAcademicYearBottomSheetState
    extends State<ChangeAcademicYearBottomSheet> {
  final form = GlobalKey<FormState>();
  bool isLoading = false;
  String enteredAcademicYear = '';

  @override
  Widget build(BuildContext context) {
    final keyboardspace = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardspace + 8),
      child: Form(
        key: form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Chenge Academic Year',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            MyTextFormFiled(
              inputType: TextInputType.number,
              onValidate: (value) {
                if (value == null ||
                    value.trim().length < 9 ||
                    !value.contains('-')) {
                  return 'Please enter a valid academic year e.g. 2023-2024';
                }
                return null;
              },
              onValueSaved: (value) {
                setState(() {
                  enteredAcademicYear = value!;
                });
              },
              label: 'Academic Year',
            ),
            ElevatedButton(
              onPressed: () {
                if (!isLoading) {
                  _changeAcademicYear();
                }
              },
              child: !isLoading
                  ? const Text('Submit')
                  : const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeAcademicYear() async {
    if (form.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      form.currentState!.save();
      final ref = FirebaseDatabase.instance.ref().child('activeYear');
      Map<String, dynamic> academicYear = {'academicYear': enteredAcademicYear};
      ref.update(academicYear).whenComplete(() {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    form.currentState?.dispose();
  }

  @override
  void initState() {
    if (mounted) {
      super.initState();
    }
  }
}
