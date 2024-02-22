import 'dart:convert';

import 'package:emim/models/my_user.dart';
import 'package:emim/screens/profile/add_user_screen.dart';
import 'package:emim/widgets/profile/user_list.dart';
import 'package:firebase_core/firebase_core.dart';
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
  bool isLoading = true;
  List<MyUser> users = [];
  List<Map<String, dynamic>> usersMapList = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    print('LoadUsers was called');

    try {
      final url =
          Uri.https('emimbacke-default-rtdb.firebaseio.com', 'users.json');

      final List<MyUser> userList = [];
      List<Map<String, dynamic>>? retrievedUsersMap = [];

      final response = await http.get(url);

      print(response.body);

      if (response.statusCode >= 400) {
        print('Failed to fetch information from the database');
      }

      final Map<String, dynamic>? listData = json.decode(response.body);

      print('Status code: ${response.statusCode}');

      if (listData == null) return;

      for (final user in listData.entries) {
        // final id = user.key.toString();
        // final username = user.value['username'];
        // final email = user.value['emailAddress'];
        // final password = user.value['password'];
        // final role = user.value['role'];

        userList.add(MyUser.fromMap(user.value));
        retrievedUsersMap.add(user.value);
        print(MyUser.fromMap(user.value));
      }

      setState(() {
        users = userList;
        usersMapList = retrievedUsersMap;
        isLoading = false;
        print(users.length);
      });
    } on FirebaseException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message!),
        ),
      );
    }
  }

  void _openAddUserBottomModal(String userType) async {
    final error = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => AddUserScreen(userType: userType, loadUsers: loadUsers),
    );

    if (error == null) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(users);
    Widget content = isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : UserList(
            userMap: usersMapList,
            users: users,
          );
    // if (users.isEmpty) {
    //   content = Center(
    //     child: Text(
    //       'No users found',
    //       style: Theme.of(context).textTheme.bodyLarge,
    //     ),
    //   );
    // }
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
              _openAddUserBottomModal('student');
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.edit_square),
            label: 'Add Instructor',
            onTap: () {
              _openAddUserBottomModal('instructor');
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.attach_money),
            label: 'Add Accountant',
            onTap: () {
              _openAddUserBottomModal('accountant');
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.computer_rounded),
            label: 'Add Administrator',
            onTap: () {
              _openAddUserBottomModal('administrator');
            },
          ),
        ],
      ),
      body: content,
    );
  }
}
