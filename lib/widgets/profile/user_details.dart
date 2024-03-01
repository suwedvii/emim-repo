import 'package:emim/models/my_user.dart';
import 'package:emim/widgets/profile/detail_item.dart';
import 'package:emim/widgets/profile/details_holder.dart';
import 'package:flutter/material.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({super.key, required this.user, this.appBarTitle});

  final MyUser user;
  final String? appBarTitle;

  @override
  Widget build(BuildContext context) {
    final userMap = user.toMap();

    Widget content = SingleChildScrollView(
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 60,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Name: ${user.firstName} ${user.otherNames} ${user.lastName}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        'Role: ${user.role.toUpperCase()}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text('User ID: ${user.userId.toUpperCase()}',
                          style: Theme.of(context).textTheme.bodyLarge!),
                    ],
                  )
                ],
              ),
            ),
          ),
          DetailsHolder(
              userMap: userMap,
              holderTitle: 'contact details',
              holderItems: [
                DetailItem(description: user.title, title: 'Title'),
                DetailItem(description: user.gender, title: 'Gender'),
                DetailItem(description: user.emailAddress, title: 'Email'),
                DetailItem(description: user.nationality, title: 'Natonality'),
                DetailItem(
                    description: user.dateOfBirth, title: 'Date Of Birth'),
                DetailItem(
                    description: user.contactPostalAddress, title: 'Address'),
                DetailItem(
                    description: user.contactPhysicalAddress,
                    title: 'Village/Area'),
                DetailItem(description: user.contactTA, title: 'T/A'),
                DetailItem(
                    description: user.contactDistrict, title: 'District'),
              ]),
          DetailsHolder(
              userMap: userMap,
              holderTitle: 'home details',
              holderItems: [
                DetailItem(description: user.homeAddress, title: 'Address'),
                DetailItem(
                    description: user.homeVillage, title: 'Village/Area'),
                DetailItem(description: user.homeTA, title: 'T/A'),
                DetailItem(description: user.homeDistrict, title: 'District'),
              ]),
          DetailsHolder(
              userMap: userMap,
              holderTitle: 'next of kin details',
              holderItems: [
                DetailItem(description: user.nokName, title: 'Full Name'),
                DetailItem(
                    description: user.nokContactNumber, title: 'Phonr Number'),
                DetailItem(description: user.nokAddress, title: 'Address'),
                DetailItem(
                    description: user.nokPhysicalAddress,
                    title: 'Village/Area'),
                DetailItem(description: user.nokTa, title: 'T/A'),
                DetailItem(description: user.nokDistrict, title: 'District'),
                DetailItem(
                    description: user.relationshipWithNok,
                    title: 'Relationship'),
                DetailItem(
                    description: user.nokSourceOfIncome,
                    title: 'Source of Income'),
              ])
        ],
      ),
    );

    if (appBarTitle != null) {
      return content;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('User Details | ${user.firstName} ${user.lastName}'),
        ),
        body: content);
  }
}
