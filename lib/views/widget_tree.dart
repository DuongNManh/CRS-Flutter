import 'package:flutter/material.dart';
import 'package:learning_android_1/data/constants.dart';
import 'package:learning_android_1/data/notifiers.dart';
import 'package:learning_android_1/data/theme_manager.dart';
import 'package:learning_android_1/views/pages/common/setting_page.dart';
import 'package:learning_android_1/views/pages/common/test_ui_page.dart';
import 'package:learning_android_1/views/pages/common/view_claims_page.dart';
import 'package:learning_android_1/views/pages/common/home_page.dart';
import 'package:learning_android_1/views/pages/common/profile_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter 1 Demo', style: AppTextStyle.h3),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: isDarkModeNotifier,
            builder: (context, value, child) {
              return IconButton(
                icon: Icon(value ? Icons.dark_mode : Icons.light_mode),
                onPressed: () {
                  ThemeManager.toggleTheme();
                },
              );
            },
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text('Drawer', style: AppTextStyle.h3),
            ),
            ListTile(
              title: Text('Test UI Page', style: AppTextStyle.bodyMedium),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestUiPage()),
                );
              },
            ),
            ListTile(
              title: Text('Item 2', style: AppTextStyle.bodyMedium),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          selectedPageNotifier.value = index;
        },
        children: _listWidget,
      ),
      floatingActionButton: Row(
        spacing: AppSpacing.md,
        mainAxisAlignment: MainAxisAlignment.end,
      ),
      bottomNavigationBar: ValueListenableBuilder<int>(
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
              _pageController.animateToPage(
                value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            selectedIndex: selectedPage,
          );
        },
      ),
    );
  }
}

List<Widget> _listWidget = [
  HomePage(),
  ViewClaimsPage(),
  ProfilePage(),
  TestUiPage(),
];
