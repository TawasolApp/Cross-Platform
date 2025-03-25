import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkedin_clone/features/company/data/datasources/company_remote_data_source.dart';
import 'package:linkedin_clone/features/company/data/datasources/user_remote_data_source.dart';
import 'package:linkedin_clone/features/company/data/repositories/company_repository_impl.dart';
import 'package:linkedin_clone/features/company/data/repositories/user_repository_impl.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_company_details.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_friends_following_company.dart';
import 'package:linkedin_clone/features/company/domain/usecases/get_related_companies.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/domain/entities/user.dart';

//TODO: Import the posts from the posts module instead of the dummy data
// import 'package:linkedin_clone/features/posts/data/models/post.dart';
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

/// ✅ Provider for company details
class CompanyProvider with ChangeNotifier {
  Company? _company;
  List<User> _friendsFollowing = [];
  List<Company> _relatedCompanies = [];
  bool _isLoading = false;
  Map<String, bool> _followStatus = {}; // Track follow status per company
  List<Post> _posts = [];

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

  /// ✅ Fetches all company details (including follow status)
  Future<void> fetchCompanyDetails(String companyId, String userId) async {
    _isLoading = true;
    notifyListeners();

    _company = await _getCompanyDetails.execute(companyId);
    await fetchFollowStatus(userId, companyId); // Fetch follow status
    _friendsFollowing = await _getFriendsFollowingCompany.execute(
      userId,
      companyId,
    );
    _relatedCompanies = await _getRelatedCompanies.execute(companyId);
    _isLoading = false;
    _posts = await fetchPosts();
    notifyListeners();
  }

  /// ✅ Checks if the user follows the company
  Future<void> fetchFollowStatus(String userId, String companyId) async {
    bool status = await _userRemoteDataSource.checkIfUserFollowsCompany(
      userId,
      companyId,
    );
    _followStatus[companyId] = status; // Store follow status per company
    notifyListeners();
  }

  /// ✅ Toggles follow/unfollow status
  Future<void> toggleFollowStatus(String userId, String companyId) async {
    bool currentStatus = _followStatus[companyId] ?? false;

    _followStatus[companyId] = !currentStatus;
    notifyListeners();

    try {
      bool newStatus = await _userRemoteDataSource.toggleFollowCompany(
        userId,
        companyId,
        currentStatus,
      );
      _followStatus[companyId] = newStatus; // Update with API response
    } catch (e) {
      print("Error toggling follow status: $e");
      _followStatus[companyId] = currentStatus; // Revert on failure
    }

    notifyListeners();
  }

  /// ✅ Fetches friends following the company
  Future<List<User>> fetchFriendsFollowingCompany(
    String userId,
    String companyId,
  ) async {
    _isLoading = true;
    notifyListeners();

    _friendsFollowing = await _getFriendsFollowingCompany.execute(
      userId,
      companyId,
    );
    _isLoading = false;
    notifyListeners();
    return _friendsFollowing;
  }

  /// ✅ Fetches related companies
  Future<void> fetchRelatedCompanies(String companyId) async {
    _isLoading = true;
    notifyListeners();

    _relatedCompanies = await _getRelatedCompanies.execute(companyId);
    _isLoading = false;
    notifyListeners();
  }

  Future<List<Post>> fetchPosts() async {
    // Simulating a delay (API Call)
    await Future.delayed(Duration(seconds: 2));
    notifyListeners();
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
