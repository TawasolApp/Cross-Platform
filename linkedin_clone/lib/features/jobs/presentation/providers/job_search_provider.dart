import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/jobs/domain/entities/job_entity.dart';
import 'package:linkedin_clone/features/jobs/domain/usecases/search_jobs_use_case.dart';

class JobSearchProvider extends ChangeNotifier {
  final SearchJobs searchJobs;

  JobSearchProvider({required this.searchJobs});

  List<Job> _jobs = [];
  List<Job> get jobs => _jobs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAllLoaded = false;
  bool get isAllLoaded => _isAllLoaded;

  String? keyword;
  String? location;
  String? industry;
  String? experienceLevel;
  String? company;
  double? minSalary;
  double? maxSalary;

  int _currentPage = 1;
  final int _limit = 5;

  Future<void> fetchJobs({bool reset = false}) async {
    if (_isLoading || _isAllLoaded) return;

    _isLoading = true;

    if (reset) {
      _currentPage = 1;
      _isAllLoaded = false;
      _jobs.clear();
    }

    notifyListeners();

    try {
      final newJobs = await searchJobs(
        keyword: keyword,
        location: location,
        industry: industry,
        experienceLevel: experienceLevel,
        company: company,
        minSalary: minSalary,
        maxSalary: maxSalary,
        page: _currentPage,
        limit: _limit,
      );

      if (newJobs.isEmpty) {
        _isAllLoaded = true;
      } else {
        _jobs.addAll(newJobs);
        _currentPage++;
        print(_currentPage);
      }
    } catch (e) {
      print("Error fetching jobs: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  // 🔁 Load next page
  Future<void> loadMoreJobs() async {
    print(_isAllLoaded ? "All jobs loaded" : "Loading more jobs...");
    if (_isAllLoaded || _isLoading) return;
    await fetchJobs(); 
  }

  void setFilters({
    String? keyword,
    String? location,
    String? industry,
    String? experienceLevel,
    String? company,
    double? minSalary,
    double? maxSalary,
  }) {
    this.keyword = keyword;
    this.location = location;
    this.industry = industry;
    this.experienceLevel = experienceLevel;
    this.company = company;
    this.minSalary = minSalary;
    this.maxSalary = maxSalary;
    _currentPage = 1;
    _isAllLoaded = false;
    _jobs.clear();
    notifyListeners();
  }

  void resetProvider() {
    _jobs.clear();
    _currentPage = 1;
    _isAllLoaded = false;
    notifyListeners();
  }
}
