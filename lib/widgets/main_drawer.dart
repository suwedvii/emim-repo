import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onItemTapped});

  final Function(String) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.onPrimaryContainer,
                Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withOpacity(0.5),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Image.asset(
                'assets/images/msg_logo_full.png',
                width: 110,
                alignment: Alignment.center,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Campus Map'),
            onTap: () {
              onItemTapped('campus map');
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart_rounded),
            title: const Text('Reports'),
            onTap: () {
              onItemTapped('reports');
            },
          ),
          ListTile(
            leading: const Icon(Icons.currency_exchange_rounded),
            title: const Text('Payments'),
            onTap: () {
              onItemTapped('payments');
            },
          ),
          ListTile(
            leading: const Icon(Icons.room_preferences_outlined),
            title: const Text('Room Management'),
            onTap: () {
              onItemTapped('room management');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              onItemTapped('settings');
            },
          ),
        ],
      ),
    );
  }
}
