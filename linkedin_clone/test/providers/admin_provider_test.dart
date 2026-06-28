import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'package:linkedin_clone/features/admin_panel/presentation/provider/admin_provider.dart';
import 'package:linkedin_clone/features/admin_panel/domain/entities/reported_post_entity.dart';
import 'package:linkedin_clone/features/admin_panel/domain/entities/reported_user_entity.dart';
import 'package:linkedin_clone/features/admin_panel/domain/entities/user_analytics_entity.dart';
import 'package:linkedin_clone/features/admin_panel/domain/entities/post_analytics_entity.dart';
import 'package:linkedin_clone/features/admin_panel/domain/entities/job_analytics_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';

import 'package:linkedin_clone/features/admin_panel/domain/usecases/get_reported_posts_usecase.dart';
import 'package:linkedin_clone/features/admin_panel/domain/usecases/get_reported_users_usecase.dart';
import 'package:linkedin_clone/features/admin_panel/domain/usecases/resolve_report_usecase.dart';
import 'package:linkedin_clone/features/admin_panel/domain/usecases/delete_job_listing_usecase.dart';
import 'package:linkedin_clone/features/admin_panel/domain/usecases/get_user_analytics_usecase.dart';
import 'package:linkedin_clone/features/admin_panel/domain/usecases/get_post_analytics_usecase.dart';
import 'package:linkedin_clone/features/admin_panel/domain/usecases/get_job_analytics_usecase.dart';
import 'package:linkedin_clone/features/admin_panel/domain/usecases/ignore_flagged_job_usecase.dart';
import 'package:linkedin_clone/features/admin_panel/domain/usecases/get_job_listings_usecase.dart';
import 'package:linkedin_clone/features/admin_panel/domain/usecases/delete_reported_post.dart';

import 'package:linkedin_clone/core/errors/failures.dart';

class MockGetReportedPosts extends Mock implements FetchReportedPosts {}

class MockGetReportedUsers extends Mock implements FetchReportedUsers {}

class MockResolveReport extends Mock implements ResolveReportUseCase {}

class MockDeleteJob extends Mock implements DeleteJobListingUseCase {}

class MockGetUserAnalytics extends Mock implements GetUserAnalyticsUseCase {}

class MockGetPostAnalytics extends Mock implements GetPostAnalyticsUseCase {}

class MockGetJobAnalytics extends Mock implements GetJobAnalyticsUseCase {}

class MockIgnoreJob extends Mock implements IgnoreFlaggedJobUseCase {}

class MockGetJobs extends Mock implements GetJobListingsUseCase {}

class MockDeleteReportedPost extends Mock
    implements DeleteReportedPostUseCase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized(); // ADD THIS FIRST

  late AdminProvider provider;
  late MockGetReportedPosts getReportedPosts;
  late MockGetReportedUsers getReportedUsers;
  late MockResolveReport resolveReport;
  late MockDeleteJob deleteJob;
  late MockGetUserAnalytics getUserAnalytics;
  late MockGetPostAnalytics getPostAnalytics;
  late MockGetJobAnalytics getJobAnalytics;
  late MockIgnoreJob ignoreJob;
  late MockGetJobs getJobs;
  late MockDeleteReportedPost deleteReportedPost;

  setUp(() {
    getReportedPosts = MockGetReportedPosts();
    getReportedUsers = MockGetReportedUsers();
    resolveReport = MockResolveReport();
    deleteJob = MockDeleteJob();
    getUserAnalytics = MockGetUserAnalytics();
    getPostAnalytics = MockGetPostAnalytics();
    getJobAnalytics = MockGetJobAnalytics();
    ignoreJob = MockIgnoreJob();
    getJobs = MockGetJobs();
    deleteReportedPost = MockDeleteReportedPost();

    provider = AdminProvider(
      getReportedPostsUseCase: getReportedPosts,
      getReportedUsersUseCase: getReportedUsers,
      resolveReportUseCase: resolveReport,
      deleteJobListingUseCase: deleteJob,
      getUserAnalyticsUseCase: getUserAnalytics,
      getPostAnalyticsUseCase: getPostAnalytics,
      getJobAnalyticsUseCase: getJobAnalytics,
      ignoreFlaggedJobUseCase: ignoreJob,
      getJobListingsUseCase: getJobs,
      deleteReportedPostUseCase: deleteReportedPost,
    );
  });

  test('fetchReportedPosts should populate reportedPosts list', () async {
    when(
      () => getReportedPosts(status: any(named: 'status')),
    ).thenAnswer((_) async => [ReportedPost.fake()]);
    await provider.fetchReportedPosts();
    expect(provider.reportedPosts.length, 1);
  });

  test('fetchReportedUsers should populate reportedUsers list', () async {
    when(
      () => getReportedUsers(status: any(named: 'status')),
    ).thenAnswer((_) async => [ReportedUser.fake()]);
    await provider.fetchReportedUsers();
    expect(provider.reportedUsers.length, 1);
  });

  test('resolvePostReport should call use case and refresh', () async {
    when(
      () => resolveReport(
        reportId: any(named: 'reportId'),
        action: any(named: 'action'),
        comment: any(named: 'comment'),
      ),
    ).thenAnswer((_) async => Future.value());

    when(() => getReportedPosts(status: null)).thenAnswer((_) async => []);

    await provider.resolvePostReport("123", "Actioned");
    expect(provider.reportedPosts, isEmpty);
  });

  test('resolveUserReport should call use case and refresh', () async {
    when(
      () => resolveReport(
        reportId: any(named: 'reportId'),
        action: any(named: 'action'),
        comment: any(named: 'comment'),
      ),
    ).thenAnswer((_) async => Future.value());

    when(() => getReportedUsers(status: null)).thenAnswer((_) async => []);

    await provider.resolveUserReport("456", "Dismissed");
    expect(provider.reportedUsers, isEmpty);
  });

  test('fetchAnalytics should populate user, post, job analytics', () async {
    when(
      () => getUserAnalytics(),
    ).thenAnswer((_) async => Right(UserAnalytics.fake()));
    when(
      () => getPostAnalytics(),
    ).thenAnswer((_) async => Right(PostAnalytics.fake()));
    when(
      () => getJobAnalytics(),
    ).thenAnswer((_) async => Right(JobAnalytics.fake()));

    await provider.fetchAnalytics();

    expect(provider.userAnalytics, isNotNull);
    expect(provider.postAnalytics, isNotNull);
    expect(provider.jobAnalytics, isNotNull);
  });

  test('ignoreJob should remove job from list on success', () async {
    provider.jobListings = [Job.fake(id: '1')];
    when(() => ignoreJob("1")).thenAnswer((_) async => Right("ignored"));
    await provider.ignoreJob("1");
    expect(provider.jobListings.any((j) => j.id == "1"), false);
  });

  test('deleteJob should remove job from list on success', () async {
    provider.jobListings = [Job.fake(id: '2')];
    when(() => deleteJob("2")).thenAnswer((_) async => Right(unit));
    await provider.deleteJob("2");
    expect(provider.jobListings.any((j) => j.id == "2"), false);
  });
}
