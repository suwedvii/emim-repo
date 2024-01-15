import 'package:flutter/material.dart';

class Building {
  final String name;
  final List<String> rooms;

  Building({required this.name, required this.rooms});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Building> buildings = [
    Building(name: 'Building A', rooms: ['Room 1', 'Room 2', 'Room 3']),
    Building(name: 'Building B', rooms: ['Room 4', 'Room 5', 'Room 6']),
    Building(name: 'Building C', rooms: ['Room 7', 'Room 8', 'Room 9']),
  ];

  String selectedBuilding = '';
  String selectedRoom = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dropdown Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DropdownButton<String>(
                value: selectedBuilding,
                hint: Text('Select a building'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBuilding = newValue!;
                    selectedRoom = '';
                  });
                },
                items: buildings.map((Building building) {
                  return DropdownMenuItem<String>(
                    value: building.name,
                    child: Text(building.name),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedRoom,
                hint: Text('Select a room'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRoom = newValue!;
                  });
                },
                items: buildings
                    .firstWhere((building) => building.name == selectedBuilding)
                    .rooms
                    .map((room) {
                  return DropdownMenuItem<String>(
                    value: room,
                    child: Text(room),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
