import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linkedin_clone/core/themes/app_theme.dart';
import 'package:linkedin_clone/features/profile/presentation/pages/user_profile.dart';
import 'package:linkedin_clone/features/profile/presentation/provider/profile_provider.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()), // Provide ProfileProvider
      ],
      child: MaterialApp(
        title: 'TawasolApp',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: UserProfile(),
      ),
    );
  }
}
