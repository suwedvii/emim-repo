import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MyToggleSwitch extends StatefulWidget {
  const MyToggleSwitch(
      {super.key,
      this.title,
      this.maxWidth,
      this.minHeight,
      required this.labels,
      required this.onToggled});

  final String? title;
  final double? maxWidth;
  final double? minHeight;
  final List<String> labels;
  final Function(int index, String selectedItem) onToggled;

  @override
  State<MyToggleSwitch> createState() => _MyToggleSwitchState2();
}

class _MyToggleSwitchState2 extends State<MyToggleSwitch> {
  int initialSelectedUserIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.title != null)
          Column(
            children: [
              Text(
                widget.title!.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ToggleSwitch(
          cornerRadius: 8,
          radiusStyle: true,
          borderColor: [Theme.of(context).colorScheme.primary],
          borderWidth: 1,
          minWidth: widget.maxWidth != null
              ? ((widget.maxWidth! / widget.labels.length) / 2) - 6
              : double.infinity,
          fontSize: 16.0,
          initialLabelIndex: initialSelectedUserIndex,
          activeBgColor: [Theme.of(context).colorScheme.primary],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.white,
          inactiveFgColor: Colors.grey[900],
          totalSwitches: widget.labels.length,
          labels: widget.labels,
          onToggle: (index) {
            setState(() {
              initialSelectedUserIndex = index!;
            });
            widget.onToggled(index!, widget.labels[index]);
          },
        )
      ],
    );
  }
}
