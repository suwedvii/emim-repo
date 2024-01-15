import 'package:flutter/material.dart';

class CampusMap extends StatefulWidget {
  const CampusMap({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _CampusMapState();
  }
}

class _CampusMapState extends State<CampusMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // Add your campus map-related UI components here
    );
  }
}
