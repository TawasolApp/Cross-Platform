// ignore_for_file: avoid_print, prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:hive/hive.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/search_user_usecase.dart';

class SearchProvider with ChangeNotifier {
  SearchUserUsecase searchUserUseCase;
  var box = Hive.box('appBox');
  List<ConnectionsUserEntity> searchResultsUsers = [];
  List<List<String>> recentSearchesUsers = [
    [],
    [],
    [],
    [],
  ]; //0 First name,1 last name 2 profilePicture, 3 userId
  List<String> recentSearchesWords = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _isBusy = false;
  bool _hasMore = true;
  String? _error;
  bool _isSearching = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
  bool get isSearching => _isSearching;
  bool get isBusy => _isBusy;
  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  // Constructor
  SearchProvider(this.searchUserUseCase);

  // Public Methods
  Future<void> getRecentsearches() async {
    recentSearchesUsers[0] =
        await box.get('recentSearchesUsersFirstName')?.cast<String>() ?? [];
    recentSearchesUsers[1] =
        await box.get('recentSearchesUsersLastName')?.cast<String>() ?? [];
    recentSearchesUsers[2] =
        await box.get('recentSearchesUsersProfilePicture')?.cast<String>() ??
        [];
    recentSearchesUsers[3] =
        await box.get('recentSearchesUserId')?.cast<String>() ?? [];
    recentSearchesWords =
        await box.get('recentSearchesWords')?.cast<String>() ?? [];
    notifyListeners();
  }

  Future<void> performSearch(String query) async {}

  void clearSearchResults() {
    searchResultsUsers.clear();
    notifyListeners();
  }

  void clearRecentSearches() {
    recentSearchesUsers[0].clear();
    recentSearchesUsers[1].clear();
    recentSearchesUsers[2].clear();
    recentSearchesUsers[3].clear();
    recentSearchesWords.clear();
    box.put('recentSearchesUsersFirstName', recentSearchesUsers[0]);
    box.put('recentSearchesUsersLastName', recentSearchesUsers[1]);
    box.put('recentSearchesUsersProfilePicture', recentSearchesUsers[2]);
    box.put('recentSearchesUserId', recentSearchesUsers[3]);
    box.put('recentSearchesWords', recentSearchesWords);
    notifyListeners();
  }

  void addToRecentSearchesUsers(ConnectionsUserEntity user) {
    if (!recentSearchesUsers[2].contains(user.userId)) {
      recentSearchesUsers[0].insert(0, user.firstName);
      recentSearchesUsers[1].insert(0, user.lastName);
      recentSearchesUsers[2].insert(0, user.profilePicture);
      recentSearchesUsers[3].insert(0, user.userId);

      box.put('recentSearchesUsersFirstName', recentSearchesUsers[0]);
      box.put('recentSearchesUsersLastName', recentSearchesUsers[1]);
      box.put('recentSearchesUsersProfilePicture', recentSearchesUsers[2]);
      box.put('recentSearchesUserId', recentSearchesUsers[3]);
    }
    notifyListeners();
  }

  void addToRecentSearchesWords(String word) {
    if (!recentSearchesWords.contains(word)) {
      recentSearchesWords.insert(0, word);
      box.put('recentSearchesWords', recentSearchesWords);
    }
    notifyListeners();
  }

  bool hasAlphanumeric(String input) {
    return RegExp(r'[a-zA-Z]').hasMatch(input) ||
        RegExp(r'[0-9]').hasMatch(input);
  }

  Future<void> preformSearch({
    bool isInitial = false,
    String? searchWord,
  }) async {
    _isLoading = true;
    if (_isBusy) return;
    _isBusy = true;
    try {
      print(
        '🏹🏹🏹🏹🏹preformSearch: preformSearch $searchWord $isSearching\n',
      );
      _error = null;
      if (isInitial) {
        _currentPage = 1;
        _hasMore = true;
      } else {
        _currentPage++;
      }
      if (_currentPage == 1) {
        searchResultsUsers = await searchUserUseCase.call(
          searchWord: searchWord,
          page: _currentPage,
          limit: 12,
        );
      } else {
        final newSearchResultsUsers = await searchUserUseCase.call(
          searchWord: searchWord,
          page: _currentPage,
          limit: 12,
        );
        if (newSearchResultsUsers.isEmpty) {
          _hasMore = false;
        } else {
          searchResultsUsers.addAll(newSearchResultsUsers);
        }
      }
    } catch (e) {
      print('preformSearch: preformSearch $e\n');
      _error = e.toString();
    } finally {
      print('🏹🏹🏹🏹🏹preformSearch: finally $searchResultsUsers\n');
      _isLoading = false;
      _isBusy = false;
      notifyListeners();
    }
  }
}
