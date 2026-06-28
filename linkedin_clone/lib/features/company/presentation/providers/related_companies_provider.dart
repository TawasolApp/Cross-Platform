import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_related_companies_usecase.dart';

class RelatedCompaniesProvider extends ChangeNotifier {
  final GetRelatedCompanies getRelatedCompaniesUseCase;
  String? companyId; 
  bool isAllLoaded = false;
  bool isLoading = false;
  List<Company> _relatedCompanies = [];
  int _currentPage = 1;
  final int _limit = 5;

  List<Company> get relatedCompanies => _relatedCompanies;
  bool get isLoadingState => isLoading;
  bool get allLoaded => isAllLoaded;

  RelatedCompaniesProvider({
    required this.getRelatedCompaniesUseCase,
  });
  void setCompanyId(String id) {
    companyId = id;
    resetProvider(); 
  }

  // Fetch related companies with pagination
  Future<void> fetchRelatedCompanies({int page = 1, int limit = 5}) async {
    if (companyId == null) {
      print('companyId is null, cannot fetch related companies.');
      return;
    }

    if (isAllLoaded || isLoading) return;

    isLoading = true;
    notifyListeners();

    try {
      final newCompanies = await getRelatedCompaniesUseCase.execute(
        companyId!, 
        page: page,
        limit: limit,
      );
      
      if (newCompanies.isEmpty) {
        isAllLoaded = true;
      }

      if (page == 1) {
        _relatedCompanies = newCompanies;
      } else {
        _relatedCompanies.addAll(newCompanies);
      }
    } catch (e) {
      print("Error fetching related companies: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreCompanies() async {
    if (isLoading || isAllLoaded || companyId == null) return;
      
    _currentPage++;
    await fetchRelatedCompanies(page: _currentPage, limit: _limit);
  }

  // Reset the provider
  void resetProvider() {
    _relatedCompanies.clear();
    _currentPage = 1;
    isAllLoaded = false;
    notifyListeners();
  }
}
