import 'dart:convert';
import 'package:emim/models/my_user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class UserNotifier extends StateNotifier<List<MyUser>> {
  UserNotifier() : super([]);

  final url = Uri.http('emimbacke-default-rtdb.firebaseio.com', 'users.json');

  void loadUsers() async {
    try {
      final response = await http.get(url);

      final Map<Map, dynamic> retriviedUsers = json.decode(response.body);

      for (final user in retriviedUsers.entries) {
        final retrievedUser = MyUser.fromMap(user.value);

        state = [...state, retrievedUser];
      }
      // ignore: empty_catches
    } catch (error) {}
  }

  bool addUser(MyUser user) {
    final userExist = state.contains(user);

    if (userExist) {
      state = state.where((element) => element.userId != user.userId).toList();
      return false;
    } else {
      state = [...state, user];
      return true;
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, List<MyUser>>(
  (ref) => UserNotifier(),
);
