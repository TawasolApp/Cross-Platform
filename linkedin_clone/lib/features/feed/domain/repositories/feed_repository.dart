import '../../../../core/errors/failures.dart';
import '../entities/post_entity.dart';
import 'package:fpdart/fpdart.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/reaction_model.dart';

abstract class FeedRepository {
  Future<Either<Failure, List<PostEntity>>> getPosts(
    String userId, {
    int page,
    int limit,
  });
  Future<Either<Failure, List<PostEntity>>> getUserPosts(
    String companyId,
    String userId, {
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, PostEntity>> createPost(
    String userId, {
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
    String? parentPostId,
    bool isSilentRepost = false,
  });
  Future<Either<Failure, Unit>> deletePost(String userId, String postId);
  Future<Either<Failure, Unit>> savePost(String userId, String postId);
  Future<Either<Failure, Unit>> unsavePost(String userId, String postId);
  Future<Either<Failure, Unit>> reactToPost(
    String userId, {
    required String postId,
    required Map<String, bool> reactions,
    required String postType,
  });
  Future<Either<Failure, List<ReactionModel>>> getPostReactions(
    String userId,
    String postId, {
    String type = 'All',
  });

  Future<Either<Failure, Unit>> editPost(
    String userId, {
    required String postId,
    required String content,
    required List<String>? media,
    required List<String>? taggedUsers,
    required String visibility,
  });
  Future<Either<Failure, CommentModel>> addComment(
    String userId, {
    required String postId,
    required String content,
    List<String>? taggedUsers,
    bool isReply = false,
  });
  Future<Either<Failure, List<CommentModel>>> fetchComments(
    String userId,
    String postId, {
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, Unit>> editComment(
    String userId, {
    required String commentId,
    required String content,
    List<String>? tagged,
    bool isReply,
  });
  Future<Either<Failure, Unit>> deleteComment(String userId, String commentId);
  Future<Either<Failure, List<PostEntity>>> getSavedPosts(
    String companyId, {
    int page,
    int limit,
  });
}
