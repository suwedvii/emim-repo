import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:quickalert/quickalert.dart';

class Constants {
  List<String> campuses = ['Blantyre', 'Lilongwe'];

  List<String> courseCategories = ['Core', 'Selective'];

  List<String> semesters = ['One', 'Two'];

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

  // void showQuickAlert(BuildContext context, QuickAlertType type, String title, String text, String cancelBtnText, bool showConfirmBtn) {
  //   QuickAlert.show(
  //     context: context,
  //     type: type,
  //     title: title,
  //     borderRadius: 8,
  //     text: text,
  //     showCancelBtn: ,
  //     cancelBtnText: cancelBtnText,
  //     onCancelBtnTap: (){Navigator.of(context).pop();},
  //     showConfirmBtn: sh,
  //     confirmBtnText: ,
  //     confirmBtnTextStyle: ,
  //     onConfirmBtnTap: ,
  //     barrierDismissible: false,
  //     disableBackBtn: false);
  // }
}
