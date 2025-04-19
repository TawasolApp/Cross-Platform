import 'package:flutter/material.dart';
import 'package:linkedin_clone/core/errors/exceptions.dart';
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
import '../../domain/usecases/unsave_post_usecase.dart';
import '../../domain/usecases/get_user_posts_usecase.dart';
import 'package:collection/collection.dart';
import 'package:linkedin_clone/core/utils/reaction_type.dart';
import '../../domain/usecases/delete_comment_usecase.dart';
import '../../data/models/reaction_model.dart';

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
  final UnsavePostUseCase unsavePostUseCase;
  final GetUserPostsUseCase getUserPostsUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;

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
    required this.unsavePostUseCase,
    required this.getUserPostsUseCase,
    required this.deleteCommentUseCase,
  });

  //String _currentUserId;
  List<PostEntity> _posts = [];
  List<PostEntity> get posts => _posts;

  List<PostEntity> _userPosts = [];
  List<PostEntity> get userPosts => _userPosts;

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
  String _authorId = '';
  String get authorId => _authorId;
  String get authorName => _authorName;
  String get profileImage => _profileImage;
  String get authorTitle => _authorTitle;

  String _visibility = "Public"; // default
  String get visibility => _visibility;

  List<ReactionModel> _postReactions = [];
  List<ReactionModel> get postReactions => _postReactions;

  bool _isReactionsLoading = false;
  bool get isReactionsLoading => _isReactionsLoading;

  String? _reactionsError;
  String? get reactionsError => _reactionsError;

  void setVisibility(String newVisibility) {
    _visibility = newVisibility;
    notifyListeners();
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _isLoading = false;
    notifyListeners();
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

          ///
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

  Future<void> fetchUserPosts(
    String userId, {
    int page = 1,
    int limit = 10,
  }) async {
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
      final result = await getUserPostsUseCase(
        userId,
        page: page,
        limit: limit,
      );
      result.fold(
        (failure) {
          _errorMessage = failure.message;
          print("Error while fetching posts: $_errorMessage");
          _isLoading = false;
          notifyListeners();
        },
        (posts) {
          _userPosts = List<PostEntity>.from(posts);
          print("Posts fetched successfully, count: ${_userPosts.length}");
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
    print('Provider: Deleting post with ID: $postId');
    final result = await deletePostUseCase(postId);
    result.fold(
      (failure) {
        _handleFailure(failure);
        notifyListeners();
      },
      (_) {
        print('Post deleted successfully');

        _posts.removeWhere((post) => post.id == postId);
        notifyListeners();
      },
    );
  }

  Future<void> savePost(String postId) async {
    try {
      print("Provider: Attempting to save post with ID: $postId");
      final result = await savePostUseCase(postId);
      result.fold(
        (failure) {
          print("Provider Error saving post: $failure");
          _handleFailure(failure);
          notifyListeners();
        },
        (_) {
          print("Provider: Post saved successfully.");
          final index = _posts.indexWhere((post) => post.id == postId);
          if (index != -1) {
            _posts[index] = _posts[index].copyWith(isSaved: true);
            notifyListeners();
          }
        },
      );
    } catch (e) {
      print("Provider Exception saving post: $e");
      notifyListeners();
    }
  }

  Future<void> unsavePost(String postId) async {
    try {
      print("Provider: Attempting to unsave post with ID: $postId");
      final result = await unsavePostUseCase(postId);
      result.fold(
        (failure) {
          print("Provider Error unsaving post: $failure");
          _handleFailure(failure);
          notifyListeners();
        },
        (_) {
          print("Provider: Post unsaved successfully.");
          final index = _posts.indexWhere((post) => post.id == postId);
          if (index != -1) {
            _posts[index] = _posts[index].copyWith(isSaved: false);
            notifyListeners();
          }
        },
      );
    } catch (e) {
      print("Provider Exception unsaving post: $e");
      notifyListeners();
    }
  }

  Future<void> editPost({
    required String postId,
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
  }) async {
    final result = await editPostUseCase(
      postId: postId,
      content: content,
      media: media,
      taggedUsers: taggedUsers,
      visibility: visibility,
    );

    result.fold(
      (failure) {
        print('Provider Error post: ${failure.toString()}');
        print('${postId}');
      },
      (_) {
        print('Provider: Post edited successfully with id $postId');
        final index = posts.indexWhere((post) => post.id == postId);
        if (index != -1) {
          posts[index] = posts[index].copyWith(
            content: content,
            visibility: visibility,
          );
          notifyListeners();
        }
      },
    );
  }

  Future<void> addComment(String postId, String content, bool isReply) async {
    final result = await commentPostUseCase(
      postId: postId,
      content: content,
      isReply: isReply,
    );
    result.fold(
      (failure) {
        _handleFailure(failure);
        print("Failed to add comment: $failure");
      },
      (comment) async {
        comments.add(comment);
        print("Provider: Comment added successfully: ${comment.content}");
        final postIndex = _posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          _posts[postIndex].comments += 1;
        }
        notifyListeners();
      },
    );
  }

  // Fetch method for comments
  Future<void> fetchComments(
    String postId, {
    int page = 1,
    int limit = 10,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await fetchCommentsUseCase(postId, page: page, limit: limit);

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (data) {
        _comments = data;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> editComment({
    required String commentId,
    required String updatedContent,
    List<String>? taggedUsers,
    bool isReply = false,
  }) async {
    final result = await editCommentUseCase(
      commentId: commentId,
      content: updatedContent,
      tagged: taggedUsers,
      isReply: isReply,
    );
    result.fold((failure) => _handleFailure(failure), (_) {
      final index = _comments.indexWhere((c) => c.id == commentId);
      if (index != -1) {
        _comments[index] = _comments[index].copyWith(content: updatedContent);
        notifyListeners();
      }
      fetchComments(_comments[index].postId);
      print("Comment edited successfully: $updatedContent");
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
    print("prov: $reactions");
    result.fold((failure) => _handleFailure(failure), (_) {
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final post = _posts[index];
        print("prov: Reacting to post: ${post.id}");

        final previousReaction =
            post.reactType.isNotEmpty ? post.reactType : null;

        print("🧠 Previous reaction: $previousReaction");

        final selectedReaction =
            reactions.entries
                .firstWhere(
                  (e) => e.value == true,
                  orElse: () => const MapEntry('', false),
                )
                .key;

        print("🧠 Previous reaction: $previousReaction");
        print("👍 New selected reaction: $selectedReaction");

        final updatedCounts = Map<String, int>.from(post.reactCounts ?? {});

        if (previousReaction != null &&
            previousReaction.isNotEmpty &&
            previousReaction != selectedReaction) {
          final currCount = (updatedCounts[previousReaction] ?? 1);
          updatedCounts[previousReaction] =
              (currCount - 1).clamp(0, double.infinity).toInt();
          print(
            "➖ Decreased count of '$previousReaction' to ${updatedCounts[previousReaction]}",
          );
          if (updatedCounts[previousReaction]! <= 0) {
            updatedCounts.remove(previousReaction);
            print("🗑 Removed '$previousReaction' from counts");
          }
        }

        if (selectedReaction.isNotEmpty &&
            previousReaction != selectedReaction) {
          updatedCounts[selectedReaction] =
              (updatedCounts[selectedReaction] ?? 0) + 1;
          print(
            "➕ Increased count of '$selectedReaction' to ${updatedCounts[selectedReaction]}",
          );
        }

        final newReactionMap = <String, bool>{};
        if (selectedReaction.isNotEmpty) {
          newReactionMap[selectedReaction] = true;
        }

        print("🧩 Updated reactions map: $newReactionMap");

        _posts[index] = post.copyWith(
          reactCounts: updatedCounts,
          reactions: newReactionMap,
          reactType: selectedReaction,
        );

        notifyListeners();
        print("✅ Reaction applied and UI notified.");
      }
    });
  }

  Future<void> getPostReactions(String postId, {String type = 'All'}) async {
    _isReactionsLoading = true;
    _reactionsError = null;
    notifyListeners();

    final result = await getPostReactionsUseCase(postId, type: type);

    result.fold(
      (failure) {
        _postReactions = [];
        _reactionsError = failure.message;
        print("Failed to fetch reactions: ${failure.message}");
      },
      (reactions) {
        _postReactions = reactions;
        print("Fetched ${reactions.length} reactions for post $postId");
      },
    );

    _isReactionsLoading = false;
    notifyListeners();
  }

  Future<void> deleteComment(String postId, String commentId) async {
    print('Provider: Deleting comment with ID: $commentId from post: $postId');
    final result = await deleteCommentUseCase(commentId);
    result.fold(
      (failure) {
        print("Provider: Failed to delete comment: $failure");
        if (failure is NotFoundFailure) {
          print("Comment not found.");
        } else if (failure is UnauthorizedFailure) {
          print("Unauthorized access.");
        } else if (failure is ForbiddenFailure) {
          print("Action forbidden.");
        } else if (failure is ServerFailure) {
          print("Server error occurred.");
        } else {
          print("Unexpected failure occurred.");
        }
      },
      (_) {
        comments.removeWhere((comment) => comment.id == commentId);
        notifyListeners();
        fetchComments(postId);
        print("Comment deleted successfully");
      },
    );
  }
}
