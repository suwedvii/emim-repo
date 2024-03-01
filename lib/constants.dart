import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Constants {
  void showMessage(BuildContext context, FirebaseException error) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error.message ?? 'Authentication Failed'),
        action: SnackBarAction(
            label: 'Okay',
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
    );
  }
}
