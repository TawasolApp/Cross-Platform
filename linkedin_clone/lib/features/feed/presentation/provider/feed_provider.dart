// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../domain/usecases/get_posts_usecase.dart';
// import '../../domain/entities/post_entity.dart';
// import '../../../../core/errors/failures.dart';

// class FeedProvider extends ChangeNotifier {
//   final GetPostsUseCase getPostsUseCase;

//   FeedProvider(this.getPostsUseCase);

//   List<PostEntity> _posts = [];
//   List<PostEntity> get posts => _posts;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;

//   Future<void> fetchPosts({int page = 1, int limit = 10}) async {
//     _isLoading = true;
//     _errorMessage = null;
//     notifyListeners();

//     final result = await getPostsUseCase(page: page, limit: limit);
//     result.fold(
//       (failure) {
//         _errorMessage = failure.message;
//         _isLoading = false;
//       },
//       (posts) {
//         _posts = posts;
//         _isLoading = false;
//       },
//     );

//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import '../../domain/entities/post_entity.dart';

class FeedProvider extends ChangeNotifier {
  List<PostEntity> _posts = [];

  List<PostEntity> get posts => _posts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPosts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _posts = [
      PostEntity(
        id: "1",
        authorId: "123",
        authorName: "AbdelRahman Sabry",
        authorPicture: "https://www.fakeprofilepic.com/image.png",
        authorBio: "Architecture Student",
        content:
            "I’m happy to share that I’m starting a new position as Junior Engineer at Health Insights Group!",
        media: [],
        likes: 97,
        comments: 26,
        shares: 10,
        visibility: "public",
        authorType: "individual",
        isLiked: false,
        timestamp: DateTime.now().subtract(const Duration(days: 7)),
        repostDetails: null,
      ),
      PostEntity(
        id: "2",
        authorId: "456",
        authorName: "Mayada Hadhoud",
        authorPicture: "https://www.fakeprofilepic.com/image2.png",
        authorBio: "Software Developer",
        content: "Check out this new internship opportunity!",
        media: [],
        likes: 651,
        comments: 28,
        shares: 84,
        visibility: "public",
        authorType: "company",
        isLiked: true,
        timestamp: DateTime.now().subtract(const Duration(days: 4)),
        repostDetails: null,
      ),
      PostEntity(
        id: "3",
        authorId: "789",
        authorName: "Telecom Egypt",
        authorPicture: "https://www.fakeprofilepic.com/telecom-logo.png",
        authorBio: "Promoted Post",
        content: "We're continuing our Ramadan food distribution campaign!",
        media: [],
        likes: 1243,
        comments: 95,
        shares: 200,
        visibility: "public",
        authorType: "company",
        isLiked: false,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        repostDetails: null,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }
}
