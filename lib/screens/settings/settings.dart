import 'package:emim/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  ConsumerState<Settings> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends ConsumerState<Settings> {
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
            onPressed: () async {
              await FirebaseAuth.instance.signOut().whenComplete(() {
                Navigator.of(ctx).pop();
                if (mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (ctx) => const App(),
                    ),
                  );
                }
              });
              // Close the dialog
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _changePAssword() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'Log Out',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: const Text('Sign out the current user'),
            trailing: const Icon(Icons.exit_to_app_rounded),
            onTap: _logOutUser,
          ),
          const Divider(
            height: 3,
            indent: 8,
            endIndent: 8,
          ),
          ListTile(
            title: Text(
              'Change Password',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: const Text('Change your cureent password'),
            trailing: const Icon(Icons.lock_reset),
            onTap: _changePAssword,
          ),
          const Divider(
            height: 3,
            indent: 8,
            endIndent: 8,
          ),
        ],
      ),
      // Add your settings-related UI components here
    );
  }
}
