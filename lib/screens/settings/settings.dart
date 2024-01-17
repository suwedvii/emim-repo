import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Settings> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<Settings> {
  bool isLoggedIn = true;

  void _logOutUser() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to Logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(ctx).pop(); // Close the dialog
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Log Out'),
            subtitle: const Text('Clear Log in record'),
            trailing: const Icon(Icons.exit_to_app_rounded),
            onTap: _logOutUser,
          ),
          const Divider(
            height: 3,
            indent: 8,
            endIndent: 8,
          )
        ],
      ),
      // Add your settings-related UI components here
    );
  }
}
