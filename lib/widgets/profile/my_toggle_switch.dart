import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MyToggleSwitch extends StatefulWidget {
  const MyToggleSwitch(
      {super.key,
      required this.title,
      this.minWidth,
      required this.labels,
      required this.totalSwitches,
      required this.onToggled});

  final String title;
  final double? minWidth;
  final int totalSwitches;
  final List<String> labels;
  final Function(int index) onToggled;

  @override
  State<MyToggleSwitch> createState() => _MyToggleSwitchState();
}

class _MyToggleSwitchState extends State<MyToggleSwitch> {
  int initialSelectedUserIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title.toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        ToggleSwitch(
          cornerRadius: 8,
          radiusStyle: true,
          borderColor: [Theme.of(context).colorScheme.primary],
          borderWidth: 1,
          minWidth: widget.minWidth ?? 360 / widget.totalSwitches,
          minHeight: 60.0,
          fontSize: 16.0,
          initialLabelIndex: initialSelectedUserIndex,
          activeBgColor: [Theme.of(context).colorScheme.primary],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.white,
          inactiveFgColor: Colors.grey[900],
          totalSwitches: widget.totalSwitches,
          labels: widget.labels,
          onToggle: (index) {
            widget.onToggled(index!);
            initialSelectedUserIndex = index;
          },
        ),
      ],
    );
  }
}