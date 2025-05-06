import 'package:flutter/foundation.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/repositories/job_repository.dart';

class JobDetailsProvider with ChangeNotifier {
  final JobRepository jobRepository;

  JobDetailsProvider(this.jobRepository);

  Job? _job;
  bool _isLoading = false;
  String? _error;

  Job? get job => _job;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchJob(String jobId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedJob = await jobRepository.getJobById(jobId);
      _job = fetchedJob;
    } catch (e) {
      print('❌ Error in provider: $e');
      _error = 'Failed to load job details';
      _job = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}
