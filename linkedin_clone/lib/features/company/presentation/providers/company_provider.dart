import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/data/datasources/company_remote_data_source.dart';
import 'package:linkedin_clone/features/company/data/datasources/user_remote_data_source.dart';
import 'package:linkedin_clone/features/company/data/models/job_model.dart';
import 'package:linkedin_clone/features/company/data/repositories/company_repository_impl.dart';
import 'package:linkedin_clone/features/company/data/repositories/job_repository_impl.dart';
import 'package:linkedin_clone/features/company/data/repositories/user_repository_impl.dart';
import 'package:linkedin_clone/features/company/domain/entities/create_job.dart';
import 'package:linkedin_clone/features/company/domain/usecases/create_job_posting_use_case.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_company_details_usecase.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_friends_following_company_usecase.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_related_companies_usecase.dart';
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
  bool isAdmin = false;
  bool _disposed = false;
  bool isViewingAsUser = false;

 
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

  final GetRelatedCompanies _getRelatedCompanies = GetRelatedCompanies(
    repository: CompanyRepositoryImpl(
      remoteDataSource: CompanyRemoteDataSource(),
    ),
  );
  final GetRecentJobs _getRecentJobs = GetRecentJobs(
    repository: JobRepositoryImpl(remoteDataSource: JobRemoteDataSource()),
  );
  final CreateJob _createJob = CreateJob(
    repository: JobRepositoryImpl(remoteDataSource: JobRemoteDataSource()),
  );
  final CompanyRepositoryImpl _companyRepository = CompanyRepositoryImpl(
    remoteDataSource: CompanyRemoteDataSource(),
  );

  final UserRemoteDataSource _userRemoteDataSource = UserRemoteDataSource();

  Future<void> fetchCompanyDetails(String companyId, String userId) async {
    _isLoading = true;
    safeNotify();
    print('CompanyID is:$companyId');
    _company = await _getCompanyDetails.execute(companyId);
    await fetchFollowStatus(userId, companyId);
    _friendsFollowing = await _getFriendsFollowingCompany.execute(
      userId,
      companyId,
    );
    _relatedCompanies = await _getRelatedCompanies.execute(companyId);
    _posts = await fetchPosts();
    _jobs = await fetchRecentJobs();
    isAdmin = _company?.isAdmin ?? false;
    _isLoading = false;
    safeNotify();
  }

  Future<void> fetchFollowStatus(String userId, String companyId) async {
    bool status = await _userRemoteDataSource.checkIfUserFollowsCompany(
      userId,
      companyId,
    );
    _followStatus[companyId] = status;
    safeNotify();
  }

  Future<void> toggleFollowStatus(String userId, String companyId) async {
    bool currentStatus = _followStatus[companyId] ?? false;
    _followStatus[companyId] = !currentStatus;
    safeNotify();

    try {
      bool newStatus = await _userRemoteDataSource.toggleFollowCompany(
        userId,
        companyId,
        currentStatus,
      );
      _followStatus[companyId] = newStatus;
    } catch (e) {
      print("Error toggling follow status: $e");
      _followStatus[companyId] = currentStatus;
    }

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

  Future<void> fetchRelatedCompanies(String companyId) async {
    _isLoading = true;
    safeNotify();

    _relatedCompanies = await _getRelatedCompanies.execute(companyId);

    _isLoading = false;
    safeNotify();
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

  Future<List<Job>> fetchRecentJobs() async {
    _isLoadingJobs = true;
    safeNotify();
    try {
      final jobList = await _getRecentJobs.execute();
      print("Fetched Jobs: $jobList"); // Debugging print statement

      if (jobList.isNotEmpty) {
        _isLoadingJobs = false;
        safeNotify();
        return jobList;
      } else {
        print("No jobs found from API.");
      }
    } catch (e) {
      print("Error fetching jobs: $e");
    }
    _isLoadingJobs = false;
    safeNotify();
    return [];
  }

  // Updated addJob method
  Future<void> addJob(CreateJobEntity job) async {
    try {
      _isLoadingJobs = true;
      safeNotify();
      await _createJob.execute(job); 
      await fetchRecentJobs(); 
      _isLoadingJobs = false;
      safeNotify();
    } catch (e) {
      print("Error adding job: $e");
      _isLoadingJobs = false;
      safeNotify();
    }
  }
}
