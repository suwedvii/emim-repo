import 'package:flutter/material.dart';

class Menu {
  const Menu(
      {required this.id,
      required this.title,
      required this.icon,
      required this.color});

  final String id;
  final String title;
  final Icon icon;
  final Color color;
}
