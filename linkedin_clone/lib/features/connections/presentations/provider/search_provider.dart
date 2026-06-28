// ignore_for_file: avoid_print, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_all_companies.dart';
import 'package:linkedin_clone/features/connections/domain/entities/connections_user_entity.dart';
import 'package:hive/hive.dart';
import 'package:linkedin_clone/features/connections/domain/usecases/search_user_usecase.dart';
import 'package:linkedin_clone/features/connections/presentations/widgets/misc/connections_enums.dart';
import 'package:linkedin_clone/features/feed/domain/entities/post_entity.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/search_posts_usecase.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/search_jobs_use_case.dart';
import 'package:linkedin_clone/features/profile/domain/entities/profile.dart';
import 'package:linkedin_clone/features/profile/domain/usecases/profile/get_profile.dart';

class SearchProvider with ChangeNotifier {
  SearchUserUsecase searchUserUseCase;
  GetAllCompaniesUseCase getAllCompaniesUseCase;
  SearchPostsUseCase searchPostsUseCase;
  SearchJobs searchJobsUseCase;
  GetProfileUseCase getProfileUseCase;

  Profile? myProfile;
  var box = Hive.box('appBox');

  List<ConnectionsUserEntity> _searchResultsUsers = [];
  List<Company> _searchResultsCompanies = [];
  List<PostEntity> _searchResultsPosts = [];
  List<Job> _searchResultsJobs = [];

  List<List<String>> recentSearchesUsers = [[], [], [], []];
  List<String> recentSearchesWords = [];
  FilterType _filterType = FilterType.general;
  bool _isLoading = false;
  int _currentPageUsers = 1;
  int _currentPageCompanies = 1;
  int _currentPageJobs = 1;
  int _currentPagePosts = 1;
  bool _isBusy = false;
  bool _hasMoreUsers = true;
  bool _hasMoreJobs = true;
  bool _hasMoreCompanies = true;
  bool _hasMorePosts = true;
  String? _error;
  bool _isSearching = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get hasMoreUsers => _hasMoreUsers;
  bool get hasMoreJobs => _hasMoreJobs;
  bool get hasMoreCompanies => _hasMoreCompanies;
  bool get hasMorePosts => _hasMorePosts;
  int get currentPagePosts => _currentPagePosts;
  int get currentPageUsers => _currentPageUsers;
  int get currentPageCompanies => _currentPageCompanies;
  int get currentPageJobs => _currentPageJobs;
  bool get isSearching => _isSearching;
  bool get isBusy => _isBusy;
  List<ConnectionsUserEntity> get searchResultsUsers => _searchResultsUsers;
  List<Company> get searchResultsCompanies => _searchResultsCompanies;
  List<Job> get searchResultsJobs => _searchResultsJobs;
  List<PostEntity> get searchResultsPosts => _searchResultsPosts;
  FilterType get filterType => _filterType;
  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  set filterType(FilterType type) {
    _filterType = type;
    notifyListeners();
  }

  SearchProvider(
    this.searchUserUseCase,
    this.getAllCompaniesUseCase,
    this.searchJobsUseCase,
    this.searchPostsUseCase,
    this.getProfileUseCase,
  );

