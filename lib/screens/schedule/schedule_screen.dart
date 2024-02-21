import 'package:emim/screens/schedule/add_schedule_bottom_modal.dart';
// import 'package:emim/screens/schedule/manage_rooms_screen.dart';
import 'package:emim/screens/schedule/room_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key, this.appBarTitle});

  final String? appBarTitle;

  @override
  ConsumerState<ScheduleScreen> createState() {
    return _ScheduleScreenState();
  }
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  void _goToManageRoomsScreem() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (ctx) =>
              // const ManageRoomsScreen(),
              const RoomManagementScreen()),
    );
  }

  void _openAddScheduleScreen(String mode) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => AddScheduleButtomModal(mode: mode),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Scaffold(
        floatingActionButton: SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      spacing: 5,
      overlayOpacity: 0.1,
      children: [
        SpeedDialChild(
            label: 'Add Makeup Class',
            child: const Icon(Icons.schedule_send),
            elevation: 2,
            onTap: () {
              _openAddScheduleScreen('makeup');
            }),
        SpeedDialChild(
            label: 'Add Normal Class',
            child: const Icon(Icons.schedule_outlined),
            elevation: 2,
            onTap: () {
              _openAddScheduleScreen('normal');
            }),
      ],
    ));

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
