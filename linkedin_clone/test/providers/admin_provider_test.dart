// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:linkedin_clone/core/errors/failures.dart';
// import 'package:linkedin_clone/features/admin_panel/domain/entities/user_analytics_entity.dart';
// import 'package:linkedin_clone/features/admin_panel/domain/entities/post_analytics_entity.dart';
// import 'package:linkedin_clone/features/admin_panel/domain/entities/job_analytics_entity.dart';
// import 'package:linkedin_clone/features/admin_panel/domain/entities/reported_post_entity.dart';
// import 'package:linkedin_clone/features/admin_panel/domain/entities/reported_user_entity.dart';
// import 'package:linkedin_clone/features/admin_panel/domain/usecases/get_user_analytics_usecase.dart';
// import 'package:linkedin_clone/features/admin_panel/domain/usecases/get_post_analytics_usecase.dart';
// import 'package:linkedin_clone/features/admin_panel/domain/usecases/get_job_analytics_usecase.dart';
// import 'package:linkedin_clone/features/admin_panel/domain/usecases/get_reported_posts_usecase.dart';
// import 'package:linkedin_clone/features/admin_panel/domain/usecases/get_reported_users_usecase.dart';
// import 'package:linkedin_clone/features/admin_panel/presentation/provider/admin_provider.dart';

// class MockGetUserAnalytics extends Mock implements GetUserAnalyticsUseCase {}

// class MockGetPostAnalytics extends Mock implements GetPostAnalyticsUseCase {}

// class MockGetJobAnalytics extends Mock implements GetJobAnalyticsUseCase {}

// class MockGetReportedPosts extends Mock implements FetchReportedPosts {}

// class MockGetReportedUsers extends Mock implements FetchReportedUsers {}

// void main() {
//   late AdminProvider provider;
//   late MockGetUserAnalytics mockUserAnalytics;
//   late MockGetPostAnalytics mockPostAnalytics;
//   late MockGetJobAnalytics mockJobAnalytics;
//   late MockGetReportedPosts mockReportedPosts;
//   late MockGetReportedUsers mockReportedUsers;

//   setUp(() {
//     mockUserAnalytics = MockGetUserAnalytics();
//     mockPostAnalytics = MockGetPostAnalytics();
//     mockJobAnalytics = MockGetJobAnalytics();
//     mockReportedPosts = MockGetReportedPosts();
//     mockReportedUsers = MockGetReportedUsers();

//     provider = AdminProvider(
//       getUserAnalyticsUseCase: mockUserAnalytics,
//       getPostAnalyticsUseCase: mockPostAnalytics,
//       getJobAnalyticsUseCase: mockJobAnalytics,
//       getReportedPostsUseCase: mockReportedPosts,
//       getReportedUsersUseCase: mockReportedUsers,
//       resolveReportUseCase: Mock(), // unused
//       getJobListingsUseCase: Mock(),
//       deleteJobListingUseCase: Mock(),
//       ignoreFlaggedJobUseCase: Mock(),
//       deleteReportedPostUseCase: Mock(),
//     );
//   });

//   /// Dummy data
//   final userAnalytics = UserAnalytics(
//     totalUsers: 100,
//     mostReportedUser: "u1",
//     userReportedCount: 5,
//     mostActiveUsers: [],
//   );
//   final postAnalytics = PostAnalytics(
//     totalPosts: 200,
//     totalComments: 150,
//     mostReactedPost: "p1",
//     mostCommentedPost: "p2",
//   );
//   final jobAnalytics = JobAnalytics(
//     totalJobs: 50,
//     mostAppliedCompany: 10,
//     mostAppliedJob: "c1",
//   );

//   final reportedPosts = [
//     ReportedPost(
//       id: 'r1',
//       postId: 'p1',
//       postContent: 'spam',
//       reportedBy: 'user1',
//       reason: 'Spam',
//       status: 'Pending',
//       reportedAt: DateTime.now(),
//       postAuthor: 'author',
//       postAuthorAvatar: null,
//       postAuthorRole: 'Engineer',
//       reporterAvatar: null,
//       postMedia: null,
//     ),
//   ];

//   final reportedUsers = [
//     ReportedUser(
//       id: 'u1',
//       reportedUser: 'offender',
//       reporterAvatar: null,
//       reportedUserAvatar: null,
//       reportedUserRole: 'Recruiter',
//       reportedBy: 'user2',
//       reason: 'Abuse',
//       status: 'Pending',
//       reportedAt: DateTime.now(),
//     ),
//   ];

//     test('fetchAnalytics - success', () async {
//     when(() => mockUserAnalytics()).thenAnswer((_) async => Right(userAnalytics));
//     when(() => mockPostAnalytics()).thenAnswer((_) async => Right(postAnalytics));
//     when(() => mockJobAnalytics()).thenAnswer((_) async => Right(jobAnalytics));

//     await provider.fetchAnalytics();

//     expect(provider.userAnalytics, userAnalytics);
//     expect(provider.postAnalytics, postAnalytics);
//     expect(provider.jobAnalytics, jobAnalytics);
//     expect(provider.errorMessage, isNull);
//   });
//   test('fetchAnalytics - failure', () async {
//     when(() => mockUserAnalytics()).thenAnswer((_) async => ServerFailure(message: 'User error'));
//     when(() => mockPostAnalytics()).thenAnswer((_) async => Left(ServerFailure('Post error')));
//     when(() => mockJobAnalytics()).thenAnswer((_) async => Left(ServerFailure(message: 'Job error')));

//     await provider.fetchAnalytics();

//     expect(provider.userAnalytics, isNull);
//     expect(provider.errorMessage, contains("User error"));
//   });

// }
