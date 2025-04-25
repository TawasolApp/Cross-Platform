import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/services/token_service.dart';
import 'package:linkedin_clone/features/company/data/datasources/company_remote_data_source.dart';
import 'package:linkedin_clone/features/company/data/datasources/user_remote_data_source.dart';
import 'package:linkedin_clone/features/company/data/repositories/company_repository_impl.dart';
import 'package:linkedin_clone/features/company/data/repositories/job_repository_impl.dart';
import 'package:linkedin_clone/features/company/data/repositories/user_repository_impl.dart';
import 'package:linkedin_clone/features/company/domain/entities/create_job_entity.dart';
import 'package:linkedin_clone/features/company/domain/usecases/create_job_posting_use_case.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_company_details_usecase.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_company_followers_use_case.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_friends_following_company_usecase.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/domain/entities/user.dart';
import 'package:linkedin_clone/features/company/data/datasources/job_remote_data_source.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_recent_job_use_case.dart';
import 'package:linkedin_clone/features/company/domain/entities/job.dart';

class CompanyProvider with ChangeNotifier {
  Company? _company;
  List<User> _friendsFollowing = [];
  List<Company> _relatedCompanies = [];
  bool _isLoading = false;
  Map<String, bool> _followStatus = {};
  List<Job> _jobs = [];
  bool _isLoadingJobs = false;
  bool isManager = false;
  bool _disposed = false;
  bool isViewingAsUser = false;
  List<User> _followers = [];
  List<User> get followers => _followers;
  bool _isAllFollowersLoaded = false;
  bool get isAllFollowersLoaded => _isAllFollowersLoaded; //pagination
  bool _isLoadingFollowers = false;

  bool _isAllJobsLoaded = false;
  int _currentJobsPage = 1;
  int _currentFollowersPage = 1;
  bool get isAllJobsLoaded => _isAllJobsLoaded; //pagination
  String get errorMessage => _errorMessage;
  String _errorMessage = '';

  // Safe disposal
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotify() {
    if (!_disposed) notifyListeners();
  }

  bool isFollowing(String companyId) => _followStatus[companyId] ?? false;
  Company? get company => _company;
  List<User> get friendsFollowing => _friendsFollowing;
  List<Company> get relatedCompanies => _relatedCompanies;
  bool get isLoading => _isLoading;
  List<Job> get jobs => _jobs;
  bool get isLoadingJobs => _isLoadingJobs;
  bool get isLoadingFollowers => _isLoadingFollowers;
  bool get hasValidLogo =>
      _company?.logo != null && _company!.logo!.trim().isNotEmpty;
  bool get hasValidBanner =>
      _company?.banner != null && _company!.banner!.trim().isNotEmpty;
  final GetCompanyDetails _getCompanyDetails = GetCompanyDetails(
    repository: CompanyRepositoryImpl(
      remoteDataSource: CompanyRemoteDataSource(),
    ),
  );

  final GetFriendsFollowingCompany _getFriendsFollowingCompany =
      GetFriendsFollowingCompany(
        userRepository: UserRepositoryImpl(
          remoteDataSource: UserRemoteDataSource(),
        ),
        companyRepository: CompanyRepositoryImpl(
          remoteDataSource: CompanyRemoteDataSource(),
        ),
      );

  final GetRecentJobs _getRecentJobs = GetRecentJobs(
    repository: JobRepositoryImpl(remoteDataSource: JobRemoteDataSource()),
  );
  final CreateJob _createJob = CreateJob(
    repository: JobRepositoryImpl(remoteDataSource: JobRemoteDataSource()),
  );

  final GetCompanyFollowersUseCase _getCompanyFollowersUseCase =
      GetCompanyFollowersUseCase(
        repository: CompanyRepositoryImpl(
          remoteDataSource: CompanyRemoteDataSource(),
        ),
      );

  final UserRemoteDataSource _userRemoteDataSource = UserRemoteDataSource();

  get currentJobsPage => _currentJobsPage;

  Future<void> fetchCompanyDetails(String companyId) async {
    _isLoading = true;
    safeNotify();
    print('CompanyID is:$companyId');

    _company = await _getCompanyDetails.execute(companyId);
    await TokenService.saveCompanyId(companyId); //saves company id

    await fetchFollowStatus(companyId);
    _friendsFollowing = await _getFriendsFollowingCompany.execute(companyId);
    _jobs = await fetchRecentJobs(companyId);
    isManager = _company?.isManager ?? false;
    await TokenService.saveIsCompany(isViewingAsUser);

    _isLoading = false;
    safeNotify();
  }

  Future<void> fetchFollowStatus(String companyId) async {
    bool status = _company?.isFollowing ?? false;
    _followStatus[companyId] = status;
    safeNotify();
  }

