import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/themes/app_theme.dart';
import 'package:linkedin_clone/features/profile/user_profile.dart'; // Import UserProfile

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TawasolApp',
      theme: AppTheme.lightTheme, // Set lightTheme as the theme
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: UserProfile(), // Set UserProfile as the home widget
    );
  }
}
