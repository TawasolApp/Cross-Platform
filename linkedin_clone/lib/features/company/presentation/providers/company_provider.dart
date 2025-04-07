import 'package:flutter/material.dart';
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

class Post {
  final String username;
  final String profileImage;
  final String text;
  final String? imageUrl;
  final int likes;
  final int comments;
  final int shares;
  final int followers;

  Post({
    required this.username,
    required this.profileImage,
    required this.text,
    this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.followers,
  });
}

class CompanyProvider with ChangeNotifier {
  Company? _company;
  List<User> _friendsFollowing = [];
  List<Company> _relatedCompanies = [];
  bool _isLoading = false;
  Map<String, bool> _followStatus = {};
  List<Post> _posts = [];
  List<Job> _jobs = [];
  bool _isLoadingJobs = false;
  bool isManager = false;
  bool _disposed = false;
  bool isViewingAsUser = false;
  List<User> _followers = [];
  List<User> get followers => _followers;
  String _errorMessage = '';
  bool _isAllJobsLoaded = false;
  int _currentJobsPage = 1;
  bool get isAllJobsLoaded => _isAllJobsLoaded;
  String get errorMessage => _errorMessage;

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
  List<Post> get posts => _posts;
  List<Job> get jobs => _jobs;
  bool get isLoadingJobs => _isLoadingJobs;
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


  Future<void> fetchCompanyDetails(String companyId, String userId) async {
    _isLoading = true;
    safeNotify();
    print('CompanyID is:$companyId');
    _company = await _getCompanyDetails.execute(companyId);

    await fetchFollowStatus(companyId);
    _friendsFollowing = await _getFriendsFollowingCompany.execute(
      userId,
      companyId,
    );
    _posts = await fetchPosts();
    _jobs = await fetchRecentJobs(companyId);
    isManager = _company?.isManager ?? false;
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
    print('STATUS IS: ${_company?.isFollowing}');
    print('STATUS ISSS: ${_followStatus[companyId]}');

    safeNotify();
  }

  void toggleViewMode() {
    isViewingAsUser = !isViewingAsUser;
    notifyListeners();
  }

  Future<List<User>> fetchFriendsFollowingCompany(
    String userId,
    String companyId,
  ) async {
    _isLoading = true;
    safeNotify();

    _friendsFollowing = await _getFriendsFollowingCompany.execute(
      userId,
      companyId,
    );

    _isLoading = false;
    safeNotify();
    return _friendsFollowing;
  }

  Future<List<Post>> fetchPosts() async {
    await Future.delayed(Duration(seconds: 2));
    return [
      Post(
        username: "Tech Corp",
        profileImage: company?.logo ?? 'default_logo_url',
        text: "Exciting news! We just launched a new AI-powered tool.",
        imageUrl:
            "https://connect-assets.prosple.com/cdn/ff/7jtyuAO15E0OYPTLcxUXQhK5MpVI7gEfDSjKrRKjL0A/1645287092/public/2022-02/P%26G-banner.png",
        likes: 120,
        comments: 30,
        shares: 15,
        followers: 5000,
      ),
      Post(
        username: "DevHub",
        profileImage: company?.logo ?? 'default_logo_url',
        text: "Join us for our next developer conference!",
        imageUrl: null,
        likes: 85,
        comments: 20,
        shares: 10,
        followers: 3200,
      ),
    ];
  }

  Future<List<Job>> fetchRecentJobs(
    String companyId, {
    int page = 1,
    int limit = 4,
  }) async {
    // Start the loading process
    _isLoadingJobs = true;
    safeNotify();

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
      // Handle error gracefully
      print("Error fetching jobs: $e");

      // Return an empty list if there's an error
      return [];
    } finally {
      // Set the loading state to false
      _isLoadingJobs = false;
      safeNotify();
    }
  }

  Future<void> loadMoreJobs() async {
    // Check if jobs are already loading or all jobs are already loaded
    if (_isLoadingJobs || _isAllJobsLoaded) return;

    // Set the loading state to true to prevent multiple simultaneous requests
    _isLoadingJobs = true;
    safeNotify();

    // Increment the current page to load the next set of jobs
    _currentJobsPage++;

    try {
      List<Job> newJobs = await fetchRecentJobs(
        company?.companyId ?? '',
        page: _currentJobsPage,
      );

      // If no new jobs are returned, mark that all jobs are loaded
      if (newJobs.isEmpty) {
        _isAllJobsLoaded = true;
      } else {
        // Add the newly fetched jobs to the existing job list
        _jobs.addAll(newJobs);
      }
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
      await fetchRecentJobs(companyId);

      _isLoadingJobs = false;
      safeNotify();

      // Return true if job was added successfully
      return true;
    } catch (e) {
      print("Error adding job: $e");
      _isLoadingJobs = false;
      safeNotify();

      // Return false if there was an error
      return false;
    }
  }

  Future<void> fetchFollowers(String companyId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _followers = await _getCompanyFollowersUseCase.execute(companyId);
      _errorMessage = '';
    } catch (e) {
      print("Error fetching followers: $e");
      _errorMessage = 'Failed to load followers';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
