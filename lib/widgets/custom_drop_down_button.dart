import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final List<String> items;
  final String value;
  final Function(String? value) onChanged;
  final String label;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  List<String>? items;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    items = ['Select ${widget.label}', ...widget.items];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        elevation: 8,
        itemHeight: 50,
        style: Theme.of(context).textTheme.bodyMedium,
        value: widget.value,
        items: widget.items.map((String item) {
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
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).colorScheme.onPrimary,
          labelText: widget.label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
