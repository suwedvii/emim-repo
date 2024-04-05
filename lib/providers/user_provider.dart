import 'package:emim/models/my_user.dart';
import 'package:emim/providers/users_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider =
    FutureProvider.autoDispose.family<MyUser, String>((ref, uid) async {
  final users = ref.watch(usersProvider);
  var foundUser = MyUser();
  for (final user in users.value!) {
    if (user.uid == uid) {
      foundUser = user;
    }
  }

  print(foundUser.firstName);

  return foundUser;
});
