import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
// import 'package:quickalert/quickalert.dart';

class Constants {
  List<String> campuses = ['Blantyre', 'Lilongwe'];

  List<String> courseCategories = ['Core', 'Selective'];

  List<String> semesters = ['1', '2'];

  List<String> years = ['1', '2', '3', '4', '5'];

  List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  List<String> classSchedules = ['Normal', 'Make Up'];

  List<String> genders = ['Male', 'Female', 'Other'];

  List<String> roles = ['Admin', 'Student', 'Instructor', 'Accountant'];

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
      elevation: 8,
      action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            Navigator.of(context).pop();
          }),
    ));
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.Hm(); // 6:00 AM
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  InputDecoration dropDownInputDecoration(
      BuildContext context, String? label, EdgeInsets? padding) {
    return InputDecoration(
      hintText: label,
      alignLabelWithHint: true,
      contentPadding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      filled: true,
      fillColor: Theme.of(context).colorScheme.onPrimary,
      labelText: label,
      border: const OutlineInputBorder(
        borderSide: BorderSide(width: 5, style: BorderStyle.solid),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
    );
  }

  List<DropdownMenuItem> getDropDownMenuItems(List<String> items) {
    return items
        .map(
          (item) => DropdownMenuItem(
            value: item,
            child: Text(item),
          ),
        )
        .toList();
  }

  List<FormBuilderChipOption<String>> getFormBuilderChipOptions(
      List<String> items) {
    return items
        .map(
          (e) => FormBuilderChipOption(value: e),
        )
        .toList();
  }
}