  Future<String> get userId async {
    final isCompany = await TokenService.getIsCompany();
    return isCompany == true
        ? await TokenService.getCompanyId() ?? ''
        : await TokenService.getUserId() ?? '';
  }

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
    _searchResultsCompanies.clear();
    _searchResultsPosts.clear();
    _searchResultsJobs.clear();
    notifyListeners();
  }

  void clearRecentSearches() {
    for (var list in recentSearchesUsers) {
      list.clear();
    }
    recentSearchesWords.clear();
    box.put('recentSearchesUsersFirstName', recentSearchesUsers[0]);
    box.put('recentSearchesUsersLastName', recentSearchesUsers[1]);
    box.put('recentSearchesUsersProfilePicture', recentSearchesUsers[2]);
    box.put('recentSearchesUserId', recentSearchesUsers[3]);
    box.put('recentSearchesWords', recentSearchesWords);
    notifyListeners();
  }

  void addToRecentSearchesUsers(ConnectionsUserEntity user) {
    if (!recentSearchesUsers[3].contains(user.userId)) {
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

  Future<String> getMyProfile() async {
    final result = await getProfileUseCase.call("");
    myProfile = result.fold((failure) => null, (profile) => profile);
    return userId;
  }

  Future<void> performSearchUser({
    bool isInitial = false,
    String? searchWord,
  }) async {
    _isLoading = true;
    while (_isBusy) await Future.delayed(const Duration(milliseconds: 100));
    _isBusy = true;
    try {
      _error = null;
      if (isInitial) {
        _currentPageUsers = 1;
        _hasMoreUsers = true;
      } else {
        _currentPageUsers++;
      }

      final results = await searchUserUseCase.call(
        searchWord: searchWord,
        page: _currentPageUsers,
        limit: 12,
      );

      if (_currentPageUsers == 1) {
        _searchResultsUsers = results;
      } else {
        if (results.isEmpty) {
          _hasMoreUsers = false;
        } else {
          _searchResultsUsers.addAll(results);
        }
      }
    } catch (e) {
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
    while (_isBusy) await Future.delayed(const Duration(milliseconds: 100));
    _isBusy = true;
    try {
      _error = null;
      if (isInitial) {
        _currentPageUsers = 1;
        _hasMoreCompanies = true;
      } else {
        _currentPageUsers++;
      }

      final results = await getAllCompaniesUseCase.execute(
        searchWord!,
        page: _currentPageUsers,
        limit: 12,
      );

      if (_currentPageUsers == 1) {
        _searchResultsCompanies = results;
      } else {
        if (results.isEmpty) {
          _hasMoreCompanies = false;
        } else {
          _searchResultsCompanies.addAll(results);
        }
      }
    } catch (e) {
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
    while (_isBusy) await Future.delayed(const Duration(milliseconds: 100));
    _isBusy = true;
    try {
      _error = null;
      if (isInitial) {
        _currentPageJobs = 1;
        _hasMoreJobs = true;
      } else {
        _currentPageJobs++;
      }

      final results = await searchJobsUseCase.call(
        keyword: searchWord!,
        page: _currentPageJobs,
        limit: 12,
      );

      if (_currentPageJobs == 1) {
        _searchResultsJobs = results;
      } else {
        if (results.isEmpty) {
          _hasMoreJobs = false;
        } else {
          _searchResultsJobs.addAll(results);
        }
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> performSearchPosts({
    bool isInitial = false,
    String? searchWord,
  }) async {
    _isLoading = true;
    while (_isBusy) await Future.delayed(const Duration(milliseconds: 100));
    _isBusy = true;
    try {
      _error = null;
      if (isInitial) {
        _currentPagePosts = 1;
        _hasMorePosts = true;
      } else {
        _currentPagePosts++;
      }

      final userId = await this.userId;
      final result = await searchPostsUseCase.call(
        companyId: userId,
        query: searchWord!,
        network: false,
        timeframe: "all",
        page: _currentPagePosts,
        limit: 12,
      );
      print("😡😡😡😡SearchProvider: performSearchPosts $result");

      result.fold((failure) => _error = failure.message, (posts) {
        if (_currentPagePosts == 1) {
          print("🤩🤩🤩🤩🤩SearchProvider: performSearchPosts $posts");
          _searchResultsPosts = posts;
          print(
            "😶‍🌫️😶‍🌫️😶‍🌫️😶‍🌫️😶‍🌫️😶‍🌫️SearchProvider: performSearchPosts $_searchResultsPosts",
          );
        } else {
          if (posts.isEmpty) {
            _hasMorePosts = false;
          } else {
            _searchResultsPosts.addAll(posts);
          }
        }
      });
    } catch (e) {
      _error = e.toString();
    } finally {
      print("SearchProvider: performSearchPosts $_searchResultsPosts");
      _isLoading = false;
      _isBusy = false;
      notifyListeners();
    }
  }
}
