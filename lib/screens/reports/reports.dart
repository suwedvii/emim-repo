import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  const Reports({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Reports> createState() {
    return _ReportsState();
  }
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // Add your report-related UI components here
    );
  }
}
