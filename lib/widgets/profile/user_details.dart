import 'package:emim/models/user.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({super.key, required this.user});

  final MyUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details | ${user.firstName} ${user.lastName}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 60,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Name: ${user.firstName} ${user.otherNames} ${user.lastName}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Role: ${user.role.toUpperCase()}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text('User ID: ${user.userId.toUpperCase()}',
                            style: Theme.of(context).textTheme.bodyLarge!),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
