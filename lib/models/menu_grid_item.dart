import 'package:emim/models/menu.dart';
import 'package:flutter/material.dart';

class MenuGridItem extends StatelessWidget {
  const MenuGridItem(
      {super.key, required this.menu, required this.onMenuSelected});

  final Menu menu;
  final Function(BuildContext, String) onMenuSelected;

  @override
  Widget build(context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          onMenuSelected(context, menu.title);
        },
        splashColor: const Color.fromARGB(255, 255, 255, 255),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                menu.color.withOpacity(0.55),
                menu.color.withOpacity(0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  menu.icon.icon,
                  size: 50,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                const SizedBox(height: 10),
                Text(
                  menu.title,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
