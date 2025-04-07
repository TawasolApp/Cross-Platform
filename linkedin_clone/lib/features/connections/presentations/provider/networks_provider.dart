// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/follow_user_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/get_following_list_usecase.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/unfollow_user_usecase.dart';
import '../../domain/entities/connections_user_entity.dart';
import '../../domain/usecases/get_followers_list_usecase.dart';

class NetworksProvider with ChangeNotifier {
  bool _isBusy = false; // Tracks whether the provider is busy
  bool _isLoading = false; // Tracks whether data is loading
  String? _error; // Tracks the error message, if any
  int _currentPage = 1;
  bool _hasMore = true; // Indicates if there are more items to load

  bool get isBusy => _isBusy;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  bool get hasError => _error != null;

  List<ConnectionsUserEntity>? followingList;
  List<ConnectionsUserEntity>? followersList;

  GetFollowingListUseCase getFollowingListUseCase;
  UnfollowUserUseCase unfollowUseCase;
  GetFollowersListUseCase getFollowersListUseCase;
  FollowUserUseCase followUseCase;

  NetworksProvider(
    this.getFollowingListUseCase,
    this.unfollowUseCase,
    this.getFollowersListUseCase,
    this.followUseCase,
  );

  Future<void> getFollowingList({bool isInitial = false}) async {
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
    ///TODO azabtha for followers not following
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

  Future<bool> unfollowUser(String userId) async {
    try {
      // Call the unfollow use case here
      return await unfollowUseCase.call(userId);
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
}
