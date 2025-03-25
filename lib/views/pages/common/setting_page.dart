import 'package:flutter/material.dart';
import 'package:learning_android_1/data/constants.dart';
import 'package:learning_android_1/data/notifiers.dart';
import 'package:learning_android_1/data/theme_manager.dart';
import 'package:learning_android_1/views/pages/common/login_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyle.h3),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: AppTextStyle.h2),
            SizedBox(height: AppSpacing.lg),

            // Theme Toggle
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Appearance', style: AppTextStyle.h3),
                    SizedBox(height: AppSpacing.sm),
                    ValueListenableBuilder<bool>(
                      valueListenable: isDarkModeNotifier,
                      builder: (context, isDarkMode, child) {
                        return SwitchListTile.adaptive(
                          title: Text(
                            'Dark Mode',
                            style: AppTextStyle.bodyMedium,
                          ),
                          subtitle: Text(
                            'Change the app theme to dark or light mode',
                            style: AppTextStyle.bodySmall,
                          ),
                          value: isDarkMode,
                          onChanged: (value) {
                            ThemeManager.toggleTheme();
                          },
                          secondary: Icon(
                            isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppSpacing.lg),

            // Logout
            Card(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Account', style: AppTextStyle.h3),
                    SizedBox(height: AppSpacing.sm),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout', style: AppTextStyle.bodyMedium),
                      subtitle: Text(
                        'Sign out from your account',
                        style: AppTextStyle.bodySmall,
                      ),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
