import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final academicYearProvider = StreamProvider<String>((ref) async* {
  final yearRef = FirebaseDatabase.instance.ref().child('activeYear');
  await for (final event in yearRef.onValue) {
    String academicYear = '';
    for (final year in event.snapshot.children) {
      final founndYear = year.child('academicYear').value.toString();
      academicYear = founndYear;
    }
    yield academicYear;
  }
});
