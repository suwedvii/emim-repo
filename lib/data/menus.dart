import 'package:emim/models/menu.dart';
import 'package:flutter/material.dart';

List<Menu> menus = const [
  Menu(
    id: 'menuItem1',
    title: "Profile",
    icon: Icon(
      Icons.person_3_outlined,
    ),
    color: Colors.purple,
  ),
  Menu(
    id: 'menuItem2',
    title: "Course Management",
    icon: Icon(Icons.library_books_outlined),
    color: Colors.red,
  ),
  Menu(
    id: 'menuItem3',
    title: "Assignments",
    icon: Icon(Icons.assignment_turned_in_outlined),
    color: Colors.orange,
  ),
  Menu(
    id: 'menuItem4',
    title: "Attendance",
    icon: Icon(Icons.calendar_month_outlined),
    color: Colors.amber,
  ),
  Menu(
    id: 'menuItem5',
    title: "Campus Map",
    icon: Icon(Icons.map_outlined),
    color: Colors.blue,
  ),
  Menu(
    id: 'menuItem6',
    title: "Communications",
    icon: Icon(Icons.message_outlined),
    color: Colors.pink,
  ),
  Menu(
    id: 'menuItem7',
    title: "Payments",
    icon: Icon(Icons.attach_money_outlined),
    color: Colors.green,
  ),
  Menu(
    id: 'menuItem8',
    title: "Reports",
    icon: Icon(Icons.add_chart_outlined),
    color: Colors.lightBlue,
  ),
  Menu(
    id: 'menuItem9',
    title: "Schedule",
    icon: Icon(Icons.schedule_outlined),
    color: Colors.lightGreen,
  ),
  Menu(
    id: 'menuItem10',
    title: "Settings",
    icon: Icon(Icons.settings),
    color: Colors.teal,
  ),
];
