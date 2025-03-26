// features/feed/domain/repositories/feed_repository.dart
import '../../../../core/errors/failures.dart';
import '../entities/post_entity.dart';
import 'package:fpdart/fpdart.dart';
//import 'package:dartz/dartz.dart' as dartz;

abstract class FeedRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts({
    int? page,
    int limit = 10,
  });
  Future<Either<Failure, PostEntity>> createPost({
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
  });
  Future<Either<Failure, void>> deletePost(String postId);
  Future<Either<Failure, Unit>> savePost(String postId);
  Future<Either<Failure, Unit>> reactToPost({
    required String postId,
    required Map<String, bool> reactions,
    required String postType,
  });
}
//   Future<Either<Failure, void>> likePost(String postId);

//   Future<Either<Failure, void>> unlikePost(String postId);

//   Future<Either<Failure, void>> commentOnPost({
//     required String postId,
//     required String content,
//     List<String>? taggedUsers,
//   });

//   Future<Either<Failure, void>> deleteComment(String commentId);

//   Future<Either<Failure, void>> repostPost({
//     required String authorId,
//     required String postId,
//     required String content,
//     List<String>? taggedUsers,
//     required String visibility,
//     required String authorType,
//   });
