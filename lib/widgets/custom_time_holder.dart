import 'package:emim/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formater = DateFormat.jm();

class CustomTimeHolder extends StatefulWidget {
  const CustomTimeHolder(
      {super.key,
      required this.title,
      required this.onSelectTime,
      required this.hint,
      this.initialValue,
      this.keyboardInput});
  final String? title;
  final String hint;
  final String? initialValue;
  final TextInputType? keyboardInput;
  final Function(String selectedTime) onSelectTime;
  @override
  State<CustomTimeHolder> createState() => _CustomTimeHolderState();
}

class _CustomTimeHolderState extends State<CustomTimeHolder> {
  String? initialValue;

  @override
  void initState() {
    super.initState();
    initialValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openTimePicker();
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Row(children: [
          Text(
            '${widget.title!}:',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            width: 6,
          ),
          Text(initialValue ?? TimeOfDay.now().format(context)),
          const Spacer(),
          Icon(
            Icons.access_time,
            color: Theme.of(context).colorScheme.primary,
          ),
        ]),
      ),
    );
  }

  void _openTimePicker() async {
    final initialTime = widget.initialValue != null
        ? Constants().stringToTimeOfDay(widget.initialValue!)
        : TimeOfDay.now();
    final pickedTime =
        await showTimePicker(context: context, initialTime: initialTime);

    if (pickedTime == null) return;

    setState(() {
      initialValue = pickedTime.format(context);
      widget.onSelectTime(initialValue!);
    });
  }
}
