import 'package:flutter/material.dart';
import 'package:linkedin_clone/features/company/data/datasources/company_remote_data_source.dart';
import 'package:linkedin_clone/features/company/data/datasources/user_remote_data_source.dart';
import 'package:linkedin_clone/features/company/data/repositories/company_repository_impl.dart';
import 'package:linkedin_clone/features/company/data/repositories/user_repository_impl.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_company_details.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_friends_following_company.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_related_companies.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/domain/entities/user.dart';

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

  bool _disposed = false;

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

  final CompanyRepositoryImpl _companyRepository = CompanyRepositoryImpl(
    remoteDataSource: CompanyRemoteDataSource(),
  );

  final UserRemoteDataSource _userRemoteDataSource = UserRemoteDataSource();

  Future<void> fetchCompanyDetails(String companyId, String userId) async {
    _isLoading = true;
    safeNotify();

    _company = await _getCompanyDetails.execute(companyId);
    await fetchFollowStatus(userId, companyId);
    _friendsFollowing = await _getFriendsFollowingCompany.execute(userId, companyId);
    _relatedCompanies = await _getRelatedCompanies.execute(companyId);
    _posts = await fetchPosts();

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

  Future<List<User>> fetchFriendsFollowingCompany(
    String userId,
    String companyId,
  ) async {
    _isLoading = true;
    safeNotify();

    _friendsFollowing = await _getFriendsFollowingCompany.execute(userId, companyId);

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
        profileImage: company?.logoUrl ?? 'default_logo_url',
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
        profileImage: company?.logoUrl ?? 'default_logo_url',
        text: "Join us for our next developer conference!",
        imageUrl: null,
        likes: 85,
        comments: 20,
        shares: 10,
        followers: 3200,
      ),
    ];
  }
}
