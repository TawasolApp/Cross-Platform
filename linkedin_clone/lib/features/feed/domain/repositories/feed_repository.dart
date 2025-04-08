import '../../../../core/errors/failures.dart';
import '../entities/post_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../data/models/comment_model.dart';

abstract class FeedRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts({int page, int limit});
  Future<Either<Failure, List<PostEntity>>> getUserPosts(
    String userId, {
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, PostEntity>> createPost({
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
    String? parentPostId,
    bool isSilentRepost = false,
  });
  Future<Either<Failure, Unit>> deletePost(String postId);
  Future<Either<Failure, Unit>> savePost(String postId);
  Future<Either<Failure, Unit>> unsavePost(String postId);
  Future<Either<Failure, Unit>> reactToPost({
    required String postId,
    required Map<String, bool> reactions,
    required String postType,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> getPostReactions(
    String postId,
  );

  Future<Either<Failure, Unit>> editPost({
    required String postId,
    required String content,
    required List<String>? media,
    required List<String>? taggedUsers,
    required String visibility,
  });
  Future<Either<Failure, CommentModel>> addComment({
    required String postId,
    required String content,
    List<String>? taggedUsers,
    bool isReply = false,
  });
  Future<Either<Failure, List<CommentModel>>> fetchComments(
    String postId, {
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, Unit>> editComment({
    required String commentId,
    required String content,
    List<String>? tagged,
    bool isReply,
  });
}
