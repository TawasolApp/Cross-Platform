import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/domain/entities/user.dart';
import 'package:linkedin_clone/features/company/domain/usecases/add_admin_use_case.dart';
import 'package:linkedin_clone/features/company/domain/usecases/geta_all_company_admins.dart';
import 'package:linkedin_clone/features/company/domain/usecases/search_users_use_case.dart';

class CompanyAdminsProvider with ChangeNotifier {
  final AddAdminUseCase addAdminUseCase;
  final FetchCompanyAdminsUseCase fetchAdminsUseCase;
  final SearchUsersUseCase searchUsersUseCase;

  bool isLoading = false;
  String errorMessage = '';
  List<User> companyAdmins = [];
  List<User> users = [];

  int _currentPage = 1;
  final int _limit = 5;
  bool _isAllLoaded = false;
  String? _companyId;

  bool get allLoaded => _isAllLoaded;

  CompanyAdminsProvider({
    required this.addAdminUseCase,
    required this.fetchAdminsUseCase,
    required this.searchUsersUseCase
  });

 Future<void> searchUsers(String query) async {
    isLoading = true;
    notifyListeners();

    try {
      users = await searchUsersUseCase.execute(query);  
    } catch (e) {
      errorMessage = 'Failed to load users';
    }

    isLoading = false;
    notifyListeners();
  }





  Future<void> fetchAdmins(String companyId) async {
    print('Fetching admins for company: $companyId');
    isLoading = true;
    errorMessage = '';
    _companyId = companyId;
    _currentPage = 1;
    _isAllLoaded = false;
    notifyListeners();

    try {
      final fetchedAdmins = await fetchAdminsUseCase.execute(
        companyId,
        page: _currentPage,
        limit: _limit,
      );

      companyAdmins = fetchedAdmins;
      if(fetchedAdmins.isEmpty)
      {
        _isAllLoaded=true;
      }
    } catch (e) {
      errorMessage = 'Failed to load admins';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Load more admins
  Future<void> loadMoreAdmins() async {
    if (isLoading || _isAllLoaded || _companyId == null) return;

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      _currentPage++;
      final moreAdmins = await fetchAdminsUseCase.execute(
        _companyId!,
        page: _currentPage,
        limit: _limit,
      );

      if (moreAdmins.isEmpty || moreAdmins.length < _limit) {
        _isAllLoaded = true;
      }

      companyAdmins.addAll(moreAdmins);
    } catch (e) {
      errorMessage = 'Failed to load more admins';
      _currentPage--; // rollback the page number on failure
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAdmin(String userId, String companyId) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      await addAdminUseCase(userId, companyId);
      await fetchAdmins(companyId); // Refresh entire list
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
