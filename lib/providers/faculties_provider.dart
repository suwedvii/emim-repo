import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class FacultiesNotifier extends StateNotifier<List<String>> {
  FacultiesNotifier() : super([]);

  addFaculty(String faculty) async {
    final url = Uri.http('emimbacke-default-rtdb.firebaseio.com', 'faculties');

    bool facultyExist = state.contains(faculty);

    if (facultyExist) {
      state = state.where((e) => e != faculty).toList();
      return null;
    } else {
      state = [...state, faculty];
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {'faculty': faculty},
        ),
      );
      return response;
    }
  }
}

final facultiesProvider =
    StateNotifierProvider<FacultiesNotifier, List<String>>(
  (ref) => FacultiesNotifier(),
);
