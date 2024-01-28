import 'package:emim/widgets/profile/update_contact_details.dart';
import 'package:emim/widgets/profile/update_home_details.dart';
import 'package:emim/widgets/profile/update_nok_details.dart';
import 'package:flutter/material.dart';

class DetailsHolder extends StatelessWidget {
  const DetailsHolder({
    super.key,
    required this.holderTitle,
    required this.holderItems,
    required this.userMap,
  });

  final String holderTitle;
  final List<Widget> holderItems;
  final Map<String, dynamic> userMap;

  void _editContactDetails(BuildContext context, Map<String, dynamic> userMap) {
    Widget updateScreen =
        UpdateContactDetailsModal(user: userMap, detailCategory: holderTitle);
    if (holderTitle == 'home details') {
      updateScreen = UpdateHomeDetailsModal(
        detailCategory: holderTitle,
        user: userMap,
      );
    } else if (holderTitle == 'next of kin details') {
      updateScreen = UpdateNokDetailsModal(
        detailCategory: holderTitle,
        user: userMap,
      );
    }

    showModalBottomSheet<Map<String, dynamic>>(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => updateScreen);
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
