import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/entities/post_entity.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../domain/usecases/save_post_usecase.dart';
import '../../domain/usecases/react_to_post_usecase.dart';

class FeedProvider extends ChangeNotifier {
  final GetPostsUseCase getPostsUseCase;
  final CreatePostUseCase createPostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final SavePostUseCase savePostUseCase;
  final ReactToPostUseCase reactToPostUseCase;

  FeedProvider({
    required this.getPostsUseCase,
    required this.createPostUseCase,
    required this.deletePostUseCase,
    required this.savePostUseCase,
    required this.reactToPostUseCase,
  });

  List<PostEntity> _posts = [];
  List<PostEntity> get posts => _posts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  final String _authorName = 'Ahmed Nabil';
  final String _profileImage = 'https://via.placeholder.com/150';
  final String _authorTitle = 'Software Engineer';

  String get authorName => _authorName;
  String get profileImage => _profileImage;
  String get authorTitle => _authorTitle;

  String _visibility = "Public"; // default
  String get visibility => _visibility;

  void setVisibility(String newVisibility) {
    _visibility = newVisibility;
    notifyListeners();
  }

  /////////
  final bool useMockData = true;

  Future<void> fetchPosts({int page = 1, int limit = 10}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    if (useMockData) {
      await Future.delayed(const Duration(milliseconds: 500)); // simulate delay
      _posts = [
        PostEntity(
          id: "1",
          authorId: "123",
          authorName: "AbdelRahman Sabry",
          authorPicture: "https://www.fakeprofilepic.com/image.png",
          authorBio: "Architecture Student",
          content: "I’m happy to share that I’m starting a new position!",
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
      ];
    } else {
      final result = await getPostsUseCase(page: page, limit: limit);
      result.fold(
        (failure) {
          _errorMessage = failure.message;
          _isLoading = false;
        },
        (posts) {
          _posts = posts;
          //_isLoading = false;
        },
      );
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createPost({
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
  }) async {
    _isCreating = true;
    _errorMessage = null;
    notifyListeners();

    if (useMockData) {
      final mockPost = PostEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: "mock_author",
        authorName: _authorName,
        authorPicture: _profileImage,
        authorBio: _authorTitle,
        content: content,
        media: media ?? [],
        taggedUsers: taggedUsers ?? [],
        likes: 0,
        comments: 0,
        shares: 0,
        visibility: visibility,
        authorType: "individual",
        isLiked: false,
        timestamp: DateTime.now(),
        repostDetails: null,
      );

      _posts.insert(0, mockPost);
    } else {
      final result = await createPostUseCase(
        content: content,
        media: media,
        taggedUsers: taggedUsers,
        visibility: visibility,
      );

      result.fold(
        (failure) {
          _errorMessage = failure.message;
        },
        (post) {
          // If API returns no post, may skip inserting or create a fallback
          _posts.insert(0, post);
        },
      );
    }

    _isCreating = false;
    notifyListeners();
  }

  Future<void> deletePost(String postId) async {
    _errorMessage = null;
    notifyListeners();

    if (useMockData) {
      // Just simulate local deletion
      _posts.removeWhere((post) => post.id == postId);
    } else {
      final result = await deletePostUseCase(postId);
      result.fold(
        (failure) {
          _errorMessage = failure.message;
        },
        (_) {
          _posts.removeWhere((post) => post.id == postId);
        },
      );
    }

    notifyListeners();
  }

  Future<void> savePost(String postId) async {
    _errorMessage = null;

    if (useMockData) {
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final post = _posts[index];
        final updated = post.copyWith(isSaved: !post.isSaved);
        _posts[index] = updated;
      }
    } else {
      final result = await savePostUseCase(postId);
      result.fold(
        (failure) {
          _errorMessage = failure.message;
        },
        (_) {
          final index = _posts.indexWhere((post) => post.id == postId);
          if (index != -1) {
            final post = _posts[index];
            final updated = post.copyWith(
              isSaved: true,
            ); // assume API always saves
            _posts[index] = updated;
          }
        },
      );
    }

    notifyListeners();
  }

  Future<void> reactToPost({
    required String postId,
    required Map<String, bool> reactions,
    String postType = 'Post',
  }) async {
    _errorMessage = null;

    if (useMockData) {
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final currentPost = _posts[index];
        final isLiked = reactions["Like"] ?? false;

        final updatedPost = currentPost.copyWith(
          isLiked: isLiked,
          likes:
              isLiked
                  ? currentPost.likes + 1
                  : (currentPost.likes > 0 ? currentPost.likes - 1 : 0),
        );

        _posts[index] = updatedPost;
        notifyListeners();
      }
      return;
    }

    final result = await reactToPostUseCase(
      postId: postId,
      reactions: reactions,
      postType: postType,
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
      },
      (_) {
        // Optional: Update local state/UI if needed after success
      },
    );

    notifyListeners();
  }
}
