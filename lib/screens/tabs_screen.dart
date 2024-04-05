import 'package:emim/models/my_user.dart';
import 'package:emim/providers/registration_provider.dart';
import 'package:emim/providers/user_provider.dart';
import 'package:emim/screens/assignments/assignments_screen.dart';
import 'package:emim/screens/campus_map/campus_map.dart';
import 'package:emim/screens/communication/chats_screen.dart';
import 'package:emim/screens/course_management/courses_screen.dart';
import 'package:emim/screens/course_management/program_management_screen.dart';
import 'package:emim/screens/payments/payments.dart';
import 'package:emim/screens/profile/profile_screen.dart';
import 'package:emim/screens/reports/reports.dart';
import 'package:emim/screens/room_management/room_management_screen.dart';
import 'package:emim/screens/schedule/schedule_screen.dart';
import 'package:emim/screens/settings/settings.dart';
import 'package:emim/widgets/image_slider.dart';
import 'package:emim/widgets/main_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  final List<String> slideImages = [
    'assets/images/msg_slide_img_1.jpg',
    'assets/images/msg_slide_img_2.jpg',
    'assets/images/msg_slide_img_3.jpg',
    'assets/images/msg_slide_img_4.jpg',
    'assets/images/msg_slide_img_5.jpg',
  ];

  bool isLoading = true;
  // Future<MyUser>? lodgedUser;
  String? userUid;

  var appBarTitle = 'Dashboard';

  int currentScreenIndex = 0;

  @override
  void initState() {
    userUid = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
    // lodgedUser = _getUserById();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final regdata = ref.watch(
      studentRegistrationProvider(
        (uid: userUid!),
      ),
    );
    print(regdata.value.toString());
    Widget content = const Scaffold(
      body: Center(
        child: Text('Oops, Nothing here yet'),
      ),
    );
    final AsyncValue data = ref.watch(userProvider(userUid!));
    data.when(loading: () {
      content = const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }, error: (error, stackTrace) {
      Future.delayed(const Duration(seconds: 5));
      print(error.toString());
      content = Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.onPrimary
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/msg_logo_full.png',
                  width: 100,
                ),
                const SizedBox(
                  height: 8,
                ),
                const CircularProgressIndicator()
              ],
            ),
          ),
        ),
      );
    }, data: (data) {
      final user = data as MyUser;
      content = Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            actions: [
              IconButton(
                onPressed: () {
                  _gotToProfile(user);
                },
                icon: const Icon(Icons.person_2_outlined),
              ),
            ],
          ),
          drawer: MainDrawer(onItemTapped: _goToDrawerItem),
          bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Theme.of(context).colorScheme.background,
              unselectedItemColor:
                  Theme.of(context).colorScheme.primaryContainer,
              type: BottomNavigationBarType.fixed,
              currentIndex: currentScreenIndex,
              onTap: (index) => _changeCurrentPageIndex(index, user),
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
          body: _getContent(user));
    });
    return content;
  }

  Widget _getContent(MyUser user) {
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
          ),
          Text(user.emailAddress),
        ],
      ),
    );

    if (currentScreenIndex == 1) {
      if (user.role.toLowerCase() == 'admin') {
        content = ProgramManagementScreen(
          user: user,
        );
        // appBarTitle = 'Program Management';
      } else {
        content = const CoursesScreen();
        // appBarTitle = 'Courses';
      }
    } else if (currentScreenIndex == 2) {
      content = const ChatsScreen();
      // appBarTitle = 'Communications';
    } else if (currentScreenIndex == 3) {
      content = const ScheduleScreen();
      // appBarTitle = 'Schedule';
    } else if (currentScreenIndex == 4) {
      content = const AssignMentsScreen();
      // appBarTitle = 'Assignments';
    }

    return content;
  }

  void _goToDrawerItem(String itemName) {
    Widget content = const TabsScreen();
    if (itemName == 'settings') {
      content = Settings(title: itemName);
    } else if (itemName == 'reports') {
      content = Reports(title: itemName);
    } else if (itemName == 'campus map') {
      content = CampusMap(appBarTitle: itemName);
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

  void _changeCurrentPageIndex(int index, MyUser user) {
    setState(() {
      currentScreenIndex = index;
      if (currentScreenIndex == 0) {
        appBarTitle = 'Dashboard';
      } else if (currentScreenIndex == 1) {
        if (user.role.toLowerCase() == 'admin') {
          appBarTitle = 'Program Management';
        } else {
          appBarTitle = 'Courses';
        }
      } else if (currentScreenIndex == 2) {
        appBarTitle = 'Communications';
      } else if (currentScreenIndex == 3) {
        appBarTitle = 'Schedule';
      } else if (currentScreenIndex == 4) {
        appBarTitle = 'Assignments';
      }
    });
  }

  void _gotToProfile(MyUser user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ProfileScreen(title: 'Profile', user: user),
      ),
    );
  }
}
