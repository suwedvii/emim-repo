import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Constants {
  List<String> campuses = ['Blantyre', 'Lilongwe'];

  List<String> courseCategories = ['Core', 'Selective'];

  List<String> semesters = ['One', 'Two'];

  List<String> years = ['1', '2', '3', '4', '5'];

  List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  List<String> genders = ['Male', 'Female', 'Other'];

  List<String> roles = ['Admin', 'Student', 'Instructor', 'Accountant'];

  void showMessage(BuildContext context, FirebaseException error) {
    AlertDialog(
      title: const Text('Error'),
      content: Text(error.message.toString()),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Okay'))
      ],
    );
  }
}
