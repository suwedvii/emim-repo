import 'dart:async';
import 'package:emim/models/my_user.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final usersRef = FirebaseDatabase.instance.ref().child('users');

class UsersNotifier extends AsyncNotifier<List<MyUser>> {
  @override
  FutureOr<List<MyUser>> build() async {
    await for (final event in usersRef.onValue) {
      final List<MyUser> foundUsers = [];
      for (final userSnapshot in event.snapshot.children) {
        foundUsers.add(MyUser().fromSnapshot(userSnapshot));
      }
      return foundUsers;
    }

    return [];
  }
}

// an Async Provider: as it returns a Future
final usersProvider =
    AsyncNotifierProvider<UsersNotifier, List<MyUser>>(UsersNotifier.new);

    // On Passing Multiple Parameters

    // typedef parameters = ({String name, Int maount});

    // final userProvider = Provider.autoDispose.family<String, parameters>((ref, arg) => );
