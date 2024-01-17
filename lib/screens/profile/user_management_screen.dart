import 'dart:convert';

import 'package:emim/models/user.dart';
import 'package:emim/screens/profile/add_user_screen.dart';
import 'package:emim/widgets/profile/user_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserManagementScreenState();
  }
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    print('LoadUsers was called');

    final url =
        Uri.https('emimbacke-default-rtdb.firebaseio.com', 'users.json');

    final List<User> userList = [];

    final response = await http.get(url);

    print(response.body);

    if (response.statusCode >= 400) {
      print('Failed to fetch information from the database');
    }

    final Map<String, dynamic>? listData = json.decode(response.body);

    print('Status code: ${response.statusCode}');

    if (listData == null) {
      return;
    }

    for (final user in listData.entries) {
      final id = user.key.toString();
      final username = user.value['username'];
      final email = user.value['email'];
      final password = user.value['password'];
      final role = user.value['role'];

      userList.add(User(
        userId: id,
        username: username,
        emailAddress: email,
        password: password,
        role: role,
      ));
    }

    setState(() {
      users = userList;
      print(users.length);
    });
  }

  void _openAddUserBottomModal(String userType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => AddUserScreen(userType: userType, loadUsers: loadUsers),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(users);
    Widget content = UserList(
      users: users,
    );
    if (users.isEmpty) {
      content = Center(
        child: Text(
          'No users found',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        overlayOpacity: 0,
        spaceBetweenChildren: 8,
        spacing: 6,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.person_2_outlined),
            label: 'Add Student',
            onTap: () {
              _openAddUserBottomModal('Student');
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.edit_square),
            label: 'Add Instructor',
            onTap: () {
              _openAddUserBottomModal('Instructor');
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.attach_money),
            label: 'Add Accountant',
            onTap: () {
              _openAddUserBottomModal('Accountant');
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.computer_rounded),
            label: 'Add Administrator',
            onTap: () {
              _openAddUserBottomModal('Administrator');
            },
          ),
        ],
      ),
      body: content,
    );
  }
}
