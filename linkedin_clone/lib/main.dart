import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'features/feed/data/data_sources/feed_remote_data_source.dart';
import 'features/feed/data/repositories/feed_repository_impl.dart';
import 'features/feed/domain/repositories/feed_repository.dart';
import 'features/feed/presentation/pages/feed_page.dart'; // Add this import
import 'features/feed/presentation/provider/feed_provider.dart';

void main() {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com/v1'));
  final dataSource = FeedRemoteDataSourceImpl(dio);
  final repository = FeedRepositoryImpl(dataSource);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => FeedProvider(repository: repository), // Use abstract type
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
      title: 'LinkedIn Clone',
      home: Scaffold(
        appBar: AppBar(title: const Text('News Feed')),
        body: const FeedPage(), // Now recognizes the class
      ),
    );
  }
}
