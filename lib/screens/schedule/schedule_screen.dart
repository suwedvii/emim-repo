import 'package:emim/screens/schedule/add_schedule_bottom_modal.dart';
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
  Widget build(BuildContext context) {
    Widget content = Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _openAddScheduleScreen();
        },
        label: const Text('Add Schedule'),
        icon: const Icon(Icons.add_home_work_outlined),
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
}