  Future<void> toggleFollowStatus(
    String companyId,
    String currentCompanyId,
  ) async {
    bool currentStatus = _followStatus[companyId] ?? false;
    safeNotify();
    try {
      bool newStatus = await _userRemoteDataSource.toggleFollowCompany(
        companyId,
        currentStatus,
      );
      _followStatus[companyId] = newStatus;
    } catch (e) {
      print("Error toggling follow status: $e");
      _followStatus[companyId] = currentStatus;
    }
    _isLoading = true;
    _company = await _getCompanyDetails.execute(currentCompanyId);
    _isLoading = false;
    await fetchFollowStatus(companyId);
    _followStatus[companyId] = !currentStatus;
    print('STATUS ISSS: ${_followStatus[companyId]}');

    safeNotify();
  }

  void toggleViewMode() async {
    isViewingAsUser = !isViewingAsUser;
    await TokenService.saveIsCompany(isViewingAsUser);
    notifyListeners();
  }

  Future<List<User>> fetchFriendsFollowingCompany(String companyId) async {
    _isLoading = true;
    safeNotify();

    _friendsFollowing = await _getFriendsFollowingCompany.execute(companyId);

    _isLoading = false;
    safeNotify();
    return _friendsFollowing;
  }

  Future<List<Job>> fetchRecentJobs(
    String companyId, {
    int page = 1,
    int limit = 4,
  }) async {
    // Start the loading process
    _isLoadingJobs = true;
    safeNotify();
    print('fetchiggg jobsssss');
    try {
      // Fetch the jobs using the API
      List<Job> jobList = await _getRecentJobs.execute(
        companyId,
        page: page,
        limit: limit,
      );

      // If no jobs were fetched, and it's the first request, we mark all jobs as loaded
      if (jobList.isEmpty && page == 1) {
        _isAllJobsLoaded = true;
      }

      // If jobs are fetched, add them to the existing list
      if (jobList.isNotEmpty) {
        _jobs.addAll(jobList); // Add new jobs to the existing list
      }

      // Return the fetched jobs
      return jobList;
    } catch (e) {
      print("Error fetching jobs: $e");

      return [];
    } finally {
      // Set the loading state to false
      _isLoadingJobs = false;
      safeNotify();
    }
  }

  Future<void> loadMoreJobs(String companyId) async {
    if (_isLoadingJobs || _isAllJobsLoaded) return;

    _isLoadingJobs = true;
    safeNotify();

    _currentJobsPage++;

    try {
      List<Job> newJobs = await fetchRecentJobs(
        companyId,
        page: _currentJobsPage,
      );

      if (newJobs.isEmpty) {
        _isAllJobsLoaded = true;
      } else {}
    } catch (e) {
      print("Error loading more jobs: $e");
    } finally {
      // Reset the loading state and notify listeners
      _isLoadingJobs = false;
      safeNotify();
    }
  }

  // Updated addJob method
  Future<bool> addJob(CreateJobEntity job, String companyId) async {
    try {
      _isLoadingJobs = true;
      safeNotify();

      // Attempt to add the job
      final response = await _createJob.execute(job, companyId);
      resetJobs();
      print(jobs);
      await fetchRecentJobs(companyId);

      _isLoadingJobs = false;
      safeNotify();

      return true;
    } catch (e) {
      print("Error adding job: $e");
      _isLoadingJobs = false;
      safeNotify();

      return false;
    }
  }

  Future<List<User>> fetchFollowers(
    String companyId, {
    int page = 1,
    int limit = 2,
  }) async {
    _isLoadingFollowers = true;
    safeNotify();

    try {
      List<User> followersList = await _getCompanyFollowersUseCase.execute(
        companyId,
        page: page,
        limit: limit,
      );

      if (followersList.isEmpty) {
        _isAllFollowersLoaded = true;
        return [];
      }

      if (followersList.isNotEmpty) {
        _followers.addAll(followersList);
      } else {
        _isAllFollowersLoaded = true;
      }

      return followersList;
    } catch (e) {
      print("Error fetching followers: $e");

      return [];
    } finally {
      _isLoadingFollowers = false;
      safeNotify();
    }
  }

  Future<void> loadMoreFollowers(String companyId) async {
    if (_isLoadingFollowers || _isAllFollowersLoaded) return;
    _isLoadingFollowers = true;
    safeNotify();

    try {
      final nextPage = _currentFollowersPage + 1; // Don't increment yet

      List<User> newFollowers = await fetchFollowers(companyId, page: nextPage);
      if (newFollowers.isEmpty) {
        _isAllFollowersLoaded = true;
      } else {
        _currentFollowersPage = nextPage;
      }
    } catch (e) {
      print("Error loading more followers: $e");
    } finally {
      _isLoadingFollowers = false;
      safeNotify();
    }
  }

  void resetJobs() {
    _jobs.clear();
    _currentJobsPage = 1;
    _isAllJobsLoaded = false;
    _isLoadingJobs = false;
    _errorMessage = '';

    safeNotify();
  }

  void resetFollowers() {
    followers.clear();
    _currentFollowersPage = 1;
    _isAllFollowersLoaded = false;
    _isLoadingFollowers = false;
    _errorMessage = '';
    notifyListeners();
  }
}
