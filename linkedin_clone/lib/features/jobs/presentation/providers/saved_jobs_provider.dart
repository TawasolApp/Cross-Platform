import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/jobs/domain/repositories/job_repository.dart';

class SavedJobsProvider with ChangeNotifier {
  final JobRepository repository;

  SavedJobsProvider({required this.repository});

  final Set<String> _savedJobIds = {};

  bool isSaved(String jobId) => _savedJobIds.contains(jobId);

  Future<void> toggleSave(String jobId) async {
    final alreadySaved = _savedJobIds.contains(jobId);

    final success =
        alreadySaved
            ? await repository.unsaveJob(jobId)
            : await repository.saveJob(jobId);

    if (success) {
      alreadySaved ? _savedJobIds.remove(jobId) : _savedJobIds.add(jobId);
      notifyListeners();
    }
  }

  void loadInitialSavedJobs(List<String> savedJobIds) {
    _savedJobIds.clear();
    _savedJobIds.addAll(savedJobIds);
    notifyListeners();
  }
}
