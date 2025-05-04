import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/domain/entities/people_you_may_know_user_entity.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/get_followers_count_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/get_followings_count_usecase.dart';
import 'package:linkedin_clone/features/privacy/domain/usecases/block_user_usecase.dart';
import 'package:linkedin_clone/features/privacy/domain/usecases/get_blocked_list_usecase.dart';
import 'package:linkedin_clone/features/privacy/domain/usecases/unblock_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/follow_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/get_followers_list_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/get_following_list_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/unfollow_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_people_you_may_know_usecase.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'networks_provider_test.mocks.dart';

// import 'networks_provider_test.mocks.dart';

@GenerateMocks([
  GetFollowingListUseCase,
  UnfollowUserUseCase,
  GetFollowersListUseCase,
  FollowUserUseCase,
  GetPeopleYouMayKnowUseCase,
  GetFollowersCountUsecase,
  GetFollowingsCountUsecase,
])
void main() {
  late NetworksProvider provider;
  late MockGetFollowingListUseCase mockGetFollowing;
  late MockUnfollowUserUseCase mockUnfollow;
  late MockGetFollowersListUseCase mockGetFollowers;
  late MockFollowUserUseCase mockFollow;
  late MockGetPeopleYouMayKnowUseCase mockPeopleYouMayKnow;
  late MockGetFollowersCountUsecase mockGetFollowersCount;
  late MockGetFollowingsCountUsecase mockGetFollowingsCount;
  setUp(() {
    mockGetFollowing = MockGetFollowingListUseCase();
    mockUnfollow = MockUnfollowUserUseCase();
    mockGetFollowers = MockGetFollowersListUseCase();
    mockFollow = MockFollowUserUseCase();
    mockPeopleYouMayKnow = MockGetPeopleYouMayKnowUseCase();
    mockGetFollowersCount = MockGetFollowersCountUsecase();
    mockGetFollowingsCount = MockGetFollowingsCountUsecase();

    provider = NetworksProvider(
      mockGetFollowing,
      mockUnfollow,
      mockGetFollowers,
      mockFollow,
      mockPeopleYouMayKnow,
      mockGetFollowersCount,
      mockGetFollowingsCount,
    );
  });

  test('initial values are correct', () {
    expect(provider.isBusy, false);
    expect(provider.isLoading, false);
    expect(provider.hasError, false);
    expect(provider.currentPage, 1);
    expect(provider.hasMore, true);
  });

  test('getFollowingList adds users correctly', () async {
    final users = [
      ConnectionsUserEntity(
        userId: '1',
        firstName: 'Mariam',
        lastName: 'Elsoufy',
        headLine: 'Engineer',
        time: '2023-10-01T12:00:00Z',
        profilePicture: '',
      ),
    ];

    when(
      mockGetFollowing.call(page: anyNamed('page'), limit: anyNamed('limit')),
    ).thenAnswer((_) async => users);

    await provider.getFollowingList(isInitial: true);

    expect(provider.followingList, isNotNull);
    expect(provider.followingList!.length, 1);
    expect(provider.hasError, false);
  });

  test('getFollowersList adds users correctly', () async {
    final users = [
      ConnectionsUserEntity(
        userId: '2',
        firstName: 'Salma',
        lastName: 'Mostafa',
        headLine: 'Designer',
        time: '2023-10-01T12:00:00Z',
        profilePicture: '',
      ),
    ];

    when(
      mockGetFollowers.call(page: anyNamed('page'), limit: anyNamed('limit')),
    ).thenAnswer((_) async => users);

    await provider.getFollowersList(isInitial: true);

    expect(provider.followersList, isNotNull);
    expect(provider.followersList!.length, 1);
    expect(provider.hasError, false);
  });

  test('getPeopleYouMayKnowList loads successfully', () async {
    final users = [
      PeopleYouMayKnowUserEntity(
        userId: '3',
        firstName: 'Ahmed',
        lastName: 'Ali',
        headLine: 'Dev',
        profileImageUrl: '',
        headerImageUrl: '',
      ),
    ];

    when(
      mockPeopleYouMayKnow.call(
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      ),
    ).thenAnswer((_) async => users);

    await provider.getPeopleYouMayKnowList(isInitial: true);

    expect(provider.peopleYouMayKnowList, isNotNull);
    expect(provider.peopleYouMayKnowList!.length, 1);
  });

  test('followUser returns true on success', () async {
    when(mockFollow.call('123')).thenAnswer((_) async => true);
    final result = await provider.followUser('123');
    expect(result, true);
  });

  test('unfollowUser returns false on error', () async {
    when(mockUnfollow.call('123')).thenThrow(Exception('error'));

    final result = await provider.unfollowUser('123');
    expect(result, false);
    expect(provider.hasError, true);
  });

  test('removePeopleyouMayKnowElement removes user by ID', () {
    provider.peopleYouMayKnowList = [
      PeopleYouMayKnowUserEntity(
        userId: '10',
        firstName: 'Remove',
        lastName: 'Me',
        headLine: '',
        profileImageUrl: '',
        headerImageUrl: '',
      ),
    ];

    provider.removePeopleyouMayKnowElement('10');
    expect(provider.peopleYouMayKnowList!.isEmpty, true);
  });

  test('getFollowersCount sets count correctly on success', () async {
    const expectedCount = 42;

    when(mockGetFollowersCount.call()).thenAnswer((_) async => expectedCount);

    await provider.getFollowersCount();

    expect(provider.followersCount, expectedCount);
    expect(provider.isLoading, false);
    expect(provider.hasError, false);
  });

  test('getFollowersCount sets count to -1 on error', () async {
    when(
      mockGetFollowersCount.call(),
    ).thenThrow(Exception('Failed to get followers count'));

    await provider.getFollowersCount();

    expect(provider.followersCount, -1);
    expect(provider.isLoading, false);
    expect(provider.hasError, true);
  });

  test('getFollowingsCount sets count correctly on success', () async {
    const expectedCount = 35;

    when(mockGetFollowingsCount.call()).thenAnswer((_) async => expectedCount);

    await provider.getFollowingsCount();

    expect(provider.followingsCount, expectedCount);
    expect(provider.isLoading, false);
    expect(provider.hasError, false);
  });

  test('getFollowingsCount sets count to -1 on error', () async {
    when(
      mockGetFollowingsCount.call(),
    ).thenThrow(Exception('Failed to get followings count'));

    await provider.getFollowingsCount();

    expect(provider.followingsCount, -1);
    expect(provider.isLoading, false);
    expect(provider.hasError, true);
  });
}
