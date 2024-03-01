import 'package:emim/models/my_user.dart';
import 'package:emim/screens/profile/user_management_screen.dart';
import 'package:emim/widgets/profile/user_details.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.title, required this.user});

  final String title;
  final MyUser user;

  @override
  State<ProfileScreen> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<ProfileScreen> {
  void _goToUserManagementScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const UserManagementScreen(),
      ),
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (widget.user.role.toLowerCase() == 'admin')
            IconButton(
              onPressed: _goToUserManagementScreen,
              // icon: const Icon(Icons.more_vert_outlined))
              icon: const Icon(Icons.people_alt_outlined),
            )
        ],
      ),
      body: UserDetails(user: widget.user, appBarTitle: 'profile'),
    );
  }
}
