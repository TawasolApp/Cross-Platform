import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/post_model.dart';

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
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final Dio dio;
  final String mockToken = 'mock_bearer_token';

  FeedRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PostModel>> getPosts({int? page, int limit = 10}) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};

      if (page != null) {
        queryParams['page'] = page;
      }

      final response = await dio.get('/posts', queryParameters: queryParams);

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
      final response = await dio.post(
        '/posts',
        data: {
          "content": content,
          "media": media ?? [],
          "taggedUsers": taggedUsers ?? [],
          "visibility": visibility,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $mockToken",
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
    final token = 'mock_Bearer_token';

    final response = await dio.delete(
      'https://your-api.com/posts/$postId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode != 204) {
      throw ServerException(
        'Failed to delete post. Status code: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> savePost(String postId) async {
    final response = await dio.post(
      'https://your-api.com/posts/save/$postId',
      options: Options(headers: {'Authorization': 'Bearer your_token'}),
    );

    if (response.statusCode != 200) {
      throw ServerException('Failed to save post');
    }
  }

  @override
  Future<void> reactToPost({
    required String postId,
    required Map<String, bool> reactions,
    required String postType,
  }) async {
    final response = await dio.post(
      'https://your-api.com/posts/react/$postId',
      data: {"reactions": reactions, "postType": postType},
      options: Options(
        headers: {
          //'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw ServerException("Failed to update reaction");
    }
  }
}
