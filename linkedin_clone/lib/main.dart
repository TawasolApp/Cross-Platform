import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/profile/user_profile.dart'; // Import UserProfile

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme,
      ),
      home: UserProfile(), // Set UserProfile as the home widget
    );
  }
}
