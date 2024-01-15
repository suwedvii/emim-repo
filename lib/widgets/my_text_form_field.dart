import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyTextFormFiled extends StatefulWidget {
  MyTextFormFiled(
      {super.key,
      this.validator,
      required this.label,
      this.inputType,
      this.enteredText,
      this.maxLines});

  final Function(String? value)? validator;
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
  var inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: inputController,
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
      onSaved: (title) {
        setState(() {
          if (widget.enteredText == null) return;
          widget.enteredText = title;
        });
      },
      validator: (enteredValue) {
        return widget.validator!(enteredValue);
      },
    );
  }
}
