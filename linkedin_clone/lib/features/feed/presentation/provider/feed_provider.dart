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
import '../../data/models/comment_model.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/usecases/edit_comment_usecase.dart';
import '../../domain/usecases/react_to_post_usecase.dart';
import '../../domain/usecases/get_post_reactions_usecase.dart';
import '../../domain/usecases/unsave_post_usecase.dart';
import '../../domain/usecases/get_user_posts_usecase.dart';
import '../../domain/usecases/delete_comment_usecase.dart';
import '../../data/models/reaction_model.dart';
import '../../../../core/services/token_service.dart';
import '../../domain/usecases/get_saved_posts_usecase.dart';
import '../../domain/usecases/get_post_by_id_usecase.dart';
import '../../domain/usecases/get_reposts_usecase.dart';
import '../../domain/entities/comment_entity.dart';
import 'package:collection/collection.dart';
import '../../domain/usecases/search_posts_usecase.dart';

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
  final GetSavedPostsUseCase getSavedPostsUseCase;
  final FetchPostByIdUseCase fetchPostByIdUseCase;
  final GetRepostsUseCase getRepostsUseCase;
  final SearchPostsUseCase searchPostsUseCase;

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
    required this.getSavedPostsUseCase,
    required this.fetchPostByIdUseCase,
    required this.getRepostsUseCase,
    required this.searchPostsUseCase,
  });

  // Pagination state control
  int _postsPage = 1;
  bool _hasMorePosts = true;
  bool get hasMorePosts => _hasMorePosts;

  int _savedPostsPage = 1;
  bool _hasMoreSavedPosts = true;
  bool get hasMoreSavedPosts => _hasMoreSavedPosts;

  int _userPostsPage = 1;
  bool _hasMoreUserPosts = true;
  bool get hasMoreUserPosts => _hasMoreUserPosts;

  int _repostsPage = 1;
  bool _hasMoreReposts = true;
  bool get hasMoreReposts => _hasMoreReposts;

  int _commentsPage = 1;
  bool _hasMoreComments = true;
  bool get hasMoreComments => _hasMoreComments;

  final Map<String, int> _repliesPage = {};
  final Map<String, bool> _repliesHasMore = {};
  final Set<String> _loadingReplies = {};

  String? _lastFetchedRepostPostId;

  int _paginationLimit = 10; // Global limit

  //String _currentUserId;
  List<PostEntity> _posts = [];
  List<PostEntity> get posts => _posts;

  List<PostEntity> _userPosts = [];
  List<PostEntity> get userPosts => _userPosts;

  List<PostEntity> _savedPosts = [];
  List<PostEntity> get savedPosts => _savedPosts;

  List<PostEntity> _reposts = [];
  List<PostEntity> get reposts => _reposts;

  bool _isLoadingReposts = false;
  bool get isLoadingReposts => _isLoadingReposts;

  String? _repostsError;
  String? get repostsError => _repostsError;

  List<CommentModel> _comments = [];
  List<CommentModel> get comments => _comments;

  Map<String, List<CommentEntity>> repliesByCommentId = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isCreating = false;
  bool get isCreating => _isCreating;
  // bool _hasLoadedUserPosts = false;
  // bool get hasLoadedUserPosts => _hasLoadedUserPosts;

  String _authorName = '';
  String _profileImage = '';
  String _authorTitle = '';
  String _authorId = '';
  String get authorId => _authorId;
  String get authorName => _authorName;
  String get profileImage => _profileImage;
  String get authorTitle => _authorTitle;
  String? _lastFetchedUserId;
  String? get lastFetchedUserId => _lastFetchedUserId;
  String _visibility = "Public"; // default
  String get visibility => _visibility;
  List<ReactionModel> _postReactions = [];
  List<ReactionModel> get postReactions => _postReactions;

  Map<String, List<ReactionModel>> _commentReactions = {};
  Map<String, List<ReactionModel>> get commentReactions => _commentReactions;

  bool _isReactionsLoading = false;
  bool get isReactionsLoading => _isReactionsLoading;

  String? _reactionsError;
  String? get reactionsError => _reactionsError;

  CommentEntity? getCommentById(String id) {
    return _comments.firstWhereOrNull((c) => c.id == id);
  }

  Future<String> get userId async {
    final isCompany = await TokenService.getIsCompany();
    return isCompany == true
        ? await TokenService.getCompanyId() ?? ''
        : await TokenService.getUserId() ?? '';
  }

  Future<bool> get isCompany async {
    final isCompany = await TokenService.getIsCompany();
    return isCompany ?? false;
  }

  void setVisibility(String newVisibility) {
    _visibility = newVisibility;
    notifyListeners();
  }

  void _handleFailure(Failure failure) {
    _errorMessage = failure.message;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPosts({bool refresh = false}) async {
    if (_isLoading) {
      print("Fetch already in progress, skipping...");
      print("fetchPosts called from: ${StackTrace.current}");

      return;
    }

    if (refresh) {
      _posts = [];
      _postsPage = 1;
      _hasMorePosts = true;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    print("Fetching posts...");

    try {
      final userId = await this.userId;
      final result = await getPostsUseCase(
        userId,
        page: _postsPage,
        limit: _paginationLimit,
      );
      result.fold(
        (failure) {
          _errorMessage = failure.message;
          print("Error while fetching posts: $_errorMessage");
          _isLoading = false;
          notifyListeners();
        },
        (posts) {
          //_posts = List<PostEntity>.from(posts);
          if (posts.length < _paginationLimit) _hasMorePosts = false;

          _posts.addAll(posts);
          _postsPage++;

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
    String searchUser, {
    //bool refresh = false,
    bool forceRefresh = false,
  }) async {
    if (_isLoading) {
      print("Fetch user posts already in progress, skipping...");
      return;
    }
    if (!forceRefresh && _lastFetchedUserId == searchUser) {
      print("🟡 Skipping fetch — already fetched userId: $userId");
      return;
    }

    if (forceRefresh || _lastFetchedUserId != searchUser) {
      _lastFetchedUserId = searchUser;
      _userPosts = [];
      _userPostsPage = 1;
      _hasMoreUserPosts = true;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    print("🔄 Fetching posts for user: $searchUser");

    try {
      final userId = await this.userId;
      print("🔄 inside: Fetching posts for user: $searchUser");
      final result = await getUserPostsUseCase(
        userId,
        searchUser,
        page: _userPostsPage,
        limit: _paginationLimit,
      );

      result.fold(
        (failure) {
          _errorMessage = failure.message;
          print("❌ Error fetching posts: $_errorMessage");
        },
        (posts) {
          if (posts.length < _paginationLimit) _hasMoreUserPosts = false;
          _userPosts.addAll(posts);
          _userPostsPage++;
          // _userPosts = List<PostEntity>.from(posts);

          print("✅ Posts fetched: ${_userPosts.length}");
        },
      );
    } catch (e) {
      _errorMessage = "Failed to fetch posts: $e";
      print("❌ Exception: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetUserPosts() {
    _userPosts = [];
    _isLoading = false;
    _errorMessage = null;
    _lastFetchedUserId = null;
    notifyListeners();
  }

  Future<void> createPost({
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
    String? parentPostId,
    bool isSilentRepost = false,
  }) async {
    final userId = await this.userId;
    print("create prov User ID: $userId");

    _isCreating = true;
    _errorMessage = null;
    notifyListeners();
    final actualContent = isSilentRepost ? "Reposted" : content;
    final actualMedia = isSilentRepost ? <String>[] : (media ?? []);
    final actualTaggedUsers = isSilentRepost ? <String>[] : (taggedUsers ?? []);
    final result = await createPostUseCase(
      userId,
      content: actualContent,
      media: actualMedia,
      taggedUsers: actualTaggedUsers,
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
    final userId = await this.userId;
    final result = await deletePostUseCase(userId, postId);
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
      final userId = await this.userId;
      final result = await savePostUseCase(userId, postId);
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
      final userId = await this.userId;
      final result = await unsavePostUseCase(userId, postId);
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
    final userId = await this.userId;
    final result = await editPostUseCase(
      userId,
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
    final userId = await this.userId;
    final result = await commentPostUseCase(
      userId,
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
        final updatedComment = comment.copyWith(isReply: isReply);

        comments.add(updatedComment);
        print("Provider: Comment added successfully: ${comment.content}");
        final postIndex = _posts.indexWhere((post) => post.id == postId);
        if (postIndex != -1) {
          _posts[postIndex].comments += 1;
        }
        notifyListeners();
      },
    );
  }

  Future<void> fetchComments(String postId, {bool refresh = false}) async {
    if (_isLoading) {
      print("Fetch comments already in progress, skipping...");
      return;
    }
    if (refresh) {
      _comments = [];
      _commentsPage = 1;
      _hasMoreComments = true;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    print("Fetching comments for post: $postId");
    final userId = await this.userId;
    final result = await fetchCommentsUseCase(
      userId,
      postId,
      page: _commentsPage,
      limit: _paginationLimit,
    );

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        // _isLoading = false;
        // notifyListeners();
      },
      (data) {
        if (data.length < _paginationLimit) _hasMoreComments = false;
        _comments.addAll(data);
        _commentsPage++;
        // _comments = data;
        // _isLoading = false;
        // notifyListeners();
      },
    );
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchReplies(String commentId, {bool refresh = false}) async {
    if (_isLoading) {
      print("Fetch replies already in progress, skipping...");
      return;
    }
    if (_loadingReplies.contains(commentId)) {
      print("Already loading replies for $commentId");
      return;
    }

    if (refresh || !repliesByCommentId.containsKey(commentId)) {
      repliesByCommentId[commentId] = [];
      _repliesPage[commentId] = 1;
      _repliesHasMore[commentId] = true;
    }

    if (_repliesHasMore[commentId] == false) return;

    _loadingReplies.add(commentId);
    notifyListeners();

    final userId = await this.userId;

    final result = await fetchCommentsUseCase(
      userId,
      commentId,
      page: _repliesPage[commentId]!,
      limit: _paginationLimit,
    );

    result.fold(
      (failure) {
        print("Failed to fetch replies for $commentId: ${failure.message}");
        _loadingReplies.remove(commentId);
        notifyListeners();
      },
      (data) {
        final list = repliesByCommentId[commentId] ?? [];
        repliesByCommentId[commentId] = [...list, ...data];
        if (data.length < _paginationLimit) {
          _repliesHasMore[commentId] = false;
        } else {
          _repliesPage[commentId] = _repliesPage[commentId]! + 1;
        }
        _loadingReplies.remove(commentId);
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
    final userId = await this.userId;
    final result = await editCommentUseCase(
      userId,
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
    final userId = await this.userId;
    final result = await reactToPostUseCase(
      userId,
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

  Future<void> getPostReactions(
    String postId, {
    String type = 'All',
    String postType = 'Post',
  }) async {
    _isReactionsLoading = true;
    _reactionsError = null;
    notifyListeners();
    print("Fetching reactions for post: $postId");
    final userId = await this.userId;
    final result = await getPostReactionsUseCase(userId, postId, type: type);

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
    final userId = await this.userId;
    final result = await deleteCommentUseCase(userId, commentId);
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

  Future<void> fetchSavedPosts({bool refresh = false}) async {
    if (_isLoading) {
      print("Fetch saved posts already in progress, skipping...");
      return;
    }
    if (refresh) {
      _savedPosts = [];
      _savedPostsPage = 1;
      _hasMoreSavedPosts = true;
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = await this.userId;
      final result = await getSavedPostsUseCase(
        userId,
        page: _savedPostsPage,
        limit: _paginationLimit,
      );

      result.fold(
        (failure) {
          _errorMessage = failure.message;
          //_savedPosts = [];
        },
        (posts) {
          if (posts.length < _paginationLimit) _hasMoreSavedPosts = false;
          _savedPosts.addAll(posts);
          _savedPostsPage++;
          //_savedPosts = List<PostEntity>.from(posts);
        },
      );
    } catch (e) {
      _errorMessage = "Failed to fetch saved posts: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<PostEntity?> fetchPostById(String userId, String postId) async {
    try {
      //final userId =
      //await this.userId; // companyId or userId based on TokenService logic
      final result = await fetchPostByIdUseCase(userId: userId, postId: postId);
      print("Prov: Fetching post by ID: $postId");
      print("Prov: User ID: $userId");
      return result.fold(
        (failure) {
          print('❌Prov: Failed to fetch parent post: ${failure.message}');
          return null;
        },
        (post) {
          print('✅ Prov: Parent post fetched: ${post.id}');
          return post;
        },
      );
    } catch (e) {
      print('❌ Prov: Exception while fetching parent post: $e');
      return null;
    }
  }

  Future<void> fetchReposts(String postId, {bool refresh = false}) async {
    if (_isLoadingReposts) {
      print("Fetch reposts already in progress, skipping...");
      return;
    }
    final isNewPost = _lastFetchedRepostPostId != postId;
    if (refresh || isNewPost) {
      _reposts = [];
      _repostsPage = 1;
      _hasMoreReposts = true;
      _lastFetchedRepostPostId = postId;
    }
    if (!_hasMoreReposts) {
      print("No more reposts to fetch, skipping...");
      return;
    }
    _isLoadingReposts = true;
    _repostsError = null;
    notifyListeners();
    final userId = await this.userId;

    final result = await getRepostsUseCase(
      userId: userId,
      postId: postId,
      page: _repostsPage,
      limit: _paginationLimit,
    );

    result.fold(
      (failure) {
        _repostsError = failure.message;
        if (isNewPost || refresh) _reposts = [];
      },
      (data) {
        if (data.length < _paginationLimit) _hasMoreReposts = false;
        _reposts.addAll(data);
        _repostsPage++;
        //_reposts = data;
      },
    );

    _isLoadingReposts = false;
    notifyListeners();
  }

  Future<void> searchCompanyPosts({
    required String companyId,
    required String query,
    bool? network,
    String timeframe = 'all',
    int page = 1,
    int limit = 10,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await searchPostsUseCase(
      companyId: companyId,
      query: query,
      network: network,
      timeframe: timeframe,
      page: page,
      limit: limit,
    );

    result.fold(
      (failure) => _errorMessage = failure.message,
      (posts) => _posts = posts,
    );

    _isLoading = false;
    notifyListeners();
  }
}
