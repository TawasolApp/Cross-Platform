import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../features/feed/data/data_sources/feed_remote_data_source.dart';
import '../features/feed/data/repositories/feed_repository_impl.dart';
import '../features/feed/domain/usecases/get_posts_usecase.dart';
import '../features/feed/domain/usecases/create_post_usecase.dart';
import '../features/feed/presentation/pages/feed_page.dart';
import '../features/feed/presentation/pages/create_post_page.dart';
import '../features/feed/presentation/provider/feed_provider.dart';

void main() {
  final dio = Dio();
  final remoteDataSource = FeedRemoteDataSourceImpl(dio);
  final repository = FeedRepositoryImpl(remoteDataSource: remoteDataSource);

  final getPostsUseCase = GetPostsUseCase(repository);
  final createPostUseCase = CreatePostUseCase(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => FeedProvider(
                getPostsUseCase: getPostsUseCase,
                createPostUseCase: createPostUseCase,
              )..fetchPosts(),
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
      routes: {'/create-post': (_) => const PostCreationPage()},
    );
  }
}
