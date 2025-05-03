import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/application_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/get_applicants_use_case.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/update_application_status_use_case.dart';

class ApplicantsProvider with ChangeNotifier {
  final GetApplicantsUseCase getApplicantsUseCase;
  final UpdateApplicationStatusUseCase updateStatusUseCase;

  ApplicantsProvider({
    required this.getApplicantsUseCase,
    required this.updateStatusUseCase,
  });

  bool _isLoading = false;
  List<ApplicationEntity> _applications = [];
  String? _error;

  int _currentPage = 1;
  final int _limit = 5;
  bool _isAllLoaded = false;

  bool get isLoading => _isLoading;
  List<ApplicationEntity> get applications => _applications;
  String? get error => _error;
  bool get isAllLoaded => _isAllLoaded;

  //Fetch applicants (first load or refresh)
  Future<void> fetchApplicants(String jobId, {bool reset = false}) async {
    if (_isLoading) return;

    if (reset) {
      _currentPage = 1;
      _applications.clear();
      _isAllLoaded = false;
      notifyListeners();
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newApplicants = await getApplicantsUseCase(
        jobId,
        page: _currentPage,
        limit: _limit,
      );
      print("New Applicants: $newApplicants.name");

      if (newApplicants.isEmpty) {
        _isAllLoaded = true;
      } else {
        _applications.addAll(newApplicants);
        _currentPage++;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load more applicants (pagination)
  Future<void> loadMoreApplicants(String jobId) async {
    if (_isLoading || _isAllLoaded) return;

    await fetchApplicants(jobId);
  }

  void resetApplicants() {
    _applications.clear();
    _currentPage = 1;
    _isAllLoaded = false;
    _isLoading = false;
    _error = null;
    notifyListeners();
  }

  Future<bool> updateStatus(String applicationId, String newStatus) async {
    final success = await updateStatusUseCase(applicationId, newStatus);
    if (success) {
      // Update locally if successful
      final index = _applications.indexWhere(
        (app) => app.applicationId == applicationId,
      );
      if (index != -1) {
        _applications[index] = _applications[index].copyWith(status: newStatus);
        notifyListeners();
      }
    }
    return success;
  }
}
