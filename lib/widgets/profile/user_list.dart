import 'package:emim/models/user.dart';
import 'package:emim/widgets/profile/user_details.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  const UserList({super.key, required this.users, required this.userMap});

  final List<MyUser> users;
  final List<Map<String, dynamic>> userMap;

  void goToUserDetails(MyUser user, BuildContext context) async {
    Navigator.of(context).push<MyUser>(
      MaterialPageRoute(
        builder: (ctx) => UserDetails(
          user: user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(users);
    print(userMap);

    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (ctx, index) => GestureDetector(
              onTap: () {
                goToUserDetails(users[index], context);
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        users[index].username,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Divider(
                        height: 8,
                      ),
                      Row(
                        children: [
                          const Text('Role:'),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(users[index].role),
                          const SizedBox(
                            width: 16,
                          ),
                          const Text('User ID:'),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(users[index].userId),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
