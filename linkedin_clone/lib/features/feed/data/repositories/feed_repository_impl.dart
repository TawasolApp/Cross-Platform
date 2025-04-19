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
  Future<Either<Failure, List<PostEntity>>> getPosts({
    int? page,
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getPosts(page: page, limit: limit);

      return result.fold((failure) => Left(failure), (posts) {
        final entities = posts.map((post) => post.toEntity()).toList();
        return Right(entities);
      });
    } catch (e) {
      return Left(ServerFailure('Failed to load posts'));
    }
  }

  @override
  Future<Either<Failure, PostEntity>> createPost({
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
    String? parentPostId,
    bool isSilentRepost = false,
  }) async {
    final result = await remoteDataSource.createPost(
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
  Future<Either<Failure, Unit>> deletePost(String postId) async {
    try {
      await remoteDataSource.deletePost(postId);
      return const Right(unit);
    } on ServerException {
      return Left(ServerFailure("Failed to delete post"));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  // Save a Post
  @override
  Future<Either<Failure, Unit>> savePost(String postId) async {
    try {
      print("Repository: Saving post with ID: $postId");
      await remoteDataSource.savePost(postId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> unsavePost(String postId) async {
    try {
      print("Repository: Deleting saved post with ID: $postId");
      await remoteDataSource.unsavePost(postId);
      return const Right(unit);
    } catch (e) {
      print("Repository Error deleting saved post: $e");
      return Left(ServerFailure("Failed to delete saved post"));
    }
  }

  @override
  Future<Either<Failure, Unit>> reactToPost({
    required String postId,
    required Map<String, bool> reactions,
    required String postType,
  }) async {
    try {
      await remoteDataSource.reactToPost(
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
    String postId, {
    String type = 'All',
  }) async {
    try {
      final reactions = await remoteDataSource.getPostReactions(
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
  Future<Either<Failure, Unit>> editPost({
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
  Future<Either<Failure, CommentModel>> addComment({
    required String postId,
    required String content,
    List<String>? taggedUsers,
    bool isReply = false,
  }) async {
    print("Repository: Adding comment to post with ID: $postId");
    final comment = await remoteDataSource.addComment(
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
    String postId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final comments = await remoteDataSource.fetchComments(
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
  Future<Either<Failure, Unit>> editComment({
    required String commentId,
    required String content,
    List<String>? tagged,
    bool isReply = false,
  }) async {
    try {
      await remoteDataSource.editComment(
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
    String userId, {
    int? page,
    int limit = 10,
  }) async {
    try {
      final result = await remoteDataSource.getUserPosts(
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
  Future<Either<Failure, Unit>> deleteComment(String commentId) async {
    try {
      await remoteDataSource.deleteComment(commentId);
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
}
