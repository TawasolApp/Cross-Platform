import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/domain/entities/user.dart';
import 'package:linkedin_clone/features/company/domain/usecases/add_admin_use_case.dart';
import 'package:linkedin_clone/features/company/domain/usecases/geta_all_company_admins.dart';

class CompanyAdminsProvider with ChangeNotifier {
  final AddAdminUseCase addAdminUseCase;
  final FetchCompanyAdminsUseCase fetchAdminsUseCase;

  bool isLoading = false;
  String errorMessage = '';
  List<User> companyAdmins = [];

  CompanyAdminsProvider({
    required this.addAdminUseCase,
    required this.fetchAdminsUseCase,
  });

  Future<void> fetchAdmins(String companyId) async {
    print('Fetching admins for company: $companyId');
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      companyAdmins = await fetchAdminsUseCase.execute(companyId);
    } catch (e) {
      errorMessage = 'Failed to load admins';
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
      await fetchAdmins(companyId); // Refresh after adding
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
