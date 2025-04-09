import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/post_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/services/token_service.dart';

abstract class FeedRemoteDataSource {
  Future<List<PostModel>> getPosts({int? page, int limit});
  Future<PostModel> createPost({
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
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
  Future<void> addComment(String postId, String content);
  Future<List<dynamic>> fetchComments(
    String postId, {
    int page = 1,
    int limit = 10,
  });
  Future<void> editComment({
    required String commentId,
    required String content,
    required List<String> taggedUsers,
    required bool isReply,
  });
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final Dio dio;

  FeedRemoteDataSourceImpl(this.dio);
  Future<String> _getToken() async {
    final token = await TokenService.getToken();
    if (token == null) throw Exception("No token found");
    return token;
  }

  @override
  Future<List<PostModel>> getPosts({int? page, int limit = 10}) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};

      if (page != null) {
        queryParams['page'] = page;
      }
      final token = await _getToken();

      final response = await dio.get(
        'https://tawasolapp.me/api/posts',
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return (response.data as List)
          .map((json) => PostModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch posts');
    }
  }

  @override
  Future<PostModel> createPost({
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
  }) async {
    try {
      final token = await _getToken();
      final response = await dio.post(
        'https://tawasolapp.me/api/posts',
        data: {
          "content": content,
          "media": media ?? [],
          "taggedUsers": taggedUsers ?? [],
          "visibility": visibility,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 201) {
        return PostModel.fromJson(response.data);
      } else {
        throw ServerException("Failed to create post");
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to create post');
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

      if (response.statusCode != 204) {
        throw ServerException(
          'Failed to delete post. Status code: ${response.statusCode}',
        );
      }
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

      if (response.statusCode != 200) {
        throw ServerException('Failed to save post');
      }
    } catch (e) {
      throw ServerException("Failed to save post");
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
        throw ServerException("Failed to update reaction");
      }
    } catch (e) {
      throw ServerException("Failed to update reaction");
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
      if (response.statusCode != 200) {
        throw Exception("Edit post failed");
      }
    } catch (e) {
      throw ServerException("Edit post failed");
    }
  }

  @override
  Future<void> addComment(String postId, String content) async {
    try {
      final token = await _getToken();
      final response = await dio.post(
        'https://tawasolapp.me/api/posts/comment/$postId',
        data: {"content": content},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to add comment");
      }
    } catch (e) {
      throw ServerException("Failed to add comment");
    }
  }

  @override
  Future<List<dynamic>> fetchComments(
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

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ServerException("Failed to fetch comments");
      }
    } catch (e) {
      throw ServerException("Failed to fetch comments");
    }
  }

  @override
  Future<void> editComment({
    required String commentId,
    required String content,
    required List<String> taggedUsers,
    required bool isReply,
  }) async {
    try {
      final response = await dio.patch(
        'https://tawasolapp.me/api/posts/comments/$commentId',
        data: {'content': content, 'tagged': taggedUsers, 'isReply': isReply},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update comment');
      }
    } catch (e) {
      throw Exception('Failed to update comment: ${e.toString()}');
    }
  }
}
