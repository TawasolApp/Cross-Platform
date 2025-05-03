import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/features/feed/data/models/comment_model.dart';
import '../../domain/repositories/feed_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/post_entity.dart';
import '../data_sources/feed_remote_data_source.dart';
import '../../../../core/errors/exceptions.dart';
import '../../data/models/post_model.dart';
import '../models/reaction_model.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;

  FeedRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts(
    String userId, {
    int? page,
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getPosts(
        userId,
        page: page,
        limit: limit,
      );

      return result.fold((failure) => Left(failure), (posts) {
        final entities = posts.map((post) => post.toEntity()).toList();
        return Right(entities);
      });
    } catch (e) {
      return Left(ServerFailure('Failed to load posts'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> createPost(
    String userId, {
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
    String? parentPostId,
    bool isSilentRepost = false,
  }) async {
    final result = await remoteDataSource.createPost(
      userId,
      content: content,
      media: media,
      taggedUsers: taggedUsers,
      visibility: visibility,
      parentPostId: parentPostId,
      isSilentRepost: isSilentRepost,
    );

    return result.fold(
      (failure) => Left(failure),
      (postModel) => Right(postModel.toEntity()),
    );
  }

  // Delete a Post
  @override
  Future<Either<Failure, Unit>> deletePost(String userId, String postId) async {
    try {
      await remoteDataSource.deletePost(userId, postId);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure("Failed to delete post"));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  // Save a Post
  @override
  Future<Either<Failure, Unit>> savePost(String userId, String postId) async {
    try {
      print("Repository: Saving post with ID: $postId");
      await remoteDataSource.savePost(userId, postId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> unsavePost(String userId, String postId) async {
    try {
      print("Repository: Deleting saved post with ID: $postId");
      await remoteDataSource.unsavePost(userId, postId);
      return const Right(unit);
    } catch (e) {
      print("Repository Error deleting saved post: $e");
      return Left(ServerFailure("Failed to delete saved post"));
    }
  }

  @override
  Future<Either<Failure, Unit>> reactToPost(
    String userId, {
    required String postId,
    required Map<String, bool> reactions,
    required String postType,
  }) async {
    try {
      await remoteDataSource.reactToPost(
        userId,
        postId: postId,
        reactions: reactions,
        postType: postType,
      );
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<ReactionModel>>> getPostReactions(
    String userId,
    String postId, {
    String type = 'All',
  }) async {
    try {
      final reactions = await remoteDataSource.getPostReactions(
        userId,
        postId,
        type: type,
      );
      return Right(reactions);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: ${e.toString()}"));
    }
  }

  // Edit a Post
  @override
  Future<Either<Failure, Unit>> editPost(
    String userId, {
    required String postId,
    required String content,
    required List<String>? media,
    required List<String>? taggedUsers,
    required String visibility,
  }) async {
    try {
      print(
        'Repository: Sending request to remote data source with post ID: $postId',
      );

      await remoteDataSource.editPost(
        userId,
        postId: postId,
        content: content,
        media: media ?? [],
        taggedUsers: taggedUsers ?? [],
        visibility: visibility,
      );
      print('Repository: Post edit request sent');
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure("Unexpected error occurred"));
    }
  }

  // Add a Comment
  @override
  Future<Either<Failure, CommentModel>> addComment(
    String userId, {
    required String postId,
    required String content,
    List<String>? taggedUsers,
    bool isReply = false,
  }) async {
    print("Repository: Adding comment to post with ID: $postId");
    final comment = await remoteDataSource.addComment(
      userId,
      postId: postId,
      content: content,
      isReply: isReply,
    );
    return comment.fold(
      (failure) => Left(failure),
      (postModel) => Right(postModel),
    );
  }

  // Fetch Comments
  @override
  Future<Either<Failure, List<CommentModel>>> fetchComments(
    String userId,
    String postId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final comments = await remoteDataSource.fetchComments(
        userId,
        postId,
        page: page,
        limit: limit,
      );
      return Right(comments);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> editComment(
    String userId, {
    required String commentId,
    required String content,
    List<String>? tagged,
    bool isReply = false,
  }) async {
    try {
      await remoteDataSource.editComment(
        userId,
        commentId: commentId,
        content: content,
        tagged: tagged ?? [],
        isReply: isReply,
      );
      return const Right(unit);
    } on UnauthorizedException {
      return Left(UnauthorizedFailure("Unauthorized access"));
    } on ForbiddenException {
      return Left(ForbiddenFailure("Forbidden access"));
    } on NotFoundException {
      return Left(NotFoundFailure("Resource not found"));
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getUserPosts(
    String companyId,
    String userId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      print(
        "Repository: Fetching user posts with companyId: $companyId, userId: $userId, page: $page, limit: $limit",
      );
      final result = await remoteDataSource.getUserPosts(
        companyId,
        userId,
        page: page,
        limit: limit,
      );

      return result.fold((failure) => Left(failure), (posts) {
        final entities = posts.map((post) => post.toEntity()).toList();
        return Right(entities);
      });
    } catch (e) {
      return Left(ServerFailure('Failed to load posts'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteComment(
    String userId,
    String commentId,
  ) async {
    try {
      await remoteDataSource.deleteComment(userId, commentId);
      return const Right(unit);
    } on UnauthorizedException {
      return Left(UnauthorizedFailure("Unauthorized access"));
    } on ForbiddenException {
      return Left(ForbiddenFailure("Forbidden access"));
    } on NotFoundException {
      return Left(NotFoundFailure("Resource not found"));
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(UnexpectedFailure());
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getSavedPosts(
    String companyId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getSavedPosts(
        companyId,
        page: page,
        limit: limit,
      );
      return result.fold((failure) => Left(failure), (posts) {
        final entities = posts.map((post) => post).toList();
        return Right(entities);
      });
    } on ServerException {
      return Left(ServerFailure('Failed to load saved posts'));
    } catch (e) {
      return Left(ServerFailure('Failed to load saved posts'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> fetchPostById({
    required String userId,
    required String postId,
  }) async {
    try {
      final post = await remoteDataSource.fetchPostById(
        userId: userId,
        postId: postId,
      );
      return Right(post);
    } catch (e) {
      return Left(ServerFailure("Repo: Failed to fetch post by ID: $e"));
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getReposts({
    required String userId,
    required String postId,
    int page = 1,
    int limit = 10,
  }) async {
    final result = await remoteDataSource.getReposts(
      userId: userId,
      postId: postId,
      page: page,
      limit: limit,
    );

    return result.fold(
      (failure) => Left(failure),
      (models) => Right(models.map((e) => e.toEntity()).toList()),
    );
  }

  @override
  Future<Either<Failure, List<PostEntity>>> searchPosts({
    required String companyId,
    required String query,
    bool? network,
    String timeframe = 'all',
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final posts = await remoteDataSource.searchPosts(
        companyId: companyId,
        query: query,
        network: network,
        timeframe: timeframe,
        page: page,
        limit: limit,
      );
      return Right(posts.map((p) => p.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
