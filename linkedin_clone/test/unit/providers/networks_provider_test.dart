import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/domain/entities/people_you_may_know_user_entity.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/block/block_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/block/get_blocked_list_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/block/unblock_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/follow_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/get_followers_list_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/get_following_list_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/unfollow_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_people_you_may_know_usecase.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'networks_provider_test.mocks.dart';

@GenerateMocks([
  GetFollowingListUseCase,
  UnfollowUserUseCase,
  GetFollowersListUseCase,
  FollowUserUseCase,
  GetBlockedListUseCase,
  BlockUserUseCase,
  UnblockUserUseCase,
  GetPeopleYouMayKnowUseCase,
])
void main() {
  late NetworksProvider provider;
  late MockGetFollowingListUseCase mockGetFollowing;
  late MockUnfollowUserUseCase mockUnfollow;
  late MockGetFollowersListUseCase mockGetFollowers;
  late MockFollowUserUseCase mockFollow;
  late MockGetBlockedListUseCase mockGetBlockedList;
  late MockBlockUserUseCase mockBlockUser;
  late MockUnblockUserUseCase mockUnblockUser;
  late MockGetPeopleYouMayKnowUseCase mockPeopleYouMayKnow;

  setUp(() {
    mockGetFollowing = MockGetFollowingListUseCase();
    mockUnfollow = MockUnfollowUserUseCase();
    mockGetFollowers = MockGetFollowersListUseCase();
    mockFollow = MockFollowUserUseCase();
    mockGetBlockedList = MockGetBlockedListUseCase();
    mockBlockUser = MockBlockUserUseCase();
    mockUnblockUser = MockUnblockUserUseCase();
    mockPeopleYouMayKnow = MockGetPeopleYouMayKnowUseCase();

    provider = NetworksProvider(
      mockGetFollowing,
      mockUnfollow,
      mockGetFollowers,
      mockFollow,
      mockGetBlockedList,
      mockBlockUser,
      mockUnblockUser,
      mockPeopleYouMayKnow,
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

  test('getBlockedList handles errors', () async {
    when(
      mockGetBlockedList.call(page: anyNamed('page'), limit: anyNamed('limit')),
    ).thenThrow(Exception('Failed to load blocked users'));

    await provider.getBlockedList(isInitial: true);

    expect(provider.blockedList, isNull);
    expect(provider.hasError, true);
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

  test('blockUser returns false on error', () async {
    when(mockUnfollow.call('321')).thenThrow(Exception('error'));

    final result = await provider.blockUser('321');
    expect(result, false);
    expect(provider.hasError, true);
  });

  test('unblockUser returns true on success', () async {
    when(mockFollow.call('321')).thenAnswer((_) async => true);

    final result = await provider.unblockUser('321');
    expect(result, true);
    expect(provider.hasError, false);
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
}
