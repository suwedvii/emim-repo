import 'package:flutter/material.dart';

class MyDropDownButton extends StatefulWidget {
  const MyDropDownButton({super.key, required this.items, required this.label});

  final List<String> items;
  final String label;

  @override
  State<StatefulWidget> createState() {
    return _MyDropDownButtonState();
  }
}

class _MyDropDownButtonState extends State<MyDropDownButton> {
  String? value;

  @override
  void initState() {
    super.initState();
    value = widget.items[0];
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('${widget.label}:'),
        const SizedBox(
          width: 8,
        ),
        DropdownButtonFormField(
          value: value,
          items: widget.items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: (item) {},
        ),
      ],
    );
  }
}
