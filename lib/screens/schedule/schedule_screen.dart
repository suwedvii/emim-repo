import 'package:emim/models/course_schedule.dart';
import 'package:emim/models/my_user.dart';
import 'package:emim/models/schedule.dart';
import 'package:emim/providers/course_schedules_provider.dart';
import 'package:emim/providers/user_provider.dart';
import 'package:emim/screens/schedule/add_schedule_bottom_modal.dart';
import 'package:emim/widgets/custom_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key, this.appBarTitle});

  final String? appBarTitle;

  @override
  ConsumerState<ScheduleScreen> createState() {
    return _ScheduleScreenState();
  }
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  List<CourseSchedule> schedules = [];
  String userUid = '';
  void _openAddScheduleScreen() {
    showModalBottomSheet(
      isDismissible: true,
      useSafeArea: true,
      elevation: 2,
      context: context,
      builder: (ctx) => const AddScheduleButtomModal(),
    );
  }

  @override
  void initState() {
    super.initState();
    userUid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    final scheduleData = ref.watch(schedulesProvider);
    final user =
        ref.watch(userProvider(FirebaseAuth.instance.currentUser!.uid));

    Widget content = Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _openAddScheduleScreen();
        },
        label: const Text('Add Schedule'),
        icon: const Icon(Icons.add_home_work_outlined),
      ),
      body: scheduleData.when(
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        data: (foundSchedules) {
          schedules = foundSchedules;
          return ListView.separated(
              itemBuilder: (context, index) => CustomCardWidget(
                    title: schedules[index].title,
                    subtitle: schedules[index].bulding,
                    trailing: schedules[index].startTime,
                  ),
              separatorBuilder: (ctx, index) => const Divider(),
              itemCount: schedules.length);
        },
      ),
    );

    if (widget.appBarTitle == null) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.appBarTitle}'),
      ),
    );
  }

  List<Schedule> getSchedules(AsyncValue user, List<Schedule> foundSchedules) {
    final lodgedUser = user as MyUser;
    List<Schedule> userSchedules = [];

    if (lodgedUser.role.toLowerCase() == 'admin') {
      userSchedules = foundSchedules;
    } else {
      for (final schedule in foundSchedules) {}
    }

    return userSchedules;
  }
}
