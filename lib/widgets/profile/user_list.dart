import 'package:emim/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserList extends ConsumerWidget {
  const UserList({super.key, required this.users});

  final List<User> users;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(users);

    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (ctx, index) => ListTile(
              title: Text(users[index].username),
              leading: Text(users[index].id),
            ));
  }
}
