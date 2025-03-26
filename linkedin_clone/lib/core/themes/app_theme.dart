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
      titleTextStyle: linkedinTextTheme.titleLarge?.copyWith(color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: linkedinLightColorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: linkedinDarkColorScheme,
    textTheme: linkedinTextTheme,
    useMaterial3: true,
    fontFamily: 'SourceSans',
    scaffoldBackgroundColor: linkedinDarkColorScheme.surface,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: linkedinDarkColorScheme.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),
  );
}
