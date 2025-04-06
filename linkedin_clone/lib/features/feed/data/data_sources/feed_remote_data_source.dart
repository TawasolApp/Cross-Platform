import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:linkedin_clone/features/feed/data/models/comment_model.dart';
import 'package:linkedin_clone/features/feed/domain/entities/post_entity.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/post_model.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/errors/failures.dart';

abstract class FeedRemoteDataSource {
  Future<Either<Failure, List<PostModel>>> getPosts({int? page, int limit});
  Future<Either<Failure, PostModel>> createPost({
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
    String? parentPostId,
    bool isSilentRepost = false,
  });
  Future<void> deletePost(String postId);
  Future<void> savePost(String postId);
  Future<void> reactToPost({
    required String postId,
    required Map<String, bool> reactions,
    required String postType,
  });
  Future<void> editPost({
    required String postId,
    required String content,
    required List<String> media,
    required List<String> taggedUsers,
    required String visibility,
  });
  Future<void> addComment(
    String postId,
    String content, {
    List<String>? tagged,
  });
  Future<List<CommentModel>> fetchComments(
    String postId, {
    int page = 1,
    int limit = 10,
  });
  Future<void> editComment({
    required String commentId,
    required String content,
    required List<String> tagged,
    required bool isReply,
  });
  Future<List<Map<String, dynamic>>> getPostReactions(String postId);
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final Dio dio;

  FeedRemoteDataSourceImpl(this.dio);

  Future<String> _getToken() async {
    final token = await TokenService.getToken();
    if (token == null) throw TokenException("Token not found");
    return token;
  }

  Future<void> _validateResponse(Response response) async {
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      if (response.data == null || response.data is! List) {
        throw ServerException("Invalid response format");
      }
      return;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException("Unauthorized access");
    } else if (response.statusCode == 500) {
      throw ServerException("Internal server error");
    } else {
      throw ServerException("Unexpected status code: ${response.statusCode}");
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getPosts({
    int? page,
    int limit = 10,
  }) async {
    try {
      final queryParams = {'page': page ?? 1, 'limit': limit};
      final token = await _getToken();
      print("Token: $token");
      //final Map<String, dynamic> requestBody = {};

      final response = await dio.get(
        'https://tawasolapp.me/api/posts',
        queryParameters: queryParams,
        //data: requestBody,
        options: Options(headers: {'Authorization': 'Bearer ${token.trim()}'}),
      );

      // Check for successful response
      if (response.statusCode == 200) {
        // Since Dio automatically parses JSON response, directly use response.data
        final List<dynamic> data = response.data;
        final posts = data.map((post) => PostModel.fromJson(post)).toList();
        return Right(posts);
      } else if (response.statusCode == 401) {
        return Left(
          UnauthorizedFailure('Unauthorized access - Please login again.'),
        );
      } else if (response.statusCode == 404) {
        return Left(
          NotFoundFailure('Posts not found - Try refreshing the feed.'),
        );
      } else if (response.statusCode == 500) {
        return Left(ServerFailure('Server error - Please try again later.'));
      } else {
        return Left(
          UnknownFailure(
            'Unexpected error occurred: ${response.statusCode} - ${response.statusMessage}',
          ),
        );
      }
    } catch (e) {
      return Left(NetworkFailure('Failed to connect to server: $e'));
    }
  }

  Future<Either<Failure, PostModel>> createPost({
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
    String? parentPostId,
    bool isSilentRepost = false,
  }) async {
    try {
      final token = await _getToken();
      final data = {
        "content": content,
        "media": media ?? [],
        "taggedUsers": taggedUsers ?? [],
        "visibility": visibility,
        "isSilentRepost": isSilentRepost,
      };

      // Only add parentPostId if it is not null
      if (parentPostId != null) {
        data["parentPostId"] = parentPostId;
      }

      final response = await dio.post(
        'https://tawasolapp.me/api/posts',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        final postModel = PostModel.fromJson(response.data);
        return Right(postModel);
      } else {
        return Left(ServerFailure('Server error: ${response.data['message']}'));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          return Left(ValidationFailure("Bad Request: ${e.response!.data}"));
        } else if (e.response!.statusCode == 401) {
          return Left(UnauthorizedFailure("Unauthorized access"));
        } else {
          return Left(ServerFailure("Server error: ${e.response!.data}"));
        }
      }
      return Left(NetworkFailure("Network error: ${e.message}"));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      final token = await _getToken();
      final response = await dio.delete(
        'https://tawasolapp.me/api/posts/$postId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      _validateResponse(response);
    } catch (e) {
      throw ServerException("Failed to delete post");
    }
  }

  @override
  Future<void> savePost(String postId) async {
    try {
      final token = await _getToken();
      final response = await dio.post(
        'https://tawasolapp.me/api/posts/save/$postId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      _validateResponse(response);
    } catch (e) {
      throw ServerException("Failed to save post");
    }
  }

  @override
  Future<void> addComment(
    String postId,
    String content, {
    List<String>? tagged,
  }) async {
    try {
      final token = await _getToken();
      final response = await dio.post(
        'https://tawasolapp.me/api/posts/comment/$postId',
        data: {"content": content, "tagged": tagged ?? []},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      _validateResponse(response);
    } catch (e) {
      throw ServerException("Failed to add comment");
    }
  }

  @override
  Future<List<CommentModel>> fetchComments(
    String postId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = await _getToken();
      final response = await dio.get(
        'https://tawasolapp.me/api/posts/comments/$postId',
        queryParameters: {'page': page, 'limit': limit},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      _validateResponse(response);

      return (response.data as List)
          .map((comment) => CommentModel.fromJson(comment))
          .toList();
    } catch (e) {
      throw ServerException("Failed to fetch comments");
    }
  }

  @override
  Future<void> editComment({
    required String commentId,
    required String content,
    required List<String> tagged,
    required bool isReply,
  }) async {
    try {
      final token = await _getToken();
      final response = await dio.patch(
        'https://tawasolapp.me/api/posts/comments/$commentId',
        data: {'content': content, 'tagged': tagged, 'isReply': isReply},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      _validateResponse(response);
    } catch (e) {
      throw ServerException("Failed to edit comment");
    }
  }

  @override
  Future<void> editPost({
    required String postId,
    required String content,
    required List<String> media,
    required List<String> taggedUsers,
    required String visibility,
  }) async {
    try {
      final token = await _getToken();
      final response = await dio.patch(
        'https://tawasolapp.me/api/posts/$postId',
        data: {
          "content": content,
          "media": media,
          "taggedUsers": taggedUsers,
          "visibility": visibility,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      _validateResponse(response);
    } catch (e) {
      throw ServerException("Failed to edit post");
    }
  }

  @override
  Future<void> reactToPost({
    required String postId,
    required Map<String, bool> reactions,
    required String postType,
  }) async {
    try {
      final token = await _getToken();
      final response = await dio.post(
        'https://tawasolapp.me/api/posts/react/$postId',
        data: {"reactions": reactions, "postType": postType},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw ServerException("Failed to update reactions");
      }
    } catch (e) {
      throw ServerException("Failed to update reactions: ${e.toString()}");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPostReactions(String postId) async {
    try {
      final token = await _getToken();
      final response = await dio.get(
        'https://tawasolapp.me/api/posts/reactions/$postId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw ServerException('Failed to fetch reactions');
      }
    } catch (e) {
      throw ServerException("Error fetching reactions: ${e.toString()}");
    }
  }
}
