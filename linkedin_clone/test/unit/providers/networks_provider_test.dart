import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_followers_list_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_following_list_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/unfollow_user_usecase.dart';
import 'package:linkedin_clone/features/connections/presentations/provider/networks_provider.dart';
import 'package:mockito/mockito.dart';
import 'networks_provider_test.mocks.dart';

@GenerateMocks([
  GetFollowingListUseCase,
  UnfollowUserUseCase,
  GetFollowersListUseCase,
  FollowUserUseCase,
])
void main() {
  late NetworksProvider provider;
  late MockGetFollowingListUseCase mockGetFollowing;
  late MockUnfollowUserUseCase mockUnfollow;
  late MockGetFollowersListUseCase mockGetFollowers;
  late MockFollowUserUseCase mockFollow;

  setUp(() {
    mockGetFollowing = MockGetFollowingListUseCase();
    mockUnfollow = MockUnfollowUserUseCase();
    mockGetFollowers = MockGetFollowersListUseCase();
    mockFollow = MockFollowUserUseCase();

    provider = NetworksProvider(
      mockGetFollowing,
      mockUnfollow,
      mockGetFollowers,
      mockFollow,
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
    expect(provider.isBusy, false);
    expect(provider.isLoading, false);
    expect(provider.hasError, false);
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
}
