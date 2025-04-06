import 'package:flutter/material.dart';
import '../../domain/usecases/create_post_usecase.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/entities/post_entity.dart';
import '../../domain/usecases/delete_post_usecase.dart';
import '../../domain/usecases/save_post_usecase.dart';
import '../../domain/usecases/edit_post_usecase.dart';
import '../../domain/usecases/comment_post_usecase.dart';
import '../../domain/usecases/fetch_comments_usecase.dart';
import '../../data/models/post_model.dart';
import '../../data/models/comment_model.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/usecases/edit_comment_usecase.dart';
import '../../domain/usecases/react_to_post_usecase.dart';
import '../../domain/usecases/get_post_reactions_usecase.dart';
import '../../../profile/domain/usecases/profile/get_profile.dart';
import 'package:linkedin_clone/core/usecase/usecase.dart';

class FeedProvider extends ChangeNotifier {
  final GetPostsUseCase getPostsUseCase;
  final CreatePostUseCase createPostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final SavePostUseCase savePostUseCase;
  final EditPostUseCase editPostUseCase;
  final CommentPostUseCase commentPostUseCase;
  final FetchCommentsUseCase fetchCommentsUseCase;
  final EditCommentUseCase editCommentUseCase;
  final ReactToPostUseCase reactToPostUseCase;
  final GetPostReactionsUseCase getPostReactionsUseCase;
  final GetProfileUseCase getProfileUseCase;

  FeedProvider({
    required this.getPostsUseCase,
    required this.createPostUseCase,
    required this.deletePostUseCase,
    required this.savePostUseCase,
    required this.editPostUseCase,
    required this.commentPostUseCase,
    required this.fetchCommentsUseCase,
    required this.editCommentUseCase,
    required this.reactToPostUseCase,
    required this.getPostReactionsUseCase,
    required this.getProfileUseCase,
  });

  List<PostEntity> _posts = [];
  List<PostEntity> get posts => _posts;

  List<CommentModel> _comments = [];
  List<CommentModel> get comments => _comments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isCreating = false;
  bool get isCreating => _isCreating;

  String _authorName = '';
  String _profileImage = '';
  String _authorTitle = '';

  String get authorName => _authorName;
  String get profileImage => _profileImage;
  String get authorTitle => _authorTitle;

  String _visibility = "Public"; // default
  String get visibility => _visibility;

  void setVisibility(String newVisibility) {
    _visibility = newVisibility;
    notifyListeners();
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _isLoading = false;
    notifyListeners();
  }

  /////////
  final bool useMockData = false;
  Future<void> fetchProfileData() async {
    final result = await getProfileUseCase(NoParams());
    result.fold((failure) => _handleFailure(failure), (profile) {
      _authorName = profile.name ?? 'Unknown';
      _profileImage =
          profile.profilePicture ?? 'https://via.placeholder.com/150';
      _authorTitle = profile.headline ?? 'No Title';
      notifyListeners();
    });
  }

  Future<void> fetchPosts({int page = 1, int limit = 10}) async {
    if (_isLoading) {
      print("Fetch already in progress, skipping...");
      print("fetchPosts called from: ${StackTrace.current}");

      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    print("Fetching posts...");

    try {
      final result = await getPostsUseCase(page: page, limit: limit);
      result.fold(
        (failure) {
          _errorMessage = failure.message;
          print("Error while fetching posts: $_errorMessage");
          _isLoading = false;
          notifyListeners();
        },
        (posts) {
          _posts = List<PostEntity>.from(posts);
          print("Posts fetched successfully, count: ${_posts.length}");
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = "Failed to fetch posts: $e";
      print("Exception: $_errorMessage");
      _isLoading = false;
      notifyListeners();
    } finally {
      print("Fetch complete, isLoading: $_isLoading");
    }
  }

  Future<void> createPost({
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
    String? parentPostId,
    bool isSilentRepost = false,
  }) async {
    _isCreating = true;
    _errorMessage = null;
    notifyListeners();

    final result = await createPostUseCase(
      content: content,
      media: media,
      taggedUsers: taggedUsers,
      visibility: visibility,
      parentPostId: parentPostId?.isNotEmpty == true ? parentPostId : null,
      isSilentRepost: isSilentRepost,
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isCreating = false;
        notifyListeners();
      },
      (post) {
        _posts.insert(0, post);
        _isCreating = false;
        notifyListeners();
      },
    );
  }

  Future<void> deletePost(String postId) async {
    // _errorMessage = null;
    // notifyListeners();

    if (useMockData) {
      // Just simulate local deletion
      _posts.removeWhere((post) => post.id == postId);
    } else {
      final result = await deletePostUseCase(postId);
      result.fold((failure) => _handleFailure(failure), (_) {
        _posts.removeWhere((post) => post.id == postId);
        notifyListeners();
      });
    }

    //notifyListeners();
  }

  Future<void> savePost(String postId) async {
    //_errorMessage = null;

    if (useMockData) {
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final post = _posts[index];
        final updated = post.copyWith(isSaved: !post.isSaved);
        _posts[index] = updated;
      }
    } else {
      final result = await savePostUseCase(postId);
      result.fold((failure) => _handleFailure(failure), (_) {
        final index = _posts.indexWhere((post) => post.id == postId);
        if (index != -1) {
          final post = _posts[index];
          final updated = post.copyWith(
            isSaved: true,
          ); // assume API always saves
          _posts[index] = updated;
          notifyListeners();
        }
      });
    }

    //notifyListeners();
  }

  Future<void> editPost({
    required String postId,
    required String content,
  }) async {
    _errorMessage = null;

    if (useMockData) {
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(content: content);
      }
    } else {
      final result = await editPostUseCase(
        postId: postId,
        content: content,
        media: [],
        taggedUsers: [],
        visibility: visibility,
      );

      result.fold((failure) => _errorMessage = failure.message, (_) {
        // success! but no updated post returned, so update manually
        final index = _posts.indexWhere((post) => post.id == postId);
        if (index != -1) {
          final oldPost = _posts[index];
          _posts[index] = oldPost.copyWith(content: content);
        }
      });
    }
    notifyListeners();
  }

