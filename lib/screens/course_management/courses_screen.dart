import 'package:emim/models/course.dart';
import 'package:emim/models/my_user.dart';
import 'package:emim/providers/courses_provider.dart';
import 'package:emim/providers/registration_provider.dart';
import 'package:emim/providers/user_provider.dart';
import 'package:emim/screens/course_management/student_registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {
  String? uid;
  List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('Oops, nothing here yet'),
    );

    final userData = ref.watch(userProvider(uid!));
    userData.when(
      loading: () {
        content = const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) => print(error.toString()),
      data: (user) {
        if (user.role.toLowerCase() == 'student') {
          final registrationData = ref.watch(
            studentRegistrationProvider(
              (uid: user.uid),
            ),
          );
          registrationData.when(
              error: (error, stackTrace) {
                print(error.toString());
              },
              data: (regstration) {
                if (regstration != null) {
                  final coursesData = regstration.registeredCourses;
                  coursesData!.then((studentCourses) {
                    courses = studentCourses;
                  });
                } else {
                  content = Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          'There are no courses regsistered for this semester, click "Register" to register for this semester!',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextButton.icon(
                            onPressed: () {
                              _gotToRegisterSemesterBottomSheet(user);
                            },
                            icon: const Icon(Icons.library_add_outlined),
                            label: const Text('Register'))
                      ],
                    ),
                  );
                }
              },
              loading: () {});
        } else {
          final courseData = ref.watch(coursesProvider);
          courseData.whenData((instructorCourses) {
            courses = instructorCourses
                .where((course) =>
                    course.instructor.toLowerCase() ==
                    ('${user.firstName} ${user.otherNames} ${user.lastName}')
                        .toLowerCase())
                .toList();
            print(courses.length);
          });
        }
      },
    );
    return Scaffold(
      body: courses.isEmpty
          ? content
          : ListView.builder(
              itemCount: courses.length,
              itemBuilder: ((context, index) => ListTile(
                    title: Text(courses[index].title),
                    subtitle: Text(courses[index].code),
                  )),
            ),
    );
  }

  void _gotToRegisterSemesterBottomSheet(MyUser user) {
    showModalBottomSheet(
      isDismissible: true,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => StudentRegistrationScreen(
        user: user,
      ),
    );
  }
}
