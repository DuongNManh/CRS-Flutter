import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryLight = Colors.lightGreen;
  static const Color primaryDark = Colors.green;

  // Secondary Colors
  static const Color secondaryLight = Colors.blue;
  static const Color secondaryDark = Colors.blueAccent;

  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFFFF); // White
  static const Color backgroundDark = Color(0xFF121212); // Dark Gray

  // Surface Colors
  static const Color surfaceLight = Color(0xFFEEEEEE);
  static const Color surfaceDark = Color(0xFF424242);

  // Popup Colors
  static const Color popupLight = Color(0xFFE0E0E0);
  static const Color popupDark = Color(0xFF616161);

  // Text Colors
  static const Color textPrimaryLight = Colors.black;
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);

  // Error Colors
  static const Color errorLight = Colors.red;
  static const Color errorDark = Colors.redAccent;

  // Success Colors
  static const Color successLight = Colors.green;
  static const Color successDark = Colors.greenAccent;

  // Border Colors
  static const Color borderLight = Color(
    0xFF757575,
  ); // Darker gray for light theme
  static const Color borderDark = Color(
    0xFFE0E0E0,
  ); // Lighter gray for dark theme
}

class AppTextStyle {
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    letterSpacing: 0.15,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    letterSpacing: 0.25,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    letterSpacing: 0.4,
  );

  // Button Text
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.25,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.25,
  );

  // Input Text
  static const TextStyle input = TextStyle(fontSize: 16, letterSpacing: 0.15);

  static const TextStyle label = TextStyle(fontSize: 12, letterSpacing: 0.4);
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppRadius {
  static const double small = 4.0;
  static const double medium = 8.0;
  static const double large = 16.0;
  static const double xlarge = 24.0;
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      surfaceContainer: AppColors.backgroundLight,
      surface: AppColors.surfaceLight,
      error: AppColors.errorLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimaryLight,
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyle.h1.copyWith(color: AppColors.textPrimaryLight),
      displayMedium: AppTextStyle.h2.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      displaySmall: AppTextStyle.h3.copyWith(color: AppColors.textPrimaryLight),
      bodyLarge: AppTextStyle.bodyLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      bodyMedium: AppTextStyle.bodyMedium.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      bodySmall: AppTextStyle.bodySmall.copyWith(
        color: AppColors.textSecondaryLight,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: BorderSide(color: AppColors.borderLight, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: BorderSide(color: AppColors.borderLight, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: BorderSide(color: AppColors.errorLight, width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        disabledIconColor: AppColors.textSecondaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.black),
    ),
    cardTheme: CardTheme(
      color: AppColors.surfaceLight,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primaryLight,
      inactiveTrackColor: AppColors.textSecondaryLight,
      thumbColor: AppColors.primaryLight,
      overlayColor: AppColors.primaryLight.withOpacity(0.3),
      valueIndicatorColor: AppColors.primaryLight,
      valueIndicatorTextStyle: AppTextStyle.bodySmall.copyWith(
        color: AppColors.textPrimaryLight,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
      trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight; // Color when switch is on
        }
        return Colors.grey[300];
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight.withOpacity(
            0.5,
          ); // Color when switch is on
        }
        return Colors.black.withOpacity(0.12);
      }),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      indicatorColor: AppColors.primaryLight,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      backgroundColor: AppColors.surfaceLight,
      contentTextStyle: AppTextStyle.bodyMedium.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      closeIconColor: AppColors.textPrimaryLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.popupLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
    ),
    drawerTheme: DrawerThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppRadius.large),
          bottomRight: Radius.circular(AppRadius.large),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryLight,
        disabledBackgroundColor: AppColors.textSecondaryLight,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      surfaceContainer: AppColors.backgroundDark,
      surface: AppColors.surfaceDark,
      error: AppColors.errorDark,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: AppColors.textPrimaryDark,
      onError: Colors.black,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyle.h1.copyWith(color: AppColors.textPrimaryDark),
      displayMedium: AppTextStyle.h2.copyWith(color: AppColors.textPrimaryDark),
      displaySmall: AppTextStyle.h3.copyWith(color: AppColors.textPrimaryDark),
      bodyLarge: AppTextStyle.bodyLarge.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      bodyMedium: AppTextStyle.bodyMedium.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      bodySmall: AppTextStyle.bodySmall.copyWith(
        color: AppColors.textSecondaryDark,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: BorderSide(color: AppColors.borderDark, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: BorderSide(color: AppColors.borderDark, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: BorderSide(color: AppColors.primaryDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        borderSide: BorderSide(color: AppColors.errorDark, width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        disabledIconColor: AppColors.textSecondaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.white),
    ),
    cardTheme: CardTheme(
      color: AppColors.surfaceDark,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primaryDark,
      inactiveTrackColor: AppColors.textSecondaryDark,
      thumbColor: AppColors.primaryDark,
      overlayColor: AppColors.primaryDark.withOpacity(0.3),
      valueIndicatorColor: AppColors.primaryDark,
      valueIndicatorTextStyle: AppTextStyle.bodySmall.copyWith(
        color: AppColors.textPrimaryDark,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.white),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      indicatorColor: AppColors.primaryDark,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      backgroundColor: AppColors.surfaceDark,
      contentTextStyle: AppTextStyle.bodyMedium.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      closeIconColor: AppColors.textPrimaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.popupDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
    ),
    drawerTheme: DrawerThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppRadius.large),
          bottomRight: Radius.circular(AppRadius.large),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryDark,
        disabledBackgroundColor: AppColors.textSecondaryDark,
      ),
    ),
  );
}
