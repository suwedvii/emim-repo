import 'dart:async';

import 'package:emim/models/program.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final programsRef = FirebaseDatabase.instance.ref().child('programs');

class ProgramsNotifier extends AutoDisposeAsyncNotifier<List<Program>> {
  @override
  FutureOr<List<Program>> build() async {
    await for (final event in programsRef.onValue) {
      List<Program> foundPrograms = [];
      for (final snapshot in event.snapshot.children) {
        final retrivedProgram = Program.fromSnapshot(snapshot);
        foundPrograms.add(retrivedProgram);
      }
      return foundPrograms;
    }
    return [];
  }

  // Future<String?>? addProgram(Map<String, dynamic> newProgram) async {
  //   final id = programsRef.push().key;
  //   try {
  //     if (id != null) {
  //       newProgram.addAll({'programId': id});
  //       await programsRef.child(id).set(newProgram).whenComplete(() {
  //         ref.invalidateSelf();
  //         return null;
  //       });
  //     }
  //   } on FirebaseException catch (e) {
  //     return e.message;
  //   }
  // }
}

final programsProvider =
    AsyncNotifierProvider.autoDispose<ProgramsNotifier, List<Program>>(
        ProgramsNotifier.new);
