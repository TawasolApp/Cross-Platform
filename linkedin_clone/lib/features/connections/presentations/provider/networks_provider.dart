// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkedin_clone/features/connections/domain/entities/people_you_may_know_user_entity.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/block/block_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/block/get_blocked_list_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/block/unblock_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/follow_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/get_followers_count_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/get_following_list_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/get_followings_count_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow/unfollow_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_people_you_may_know_usecase.dart';
import '../../domain/entities/connections_user_entity.dart';
import '../../domain/usecases/follow/get_followers_list_usecase.dart';

class NetworksProvider with ChangeNotifier {
  bool _isBusy = false; // Tracks whether the provider is busy
  bool _isLoading = false; // Tracks whether data is loading
  String? _error; // Tracks the error message, if any
  int _currentPage = 1;
  bool _hasMore = true; // Indicates if there are more items to load
  int _followersCount = 0;
  int _followingsCount = 0;

  bool get isBusy => _isBusy;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  bool get hasError => _error != null;
  int get followersCount => _followersCount;
  int get followingsCount => _followingsCount;

  List<ConnectionsUserEntity>? followingList;
  List<ConnectionsUserEntity>? followersList;
  List<ConnectionsUserEntity>? blockedList;
  List<PeopleYouMayKnowUserEntity>? peopleYouMayKnowList;

  GetFollowingListUseCase getFollowingListUseCase;
  UnfollowUserUseCase unfollowUseCase;
  GetFollowersListUseCase getFollowersListUseCase;
  FollowUserUseCase followUseCase;
  GetBlockedListUseCase getBlockedListUseCase;
  BlockUserUseCase blockUserUseCase;
  UnblockUserUseCase unblockUserUseCase;
  GetPeopleYouMayKnowUseCase getPeopleYouMayKnowUseCase;
  GetFollowersCountUsecase getFollowersCountUsecase;
  GetFollowingsCountUsecase getFollowingsCountUsecase;

  NetworksProvider(
    this.getFollowingListUseCase,
    this.unfollowUseCase,
    this.getFollowersListUseCase,
    this.followUseCase,
    this.getBlockedListUseCase,
    this.blockUserUseCase,
    this.unblockUserUseCase,
    this.getPeopleYouMayKnowUseCase,
    this.getFollowersCountUsecase,
    this.getFollowingsCountUsecase,
  );

