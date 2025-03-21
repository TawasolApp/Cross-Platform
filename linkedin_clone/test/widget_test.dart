// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter/material.dart';
// import 'package:linkedin_clone/main.dart';
// import 'package:linkedin_clone/features/feed/domain/usecases/get_posts_usecase.dart';
// import 'package:linkedin_clone/features/feed/data/repositories/feed_repository_impl.dart';
// import 'package:linkedin_clone/features/feed/data/data_sources/feed_remote_data_source.dart';
// import 'package:dio/dio.dart';
// import 'package:provider/provider.dart';

// void main() {
//   testWidgets('NewsFeedPage loads correctly', (WidgetTester tester) async {
//     // Mock dependencies
//     final dio = Dio();
//     final dataSource = FeedRemoteDataSourceImpl(dio);
//     final repository = FeedRepositoryImpl(dataSource);
//     final getPostsUseCase = GetPostsUseCase(repository);

//     // Wrap with Provider
//     await tester.pumpWidget(
//       MultiProvider(
//         providers: [Provider<GetPostsUseCase>.value(value: getPostsUseCase)],
//         child: MyApp(getPostsUseCase: getPostsUseCase),
//       ),
//     );

//     // Wait for the widget tree to build
//     await tester.pumpAndSettle();

//     // Check if News Feed page is loaded
//     expect(find.text('News Feed'), findsOneWidget);
//   });
// }
