import 'package:emim/models/my_user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends StateNotifier<MyUser> {
  UserNotifier() : super(MyUser());

  void getUser(String uid) async {
    FirebaseDatabase.instance.ref().child('users').onValue.listen((event) {
      for (final user in event.snapshot.children) {
        final retrievedUser = MyUser().fromSnapshot(user);
        if (retrievedUser.uid == uid) {
          state = retrievedUser;
        }
      }
    });
  }
}

final userProvider = StateNotifierProvider<UserNotifier, MyUser>(
  (ref) => UserNotifier(),
);
