import 'package:emim/screens/profile/user_management_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.title});

  final String title;

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
          IconButton(
            onPressed: _goToUserManagementScreen,
            // icon: const Icon(Icons.more_vert_outlined))
            icon: const Icon(Icons.people_alt_outlined),
          )
        ],
      ),
    );
  }
}
