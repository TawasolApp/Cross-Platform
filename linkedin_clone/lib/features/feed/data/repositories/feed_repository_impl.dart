import 'package:fpdart/fpdart.dart';
import '../../domain/repositories/feed_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/post_entity.dart';
import '../models/post_model.dart';
import '../data_sources/feed_remote_data_source.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;

  FeedRepositoryImpl({required this.remoteDataSource});

  // Get Newsfeed
  @override
  Future<Either<Failure, List<PostEntity>>> getPosts({
    int? page,
    int limit = 10,
  }) async {
    try {
      final posts = await remoteDataSource.getPosts(page: page, limit: limit);
      return Right(posts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  // Create a Post
  @override
  Future<Either<Failure, PostEntity>> createPost({
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
  }) async {
    try {
      final post = await remoteDataSource.createPost(
        content: content,
        media: media,
        taggedUsers: taggedUsers,
        visibility: visibility,
      );
      return Right(post);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

//   // Like a Post
//   @override
//   Future<Either<Failure, void>> likePost(String postId) async {
//     return _handlePostRequest('posts/$postId/like');
//   }

//   // Unlike a Post
//   @override
//   Future<Either<Failure, void>> unlikePost(String postId) async {
//     return _handlePostRequest('posts/$postId/unlike');
//   }

//   // Comment on a Post
//   @override
//   Future<Either<Failure, void>> commentOnPost({
//     required String postId,
//     required String content,
//     List<String>? taggedUsers,
//   }) async {
//     return _handlePostRequest(
//       'posts/$postId/comment',
//       data: {"content": content, "taggedUsers": taggedUsers ?? []},
//     );
//   }

//   // Delete a Comment
//   @override
//   Future<Either<Failure, void>> deleteComment(String commentId) async {
//     return _handleDeleteRequest('comments/$commentId');
//   }

//   // Repost a Post
//   @override
//   Future<Either<Failure, void>> repostPost({
//     required String authorId,
//     required String postId,
//     required String content,
//     List<String>? taggedUsers,
//     required String visibility,
//     required String authorType,
//   }) async {
//     return _handlePostRequest(
//       'posts/$postId/repost',
//       data: {
//         "authorId": authorId,
//         "postId": postId,
//         "content": content,
//         "taggedUsers": taggedUsers ?? [],
//         "visibility": visibility,
//         "authorType": authorType,
//       },
//     );
//   }

//   // Delete a Post
//   @override
//   Future<Either<Failure, void>> deletePost(String postId) async {
//     return _handleDeleteRequest('posts/$postId');
//   }

//   // 🔹 Helper for POST requests
//   Future<Either<Failure, void>> _handlePostRequest(
//     String path, {
//     Map<String, dynamic>? data,
//   }) async {
//     try {
//       final response = await dio.post(
//         'https://api.example.com/$path',
//         data: data,
//       );
//       return _validateResponse(response);
//     } on DioException catch (e) {
//       return left(_handleDioError(e));
//     } catch (e) {
//       return left(UnknownFailure(e.toString()));
//     }
//   }

//   // 🔹 Helper for DELETE requests
//   Future<Either<Failure, void>> _handleDeleteRequest(String path) async {
//     try {
//       final response = await dio.delete('https://api.example.com/$path');
//       return _validateResponse(response);
//     } on DioException catch (e) {
//       return left(_handleDioError(e));
//     } catch (e) {
//       return left(UnknownFailure(e.toString()));
//     }
//   }

//   // 🔹 Validate API response
//   Either<Failure, void> _validateResponse(Response response) {
//     if (response.statusCode == 200) {
//       return right(null);
//     }
//     return left(ServerFailure());
//   }

//   // 🔹 Handle Dio-specific errors
//   Failure _handleDioError(DioException e) {
//     if (e.type == DioExceptionType.connectionTimeout ||
//         e.type == DioExceptionType.receiveTimeout) {
//       return NetworkFailure();
//     } else if (e.response != null && e.response!.statusCode == 404) {
//       return NotFoundFailure();
//     } else {
//       return ServerFailure();
//     }
//   }
// }
