import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/apply_for_job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/apply_for_job_use_case.dart';

class ApplyJobProvider with ChangeNotifier {
  final ApplyForJobUseCase applyForJobUseCase;

  ApplyJobProvider({required this.applyForJobUseCase});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> applyForJob(ApplyForJobEntity application) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await applyForJobUseCase(application);
      return success;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
  