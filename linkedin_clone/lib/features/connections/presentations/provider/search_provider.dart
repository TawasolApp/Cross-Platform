// ignore_for_file: avoid_print, prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_all_companies.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:hive/hive.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/search_user_usecase.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/search_jobs_use_case.dart';

class SearchProvider with ChangeNotifier {
  SearchUserUsecase searchUserUseCase;
  GetAllCompaniesUseCase getAllCompaniesUseCase;
  SearchJobs searchJobsUseCase;
  var box = Hive.box('appBox');
  List<ConnectionsUserEntity> _searchResultsUsers = [];

  List<Company> _searchResultsCompanies = [];
  List<Job> _searchResultsJobs = [];
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
  List<ConnectionsUserEntity> get searchResultsUsers => _searchResultsUsers;
  List<Company> get searchResultsCompanies => _searchResultsCompanies;
  List<Job> get searchResultsJobs => _searchResultsJobs;

  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  // Constructor
  SearchProvider(
    this.searchUserUseCase,
    this.getAllCompaniesUseCase,
    this.searchJobsUseCase,
  );

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
    _searchResultsUsers.clear();
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

  Future<void> performSearchUser({
    bool isInitial = false,
    String? searchWord,
  }) async {
    _isLoading = true;
    if (_isBusy) return;
    _isBusy = true;
    try {
      _error = null;
      if (isInitial) {
        _currentPage = 1;
        _hasMore = true;
      } else {
        _currentPage++;
      }
      if (_currentPage == 1) {
        _searchResultsUsers = await searchUserUseCase.call(
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
          _searchResultsUsers.addAll(newSearchResultsUsers);
        }
      }
    } catch (e) {
      print('SearchProvider: performSearchUser $e\n');
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> performSearchCompany({
    bool isInitial = false,
    String? searchWord,
  }) async {
    _isLoading = true;
    if (_isBusy) return;
    _isBusy = true;
    try {
      _error = null;
      if (isInitial) {
        _currentPage = 1;
        _hasMore = true;
      } else {
        _currentPage++;
      }
      if (_currentPage == 1) {
        _searchResultsCompanies = await getAllCompaniesUseCase.execute(
          searchWord!,
          page: _currentPage,
          limit: 12,
        );
      } else {
        final newSearchResultsCompanies = await getAllCompaniesUseCase.execute(
          searchWord!,
          page: _currentPage,
          limit: 12,
        );
        if (newSearchResultsCompanies.isEmpty) {
          _hasMore = false;
        } else {
          _searchResultsCompanies.addAll(newSearchResultsCompanies);
        }
      }
    } catch (e) {
      print('SearchProvider: performSearchCompany $e\n');
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> performSearchJobs({
    bool isInitial = false,
    String? searchWord,
  }) async {
    _isLoading = true;
    if (_isBusy) return;
    _isBusy = true;
    try {
      _error = null;
      if (isInitial) {
        _currentPage = 1;
        _hasMore = true;
      } else {
        _currentPage++;
      }
      if (_currentPage == 1) {
        _searchResultsJobs = await searchJobsUseCase.call(
          keyword: searchWord!,
          page: _currentPage,
          limit: 12,
        );
      } else {
        final newSearchResultsJobs = await searchJobsUseCase.call(
          keyword: searchWord!,
          page: _currentPage,
          limit: 12,
        );
        if (newSearchResultsJobs.isEmpty) {
          _hasMore = false;
        } else {
          _searchResultsJobs.addAll(newSearchResultsJobs);
        }
      }
    } catch (e) {
      print('SearchProvider: performSearchJobs $e\n');
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isBusy = false;
      notifyListeners();
    }
  }
}
