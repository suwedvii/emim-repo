import 'package:flutter/material.dart';

class AddUserOptions extends StatelessWidget {
  const AddUserOptions(
      {super.key, required this.onUserTypeSelected, required this.ctx});

  final Function(String) onUserTypeSelected;
  final BuildContext ctx;

  @override
  Widget build(context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create a new:',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onUserTypeSelected('Student');
              },
              child: const Text('Student'),
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onUserTypeSelected('Instructor');
              },
              child: const Text('Instructor'),
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onUserTypeSelected('Accountant');
              },
              child: const Text('Accountant'),
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onUserTypeSelected('Administrator');
              },
              child: const Text('Administrator'),
            ),
          ],
        ),
      ),
    );
  }
}