  Future<void> getFollowingList({bool isInitial = false}) async {
    if (_isBusy) return;
    _isBusy = true;
    try {
      getFollowingsCount();
      _isLoading = true;
      _error = null;
      if (isInitial) {
        _currentPage = 1;
        _hasMore = true;
      } else {
        _currentPage++;
      }
      if (_currentPage == 1) {
        followingList = await getFollowingListUseCase.call(
          page: _currentPage,
          limit: 15,
        );
      } else {
        final newFollowingList = await getFollowingListUseCase.call(
          page: _currentPage,
          limit: 15,
        );
        if (newFollowingList.isEmpty) {
          _hasMore = false;
        } else {
          followingList!.addAll(newFollowingList);
        }
      }
    } catch (e) {
      print('\nNetworksProvider: getFollowingList $e\n');
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> getFollowersList({bool isInitial = false}) async {
    if (_isBusy) return;
    _isBusy = true;
    try {
      getFollowersCount();
      _isLoading = true;
      _error = null;
      if (isInitial) {
        _currentPage = 1;
        _hasMore = true;
      } else {
        _currentPage++;
      }
      if (_currentPage == 1) {
        followersList = await getFollowersListUseCase.call(
          page: _currentPage,
          limit: 15,
        );
      } else {
        final newFollowersList = await getFollowersListUseCase.call(
          page: _currentPage,
          limit: 15,
        );
        if (newFollowersList.isEmpty) {
          _hasMore = false;
        } else {
          followersList!.addAll(newFollowersList);
        }
      }
    } catch (e) {
      print('\nNetworksProvider: getFollowersList $e\n');
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> getBlockedList({bool isInitial = false}) async {
    if (_isBusy) return;
    _isBusy = true;
    try {
      _isLoading = true;
      _error = null;
      if (isInitial) {
        _currentPage = 1;
        _hasMore = true;
      } else {
        _currentPage++;
      }
      if (_currentPage == 1) {
        blockedList = await getBlockedListUseCase.call(
          page: _currentPage,
          limit: 15,
        );
      } else {
        final newBlockedList = await getFollowersListUseCase.call(
          page: _currentPage,
          limit: 15,
        );
        if (newBlockedList.isEmpty) {
          _hasMore = false;
        } else {
          blockedList!.addAll(newBlockedList);
        }
      }
    } catch (e) {
      print('\nNetworksProvider: getBlockedList $e\n');
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> getPeopleYouMayKnowList({bool isInitial = false}) async {
    if (_isBusy) return;
    _isBusy = true;
    try {
      _isLoading = true;
      _error = null;
      if (isInitial) {
        _currentPage = 1;
        _hasMore = true;
      } else {
        _currentPage++;
      }
      if (_currentPage == 1) {
        peopleYouMayKnowList = await getPeopleYouMayKnowUseCase.call(
          page: _currentPage,
          limit: 16,
        );
      } else {
        final newPeopleYouMayKnowList = await getPeopleYouMayKnowUseCase.call(
          page: _currentPage,
          limit: 16,
        );
        if (newPeopleYouMayKnowList.isEmpty) {
          _hasMore = false;
        } else {
          peopleYouMayKnowList!.addAll(newPeopleYouMayKnowList);
        }
      }
    } catch (e) {
      print('\nNetworksProvider: getPeopleYouMayKnowList $e\n');
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isBusy = false;
      notifyListeners();
    }
  }

  void removePeopleyouMayKnowElement(String? userId) async {
    if (peopleYouMayKnowList != null) {
      peopleYouMayKnowList!.removeWhere((user) => user.userId == userId);
      notifyListeners();
    }
  }

  Future<bool> unfollowUser(String userId) async {
    try {
      // Call the unfollow use case here
      bool result = await unfollowUseCase.call(userId);
      if (result) getFollowingList(isInitial: true);
      return result;
    } catch (e) {
      print('\nNetworksProvider: unFollowUser $e\n');
      _error = e.toString();
      return false; // Return false if there was an error
    }
  }

  Future<bool> followUser(String userId) async {
    try {
      return await followUseCase.call(userId);
    } catch (e) {
      print('\nNetworksProvider: followUser $e\n');
      _error = e.toString();
      return false; // Return false if there was an error
    }
  }

  Future<bool> blockUser(String userId) async {
    print('Block user: $userId');
    try {
      return await unfollowUseCase.call(userId);
    } catch (e) {
      print('\nNetworksProvider: blockUser $e\n');
      _error = e.toString();
      return false; // Return false if there was an error
    }
  }

  Future<bool> unblockUser(String userId) async {
    try {
      return await followUseCase.call(userId);
    } catch (e) {
      print('\nNetworksProvider: unblockUser $e\n');
      _error = e.toString();
      return false; // Return false if there was an error
    }
  }

  Future<void> getFollowingsCount() async {
    try {
      _followingsCount = await getFollowingsCountUsecase.call();
    } catch (e) {
      print('\nNetworksProvider: getFollowingsCount $e\n');
      _error = e.toString();
      _followingsCount = -1; // Return -1 if there was an error
    } finally {
      notifyListeners();
    }
  }

  Future<void> getFollowersCount() async {
    try {
      print('Getting followers count...');
      _followersCount = await getFollowersCountUsecase.call();
    } catch (e) {
      print('\nNetworksProvider: getFollowersCount $e\n');
      _error = e.toString();
      _followersCount = -1; // Return -1 if there was an error
    } finally {
      notifyListeners();
    }
  }
}
