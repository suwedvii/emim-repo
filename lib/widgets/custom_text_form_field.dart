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
      this.maxLines,
      this.initialValue,
      this.onTap});

  final Function(String? value) onValueSaved;
  final Function(String? value) onValidate;
  final Function()? onTap;
  final String label;
  final TextInputType? inputType;
  final int? maxLines;
  String? enteredText;
  String? initialValue;

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
          border: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(
              Radius.circular(8),
            ),
          )),
      initialValue: widget.initialValue,
      keyboardType: widget.inputType,
      maxLines: widget.maxLines,
      onSaved: (value) {
        widget.onValueSaved(value);
      },
      validator: (enteredValue) {
        return widget.onValidate(enteredValue);
      },
      onTap: () {
        widget.onTap;
      },
    );
  }
}
