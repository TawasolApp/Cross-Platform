import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_all_companies.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';

class CompanyListProvider extends ChangeNotifier {
  final GetAllCompanies getAllCompaniesUseCase;

  CompanyListProvider({required this.getAllCompaniesUseCase});

  List<Company> _companies = [];
  bool _isLoading = false;
  String? _error;

  List<Company> get companies => _companies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCompanies() async {
    print('hererere');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _companies = await getAllCompaniesUseCase.execute();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
