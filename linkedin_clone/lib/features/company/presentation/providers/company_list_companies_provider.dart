import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_all_companies.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';

class CompanyListProvider extends ChangeNotifier {
  final GetAllCompaniesUseCase getAllCompaniesUseCase;
  bool isAllLoaded = false;
  CompanyListProvider({required this.getAllCompaniesUseCase});

  List<Company> _companies = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1; // Track the current page
  final int _limit = 5; // Limit for pagination (5 companies per page)

  List<Company> get companies => _companies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch companies with query, page, and limit
  Future<void> fetchCompanies(
    String query, {
    int page = 1,
    int limit = 5,
  }) async {
    print('Fetching companies (Page: $page)...');
    if (isAllLoaded) return;
    // Set loading state to true
    _isLoading = true;
    _error = null;

    // Notify listeners after initiating the loading phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    try {
      // Fetch companies using the provided page and limit
      final newCompanies = await getAllCompaniesUseCase.execute(
        query,
        page: page,
        limit: limit,
      );
      if (newCompanies.isEmpty) {
        isAllLoaded = true;
      }
      if (page == 1) {
        // If it's the first page, replace the list of companies
        _companies = newCompanies;
      } else {
        // If it's not the first page, append the new companies to the list
        _companies.addAll(newCompanies);
      }
    } catch (e) {
      _error = e.toString();
    }

    // Set loading state to false
    _isLoading = false;

    // Notify listeners after data fetch is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  // Method to load more companies (increment the page)
  Future<void> loadMoreCompanies(String query) async {
    if (isAllLoaded) {
      return;
    }
    _isLoading = true;
    notifyListeners();
    _currentPage++; // Increment page number
    await fetchCompanies(
      query,
      page: _currentPage,
      limit: _limit,
    ); // Fetch companies for the new page
    _isLoading = false;
    notifyListeners();
  }

  // Reset the provider (clear companies, page, etc.)
  void resetProvider() {
    _companies.clear();
    _currentPage = 1;
    _error = null;
    isAllLoaded = false; // Reset the flag here

    notifyListeners();
  }
}
