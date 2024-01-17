import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextFormFiled extends StatefulWidget {
  MyTextFormFiled(
      {super.key,
      required this.onValidate,
      required this.onValueSaved,
      required this.label,
      this.inputType,
      this.enteredText,
      this.maxLines});

  final Function(String? value) onValueSaved;
  final Function(String? value) onValidate;
  final String label;
  final TextInputType? inputType;
  final int? maxLines;
  String? enteredText;

  @override
  State<MyTextFormFiled> createState() {
    return _MyTextFormFiledState();
  }
}

class _MyTextFormFiledState extends State<MyTextFormFiled> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          alignLabelWithHint: true,
          label: Text(widget.label),
          fillColor: Theme.of(context).colorScheme.onPrimary,
          filled: true,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          )),
      keyboardType: widget.inputType,
      maxLines: widget.maxLines,
      onSaved: (value) {
        widget.onValidate(value);
      },
      validator: (enteredValue) {
        return widget.onValidate(enteredValue);
      },
    );
  }
}
