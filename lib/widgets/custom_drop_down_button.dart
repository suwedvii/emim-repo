import 'package:emim/constants.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    this.value,
    required this.onChanged,
    required this.label,
  });

  final List<String> items;
  final String? value;
  final Function(String? value) onChanged;
  final String label;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> items = ['Select ${widget.label}', ...widget.items];
    return SizedBox(
      height: 55,
      child: DropdownButtonFormField<String>(
        // elevation: 8,
        itemHeight: 50,
        style: Theme.of(context).textTheme.bodyMedium,
        value: widget.value ?? items[0],
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item.toUpperCase()),
          );
        }).toList(),
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            widget.onChanged(value);
          });
        },
        validator: (value) {
          if (value == null ||
              value.trim().isEmpty ||
              value.contains('Select')) {
            return 'Please select a ${widget.label}';
          }
          return null;
        },
        decoration:
            Constants().dropDownInputDecoration(context, widget.label, null),
      ),
    );
  }
}
