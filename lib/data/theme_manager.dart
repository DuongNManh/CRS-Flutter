import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learning_android_1/data/notifiers.dart';

class ThemeManager {
  static const String _isDarkModeKey = 'is_dark_mode';

  // Initialize theme from saved preferences
  static Future<void> initTheme() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool savedDarkMode = prefs.getBool(_isDarkModeKey) ?? false;

      // Update the ValueNotifier with the saved theme
      isDarkModeNotifier.value = savedDarkMode;
    } catch (e) {
      debugPrint('Error loading theme preference: $e');
      // Default to light theme in case of error
      isDarkModeNotifier.value = false;
    }
  }

  // Save theme preference when it changes
  static Future<void> saveThemeMode(bool isDarkMode) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isDarkModeKey, isDarkMode);
    } catch (e) {
      debugPrint('Error saving theme preference: $e');
    }
  }

  // Toggle theme and save the new preference
  static Future<void> toggleTheme() async {
    // Toggle the theme
    isDarkModeNotifier.value = !isDarkModeNotifier.value;

    // Save the new preference
    await saveThemeMode(isDarkModeNotifier.value);
  }
}