  Future<void> addComment(String postId, String content) async {
    //_errorMessage = null;

    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: postId,
      authorId: "789",
      authorName: "Mock User",
      authorPicture: "https://via.placeholder.com/50",
      authorBio: "Tester",
      content: content,
      taggedUsers: [],
      replies: [],
      reactCount: 0,
      timestamp: DateTime.now(),
    );

    if (useMockData) {
      _comments.insert(0, newComment);
      notifyListeners();
    } else {
      final result = await commentPostUseCase(postId, content);
      result.fold(
        (failure) => _handleFailure(failure),
        (_) => fetchComments(postId),
      );
    }
  }

  // Fetch method for comments
  Future<void> fetchComments(String postId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (useMockData) {
      //await Future.delayed(const Duration(milliseconds: 500)); // simulate delay
      _comments = [
        CommentModel(
          id: "c1",
          postId: postId,
          authorId: "123",
          authorName: "John Doe",
          authorPicture: "https://via.placeholder.com/50",
          authorBio: "Software Developer",
          content: "Great post! Really insightful.",
          taggedUsers: [],
          replies: [],
          reactCount: 5,
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
        CommentModel(
          id: "c2",
          postId: postId,
          authorId: "456",
          authorName: "Jane Smith",
          authorPicture: "https://via.placeholder.com/50",
          authorBio: "Product Manager",
          content: "Thanks for sharing!",
          taggedUsers: [],
          replies: [],
          reactCount: 3,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ];
      _isLoading = false;
      notifyListeners();
    } else {
      final result = await fetchCommentsUseCase(postId);
      result.fold(
        (failure) {
          _handleFailure(failure);
          _isLoading = false;
          notifyListeners();
        },
        (comments) {
          _comments =
              comments
                  .map((comment) => CommentModel.fromJson(comment))
                  .toList();
          _isLoading = false;
          notifyListeners();
        },
      );
    }
  }

  Future<void> editComment({
    required String commentId,
    required String content,
    List<String>? taggedUsers,
    bool isReply = false,
  }) async {
    final result = await editCommentUseCase(
      commentId: commentId,
      content: content,
      tagged: taggedUsers,
      isReply: isReply,
    );
    result.fold((failure) => _handleFailure(failure), (_) {
      final index = _comments.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        _comments[index] = _comments[index].copyWith(content: content);
        notifyListeners();
      }
    });
  }

  Future<void> reactToPost(
    String postId,
    Map<String, bool> reactions,
    String postType,
  ) async {
    final result = await reactToPostUseCase(
      postId: postId,
      reactions: reactions,
      postType: postType,
    );
    result.fold((failure) => _handleFailure(failure), (_) {
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(reactions: reactions);
        notifyListeners();
      }
    });
  }

  Future<List<Map<String, dynamic>>> getPostReactions(String postId) async {
    final result = await getPostReactionsUseCase(postId);
    return result.fold((failure) {
      _handleFailure(failure);
      return [];
    }, (reactions) => reactions);
  }
}
