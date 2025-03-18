import 'package:flutter/material.dart';
import 'color_scheme.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: linkedinLightColorScheme,
    textTheme: linkedinTextTheme,
    useMaterial3: true,
    fontFamily: 'SourceSans',
    scaffoldBackgroundColor: linkedinLightColorScheme.surface,

    appBarTheme: AppBarTheme(
      backgroundColor: linkedinLightColorScheme.primary,
      elevation: 0,
      titleTextStyle: linkedinTextTheme.titleLarge?.copyWith(
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: linkedinLightColorScheme.surface,
      selectedItemColor: linkedinLightColorScheme.primary,
      unselectedItemColor: linkedinLightColorScheme.onSurfaceVariant,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: linkedinLightColorScheme.primary,
        foregroundColor: Colors.white,
        textStyle: linkedinTextTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        elevation: 0,
        disabledBackgroundColor: linkedinLightColorScheme.primary.withOpacity(
          0.5,
        ), // Fixed error
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: linkedinLightColorScheme.primary,
        textStyle: linkedinTextTheme.labelLarge,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: linkedinDarkColorScheme,
    textTheme: linkedinTextTheme,
    useMaterial3: true,
    fontFamily: 'SourceSans',
    scaffoldBackgroundColor: linkedinDarkColorScheme.surface,

    appBarTheme: AppBarTheme(
      backgroundColor: linkedinDarkColorScheme.primary,
      elevation: 0,
      titleTextStyle: linkedinTextTheme.titleLarge?.copyWith(
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: linkedinDarkColorScheme.surface,
      selectedItemColor: linkedinDarkColorScheme.primary,
      unselectedItemColor: linkedinDarkColorScheme.onSurfaceVariant,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: linkedinDarkColorScheme.primary,
        foregroundColor: Colors.white,
        textStyle: linkedinTextTheme.labelLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        elevation: 0,
        disabledBackgroundColor: linkedinDarkColorScheme.primary.withOpacity(
          0.5,
        ), // Fixed error
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: linkedinDarkColorScheme.primary,
        textStyle: linkedinTextTheme.labelLarge,
      ),
    ),
  );
}
