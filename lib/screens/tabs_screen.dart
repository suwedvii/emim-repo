import 'package:emim/screens/assignments/assignments_screen.dart';
import 'package:emim/screens/campus_map/campus_map.dart';
import 'package:emim/screens/communication/chats_screen.dart';
import 'package:emim/screens/course_management/course_management_screen.dart';
import 'package:emim/screens/payments/payments.dart';
import 'package:emim/screens/profile/profile_screen.dart';
import 'package:emim/screens/reports/reports.dart';
import 'package:emim/screens/schedule/room_management_screen.dart';
import 'package:emim/screens/schedule/schedule_screen.dart';
import 'package:emim/screens/settings/settings.dart';
import 'package:emim/widgets/image_slider.dart';
import 'package:emim/widgets/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key, this.user});

  final User? user;

  @override
  State<StatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  final List<String> slideImages = [
    'assets/images/msg_slide_img_1.jpg',
    'assets/images/msg_slide_img_2.jpg',
    'assets/images/msg_slide_img_3.jpg',
    'assets/images/msg_slide_img_4.jpg',
    'assets/images/msg_slide_img_5.jpg',
  ];

  @override
  void initState() {
    super.initState();
    print(widget.user?.email);
  }

  int currentScreenIndex = 0;

  void _goToDrawerItem(String itemName) {
    Widget content = const TabsScreen();
    if (itemName == 'settings') {
      content = Settings(title: itemName);
    } else if (itemName == 'reports') {
      content = Reports(title: itemName);
    } else if (itemName == 'campus map') {
      content = CampusMap(title: itemName);
    } else if (itemName == 'room management') {
      content = const RoomManagementScreen();
    } else {
      content = Payments(title: itemName);
    }

    Navigator.pop(context);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => content),
    );
  }

  void _changeCurrentPageIndex(int index) {
    setState(() {
      currentScreenIndex = index;
    });
  }

  void _gotToProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const ProfileScreen(title: 'Profile'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = SingleChildScrollView(
      child: Column(
        children: [
          slideImages.isNotEmpty
              ? ImageSlider(slideImages: slideImages)
              : const Center(
                  child: Text('Nothing here yet!'),
                ),
          Divider(
            thickness: 3,
            height: 30,
            endIndent: 36,
            indent: 36,
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );

    var appBarTitle = 'eMiM - Dashboard';

    if (currentScreenIndex == 1) {
      content = const CourseScreen();
      appBarTitle = 'Course Management';
    } else if (currentScreenIndex == 2) {
      content = const ChatsScreen();
      appBarTitle = 'Communications';
    } else if (currentScreenIndex == 3) {
      content = const ScheduleScreen();
      appBarTitle = 'Schedule';
    } else if (currentScreenIndex == 4) {
      content = const AssignMentsScreen();
      appBarTitle = 'Assignments';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          IconButton(
            onPressed: _gotToProfile,
            icon: const Icon(Icons.person_2_outlined),
          ),
        ],
      ),
      drawer: MainDrawer(onItemTapped: _goToDrawerItem),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).colorScheme.background,
          unselectedItemColor: Theme.of(context).colorScheme.primaryContainer,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentScreenIndex,
          onTap: (index) => _changeCurrentPageIndex(index),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.house_outlined,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.library_books_outlined,
                ),
                label: 'Course'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_outlined,
                ),
                label: 'Charts'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.schedule,
                ),
                label: 'Schedule'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.assignment_outlined,
                ),
                label: 'Assignments'),
          ],
          backgroundColor: Theme.of(context).colorScheme.onBackground),
      body: GestureDetector(
        onTap: () {},
        child: content,
      ),
    );
  }
}
