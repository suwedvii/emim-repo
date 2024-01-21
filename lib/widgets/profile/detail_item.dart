import 'package:flutter/material.dart';

class DetailItem extends StatelessWidget {
  const DetailItem({super.key, required this.description, required this.title});
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Text(
          '$description:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
