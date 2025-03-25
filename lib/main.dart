import 'package:flutter/material.dart';
import 'package:learning_android_1/data/constants.dart';
import 'package:learning_android_1/data/notifiers.dart';
import 'package:learning_android_1/data/theme_manager.dart';
import 'package:learning_android_1/views/widget_tree.dart';
import 'package:learning_android_1/views/widgets/auth_guard.dart';

void main() async {
  // Ensure Flutter is initialized before accessing plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize theme from saved preferences
  await ThemeManager.initTheme();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const AuthGuard(child: WidgetTree()),
        );
      },
    );
  }
}
