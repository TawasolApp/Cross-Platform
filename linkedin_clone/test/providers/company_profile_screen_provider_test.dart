import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/company/domain/entities/company.dart';
import 'package:linkedin_clone/features/company/domain/entities/user.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart';
import 'package:linkedin_clone/features/company/presentation/providers/company_provider.dart'
    show Post;

class FakeCompanyProvider extends CompanyProvider {
  Company? _fakeCompany;
  List<User> _fakeFriendsFollowing = [];
  List<Company> _fakeRelatedCompanies = [];
  List<Post> _fakePosts = [];
  bool _fakeIsLoading = false;
  final Map<String, bool> _fakeFollowStatus = {};

  @override
  Company? get company => _fakeCompany;
  @override
  List<User> get friendsFollowing => _fakeFriendsFollowing;
  @override
  List<Company> get relatedCompanies => _fakeRelatedCompanies;
  @override
  List<Post> get posts => _fakePosts;
  @override
  bool get isLoading => _fakeIsLoading;
  @override
  bool isFollowing(String companyId) => _fakeFollowStatus[companyId] ?? false;

  @override
  Future<void> fetchCompanyDetails(String companyId, String userId) async {
    _fakeIsLoading = true;
    notifyListeners();
    await Future.delayed(Duration(milliseconds: 10));

    _fakeCompany = Company(
      id: companyId,
      name: "Fake Company",
      description: "A fake company description",
      website: "https://fakecompany.com",
      bannerUrl: "fake_banner",
      logoUrl: "fake_logo",
      field: "Technology",
      followerCount: 100,
      employeeCount: 200,
      location: "Fake City",
      followerIds: [],
    );

    _fakeFriendsFollowing = [
      User(id: "u1", name: "Alice", profileImageUrl: "url1"),
      User(id: "u2", name: "Bob", profileImageUrl: "url2"),
    ];

    _fakeRelatedCompanies = [
      Company(
        id: "c2",
        name: "Related Company",
        description: "Related company description",
        website: "https://related.com",
        bannerUrl: "related_banner",
        logoUrl: "related_logo",
        field: "Technology",
        followerCount: 50,
        employeeCount: 150,
        location: "Related City",
        followerIds: [],
      ),
    ];

    _fakePosts = [
      Post(
        username: "Tech Corp",
        profileImage: "fake_logo",
        text: "Exciting news! We just launched a new AI-powered tool.",
        imageUrl: null,
        likes: 120,
        comments: 30,
        shares: 15,
        followers: 5000,
      ),
    ];

    _fakeIsLoading = false;
    notifyListeners();
  }

  @override
  Future<void> fetchFollowStatus(String userId, String companyId) async {
    _fakeFollowStatus[companyId] = true;
    notifyListeners();
  }

  @override
  Future<void> toggleFollowStatus(String userId, String companyId) async {
    bool currentStatus = _fakeFollowStatus[companyId] ?? false;
    _fakeFollowStatus[companyId] = !currentStatus;
    notifyListeners();
  }
}

void main() {
  group('✅ CompanyProvider Tests', () {
    late FakeCompanyProvider provider;

    setUp(() {
      provider = FakeCompanyProvider();
    });

    test("🟢 fetchCompanyDetails sets company and related fields", () async {
      print("🟡 Fetching company details...");
      await provider.fetchCompanyDetails("c1", "u1");

      expect(provider.company, isNotNull, reason: "Company should not be null");
      print("✅ Company Name: ${provider.company!.name}");

      expect(
        provider.friendsFollowing.length,
        equals(2),
        reason: "Friends following should be 2",
      );
      print("✅ Friends Following Count: ${provider.friendsFollowing.length}");

      expect(
        provider.relatedCompanies.length,
        equals(1),
        reason: "Related companies should be 1",
      );
      print("✅ Related Companies Count: ${provider.relatedCompanies.length}");

      expect(provider.posts.length, equals(1), reason: "Should have 1 post");
      print("✅ Posts Count: ${provider.posts.length}");

      expect(provider.isLoading, isFalse, reason: "Loading should be false");
      print("✅ Loading Status: ${provider.isLoading}");
    });

    test("🟢 toggleFollowStatus toggles follow status", () async {
      print("🟡 Checking initial follow status...");
      await provider.fetchFollowStatus("u1", "c1");
      expect(
        provider.isFollowing("c1"),
        isTrue,
        reason: "Should be following initially",
      );
      print("✅ Initial Follow Status: ${provider.isFollowing("c1")}");

      print("🟡 Toggling follow status...");
      await provider.toggleFollowStatus("u1", "c1");
      expect(
        provider.isFollowing("c1"),
        isFalse,
        reason: "Should be unfollowed",
      );
      print("✅ Follow Status After Toggle: ${provider.isFollowing("c1")}");

      print("🟡 Toggling follow status again...");
      await provider.toggleFollowStatus("u1", "c1");
      expect(
        provider.isFollowing("c1"),
        isTrue,
        reason: "Should be followed again",
      );
      print(
        "✅ Follow Status After Second Toggle: ${provider.isFollowing("c1")}",
      );
    });
  });
}
