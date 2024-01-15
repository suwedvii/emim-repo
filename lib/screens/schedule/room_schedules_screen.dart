import 'package:flutter/material.dart';

class RoomSchedulesScreen extends StatelessWidget {
  const RoomSchedulesScreen({super.key, required this.room});

  final String room;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$room schedules'),
      ),
    );
  }
}
