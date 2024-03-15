import 'package:emim/constants.dart';
import 'package:emim/models/my_user.dart';
import 'package:emim/screens/profile/add_user_screen.dart';
import 'package:emim/widgets/profile/user_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
    final List<MyUser> userList = [];

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users');

    try {
      usersRef.onValue.listen((event) {
        userList.clear();
        for (final user in event.snapshot.children) {
          final retrievedUser = MyUser().fromSnapshot(user);
          userList.add(retrievedUser);
        }
        setState(() {
          users = userList;
          isLoading = false;
        });
      });
    } on FirebaseException catch (e) {
      if (mounted) {
        Constants().showMessage(context, e.message.toString());
      }
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

    if (mounted) {
      Constants().showMessage(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : UserList(
            userMap: usersMapList,
            users: users,
          );

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
            child: const Icon(Icons.person_add_alt_outlined),
            label: 'Create User',
            onTap: () {
              _openAddUserBottomModal('student');
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.people_alt_outlined),
            label: 'Batch Creation',
            onTap: () {
              _openAddUserBottomModal('instructor');
            },
          ),
        ],
      ),
      body: content,
    );
  }
}
