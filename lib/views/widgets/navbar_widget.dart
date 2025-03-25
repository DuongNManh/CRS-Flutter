import 'package:flutter/material.dart';
import 'package:learning_android_1/data/notifiers.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        return NavigationBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.home,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.view_list,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              label: 'Your Claims',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.account_box,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              label: 'Profile',
            ),
          ],
          onDestinationSelected: (int value) {
            selectedPageNotifier.value = value;
          },
          selectedIndex: selectedPage,
        );
      },
    );
  }
}
