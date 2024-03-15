import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formarter = DateFormat.yMMMMd();

class MyDateHolder extends StatefulWidget {
  const MyDateHolder(
      {super.key, required this.onDateSelected, this.selectedDate});

  final Function(String) onDateSelected;
  final String? selectedDate;

  @override
  State<MyDateHolder> createState() => _MyDateHolderState();
}

class _MyDateHolderState extends State<MyDateHolder> {
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate ?? 'SELECT DATE';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openDatePicker,
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.primary)),
        child: Row(
          children: [
            Text(
              'Date:',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 6,
            ),
            Text(
              selectedDate!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            Icon(
              Icons.calendar_month_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _openDatePicker() async {
    final firstDate = DateTime(DateTime.now().year - 20);
    final lastDate = DateTime(DateTime.now().year + 50);

    final pickedDate = await showDatePicker(
        context: context, firstDate: firstDate, lastDate: lastDate);
    if (pickedDate == null) return;

    setState(() {
      selectedDate = formarter.format(pickedDate).toString();
      widget.onDateSelected(selectedDate!);
    });
  }
}
