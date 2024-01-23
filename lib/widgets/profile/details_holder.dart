import 'package:emim/widgets/profile/update_contact_details.dart';
import 'package:flutter/material.dart';

class DetailsHolder extends StatelessWidget {
  const DetailsHolder(
      {super.key,
      required this.holderTitle,
      required this.holderItems,
      required this.userMap});

  final String holderTitle;
  final List<Widget> holderItems;
  final Map<String, dynamic> userMap;

  void _editContactDetails(BuildContext context, Map<String, dynamic> userMap) {
    final result = showModalBottomSheet<Map<String, dynamic>>(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) =>
          UpdateContactDetailsModal(user: userMap, detailCategory: holderTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                holderTitle.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  _editContactDetails(context, userMap);
                },
                child: const Text('Edit'),
              ),
            ],
          ),
          const Divider(height: 1),
          ...holderItems,
        ]),
      ),
    );
  }
}
