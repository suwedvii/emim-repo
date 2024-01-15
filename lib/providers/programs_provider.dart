import 'package:emim/models/program.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgramsNotifier extends StateNotifier<List<Program>> {
  ProgramsNotifier() : super([]);

  void addProgram(Program program) {
    final programExist = state.contains(program);

    if (programExist) {
      state = state.where((e) => e.programCode != program.programCode).toList();
    } else {
      state = [...state, program];
    }
  }
}

final programsProvider = StateNotifierProvider<ProgramsNotifier, List<Program>>(
  (ref) => ProgramsNotifier(),
);
