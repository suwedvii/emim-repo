import 'dart:convert';
import 'package:emim/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class UserNotifier extends StateNotifier<List<User>> {
  UserNotifier() : super([]);

  final url = Uri.http('emimbacke-default-rtdb.firebaseio.com', 'users.json');

  void loadUsers() async {
    try {
      final response = await http.get(url);

      final Map<Map, dynamic> retriviedUsers = json.decode(response.body);

      for (final user in retriviedUsers.entries) {
        final id = user.key.toString();
        final username = user.value['username'];
        final email = user.value['email'];
        final password = user.value['password'];
        final role = user.value['role'];
        final cohort = user.value['cohort'];
        final program = user.value['program'];
        final campus = user.value['campus'];

        state = [
          ...state,
          User(role, username, password, email,
              id: id, campus: campus, program: program, cohort: cohort)
        ];
      }
      // ignore: empty_catches
    } catch (error) {}
  }

  bool addUser(User user) {
    final userExist = state.contains(user);

    if (userExist) {
      state = state.where((element) => element.id != user.id).toList();
      return false;
    } else {
      state = [...state, user];
      return true;
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, List<User>>(
  (ref) => UserNotifier(),
);
