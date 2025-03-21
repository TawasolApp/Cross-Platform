import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/feed/presentation/pages/feed_page.dart';
import '../features/feed/presentation/provider/feed_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FeedProvider()..fetchPosts(), // ✅ Uses Dummy Data
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LinkedIn Clone',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FeedPage(),
    );
  }
}
