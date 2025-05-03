import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:linkedin_clone/features/feed/data/models/comment_model.dart';
import 'package:linkedin_clone/features/feed/domain/entities/post_entity.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/post_model.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/errors/failures.dart';
import '../models/reaction_model.dart';

abstract class FeedRemoteDataSource {
  Future<Either<Failure, List<PostModel>>> getPosts(
    String userId, {
    int? page,
    int limit,
  });
  Future<Either<Failure, PostModel>> createPost(
    String userId, {
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
    String? parentPostId,
    bool isSilentRepost = false,
  });
  Future<void> deletePost(String userId, String postId);
  Future<Either<Failure, Unit>> savePost(String userId, String postId);
  Future<Either<Failure, Unit>> unsavePost(String userId, String postId);
  Future<void> reactToPost(
    String userId, {
    required String postId,
    required Map<String, bool> reactions,
    required String postType,
  });
  Future<void> editPost(
    String userId, {
    required String postId,
    required String content,
    required List<String> media,
    required List<String> taggedUsers,
    required String visibility,
  });
  Future<Either<Failure, CommentModel>> addComment(
    String userId, {
    required String postId,
    required String content,
    List<String>? tagged,
    bool isReply = false,
  });
  Future<List<CommentModel>> fetchComments(
    String userId,
    String postId, {
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, Unit>> editComment(
    String userId, {
    required String commentId,
    required String content,
    required List<String> tagged,
    required bool isReply,
  });

  //here is the only one where they're both different
  Future<Either<Failure, List<PostModel>>> getUserPosts(
    String companyId,
    String userId, {
    int? page,
    int limit,
  });
  Future<void> deleteComment(String userId, String commentId);
  Future<List<ReactionModel>> getPostReactions(
    String userId,
    String postId, {
    String type = 'All',
  });
  Future<Either<Failure, List<PostEntity>>> getSavedPosts(
    String companyId, {
    int page = 1,
    int limit = 10,
  });
  Future<PostEntity> fetchPostById({
    required String userId,
    required String postId,
  });
  Future<Either<Failure, List<PostModel>>> getReposts({
    required String userId,
    required String postId,
    int page,
    int limit,
  });
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
  Future<Either<Failure, List<PostModel>>> getPosts(
    String userId, {
    int? page,
    int limit = 10,
  }) async {
    try {
      final queryParams = {'page': page ?? 1, 'limit': limit};
      final token = await _getToken();
      print("Token: $token");
      //final Map<String, dynamic> requestBody = {};

      final response = await dio.get(
        'https://tawasolapp.me/api/posts/$userId',
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

  @override
  Future<Either<Failure, PostModel>> createPost(
    String userId, {
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

      if (parentPostId != null) {
        data["parentPostId"] = parentPostId;
      }

      final response = await dio.post(
        'https://tawasolapp.me/api/posts/$userId',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
          return Left(
            ServerFailure("Data Source Server error: ${e.response!.data}"),
          );
        }
      }
      return Left(NetworkFailure("Network error: ${e.message}"));
    } catch (e) {
      return Left(ServerFailure("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<void> deletePost(String userId, String postId) async {
    try {
      final token = await _getToken();
      print('Deleting post with ID: $postId');
      print('Authorization token: Bearer $token');

      final response = await dio.delete(
        'https://tawasolapp.me/api/posts/$userId/$postId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('Remote Data Source: Response status: ${response.statusCode}');
      print('Remote Data Source: Response data: ${response.data}');

      if (response.statusCode != 204) {
        throw Exception('Failed to delete post');
      }
    } on DioException catch (e) {
      print('Remote Data Source: Dio error occurred!');
      print('Error message: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');

      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          throw UnauthorizedFailure("Unauthorized access");
        } else if (e.response!.statusCode == 403) {
          throw ServerFailure("Forbidden: Access denied");
        } else if (e.response!.statusCode == 404) {
          throw ServerFailure("Post not found");
        } else if (e.response!.statusCode == 500) {
          throw ServerFailure("Server error: Internal server error");
        } else {
          throw ServerFailure("Unexpected error: ${e.response!.data}");
        }
      } else {
        throw NetworkFailure("Network error: ${e.message}");
      }
    } catch (e) {
      print('Remote Data Source: Unknown error occurred!');
      print('Error: $e');
      throw ServerFailure("Unexpected error: ${e.toString()}");
    }
  }

  @override
  Future<Either<Failure, Unit>> savePost(String userId, String postId) async {
    try {
      final token = await _getToken();
      final response = await dio.post(
        'https://tawasolapp.me/api/posts/$userId/save/$postId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return const Right(unit);
      } else if (response.statusCode == 400) {
        return Left(ServerFailure("Post already saved"));
      } else if (response.statusCode == 404) {
        return Left(ServerFailure("Post not found"));
      } else {
        return Left(ServerFailure("Failed to save post"));
      }
    } on DioException catch (e) {
      return Left(ServerFailure("Server error: ${e.message}"));
    }
  }

  @override
  Future<Either<Failure, Unit>> unsavePost(String userId, String postId) async {
    try {
      final token = await _getToken();
      final response = await dio.delete(
        'https://tawasolapp.me/api/posts/$userId/save/$postId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return const Right(unit);
      } else if (response.statusCode == 404) {
        return Left(ServerFailure("Save not found"));
      } else {
        return Left(ServerFailure("Failed to delete save"));
      }
    } on DioException catch (e) {
      return Left(ServerFailure("Server error: ${e.message}"));
    }
  }

  @override
  Future<Either<Failure, CommentModel>> addComment(
    String userId, {
    required String postId,
    required String content,
    List<String>? tagged,
    bool isReply = false,
  }) async {
    try {
      print('Adding comment to post with ID: $postId');
      final token = await _getToken();
      final response = await dio.post(
        'https://tawasolapp.me/api/posts/$userId/comment/$postId',
        data: {
          "content": content,
          "taggedUsers": tagged ?? [],
          "isReply": isReply,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successfully created comment, return as CommentModel
        final comment = CommentModel.fromJson(response.data);
        return Right(comment);
      } else {
        // Handle unexpected status codes
        return Left(
          ServerFailure('Failed to add comment: ${response.statusCode}'),
        );
      }
    } on DioException catch (e) {
      print('DioException adding comment: $e');
      if (e.response != null) {
        return Left(ServerFailure('Error: ${e.response?.data['message']}'));
      }
      return Left(NetworkFailure('Network error: ${e.message}'));
    } catch (e) {
      print('Unexpected error adding comment: $e');
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<List<CommentModel>> fetchComments(
    String userId,
    String postId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = await _getToken();
      final response = await dio.get(
        'https://tawasolapp.me/api/posts/$userId/comments/$postId',
        queryParameters: {'page': page, 'limit': limit},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data ?? [];
        return data.map((item) => CommentModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch comments');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }

  @override
  Future<Either<Failure, Unit>> editComment(
    String userId, {
    required String commentId,
    required String content,
    required List<String> tagged,
    required bool isReply,
  }) async {
    try {
      final token = await _getToken();
      final response = await dio.patch(
        'https://tawasolapp.me/api/posts/$userId/comment/$commentId',
        data: {'content': content, 'tagged': tagged, 'isReply': isReply},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      _validateResponse(response);

      return right(unit); // Success
    } on UnauthorizedException catch (e) {
      return left(UnauthorizedFailure(e.message));
    } on ForbiddenException catch (e) {
      return left(ForbiddenFailure(e.message));
    } on NotFoundException catch (e) {
      return left(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> editPost(
    String userId, {
    required String postId,
    required String content,
    List<String>? media,
    List<String>? taggedUsers,
    required String visibility,
  }) async {
    try {
      final token = await _getToken();
      final data = {
        "content": content,
        "visibility": visibility,
        "media": media ?? [],
        "taggedUsers": taggedUsers ?? [],
      };

      final response = await dio.patch(
        'https://tawasolapp.me/api/posts/$userId/$postId',
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return const Right(unit);
      } else {
        return Left(ServerFailure('Server error: ${response.data['message']}'));
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 400) {
          return Left(ValidationFailure("Bad Request: ${e.response!.data}"));
        } else if (e.response!.statusCode == 401) {
          return Left(UnauthorizedFailure("Unauthorized access"));
        } else if (e.response!.statusCode == 404) {
          return Left(ServerFailure("Post not found"));
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
  Future<void> reactToPost(
    String userId, {
    required String postId,
    required Map<String, bool> reactions,
    required String postType,
  }) async {
    try {
      final token = await _getToken();
      final response = await dio.post(
        'https://tawasolapp.me/api/posts/$userId/react/$postId',
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
  Future<List<ReactionModel>> getPostReactions(
    String userId,
    String postId, {
    String type = 'All',
  }) async {
    try {
      final token = await _getToken();
      final response = await dio.get(
        'https://tawasolapp.me/api/posts/$userId/reactions/$postId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => ReactionModel.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        throw ServerException('Failed to fetch reactions');
      }
      throw ServerException('Unexpected error: ${response.statusCode}');
    } catch (e) {
      throw ServerException("Error fetching reactions: ${e.toString()}");
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getUserPosts(
    String companyId,
    String userId, {
    int? page,
    int limit = 10,
  }) async {
    try {
      final token = await _getToken();
      final queryParams = {'page': page ?? 1, 'limit': limit};
      final response = await dio.get(
        'https://tawasolapp.me/api/posts/$companyId/user/$userId',
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final posts = data.map((post) => PostModel.fromJson(post)).toList();
        return Right(posts);
      } else if (response.statusCode == 401) {
        return Left(
          UnauthorizedFailure('Unauthorized access - Please login again.'),
        );
      } else if (response.statusCode == 404) {
        return Left(NotFoundFailure('User not found - Try again.'));
      } else if (response.statusCode == 500) {
        return Left(ServerFailure('Server error - Please try again later.'));
      } else {
        return Left(
          UnexpectedFailure(
            'Unexpected error: ${response.statusCode} - ${response.statusMessage}',
          ),
        );
      }
    } catch (e) {
      return Left(NetworkFailure('Failed to connect to server: $e'));
    }
  }

  @override
  Future<void> deleteComment(String userId, String commentId) async {
    final token = await _getToken();
    final response = await dio.delete(
      'https://tawasolapp.me/api/posts/$userId/comment/$commentId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 204) {
      return;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException("Unauthorized access");
    } else if (response.statusCode == 403) {
      throw ForbiddenException();
    } else if (response.statusCode == 404) {
      throw NotFoundException("Comment not found");
    } else {
      throw ServerException("A server error occurred");
    }
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getSavedPosts(
    String companyId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = await _getToken(); // your token method
      final response = await dio.get(
        'https://tawasolapp.me/api/posts/$companyId/saved',
        queryParameters: {'page': page, 'limit': limit},
        options: Options(headers: {'Authorization': 'Bearer ${token.trim()}'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final posts = data.map((post) => PostModel.fromJson(post)).toList();
        return Right(posts);
      } else if (response.statusCode == 401) {
        return Left(UnauthorizedFailure('Unauthorized access.'));
      } else if (response.statusCode == 404) {
        return Left(NotFoundFailure('No saved posts found.'));
      } else if (response.statusCode == 500) {
        return Left(ServerFailure('Server error.'));
      } else {
        return Left(UnknownFailure('Unexpected error: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(NetworkFailure('Failed to connect to server: $e'));
    }
  }

  @override
  Future<PostEntity> fetchPostById({
    required String userId,
    required String postId,
  }) async {
    final token = await _getToken();

    final response = await dio.get(
      'https://tawasolapp.me/api/posts/$userId/$postId',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      return PostModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception("Post not found");
    } else {
      throw Exception("Unexpected response or failed request");
    }
  }

  @override
  Future<Either<Failure, List<PostModel>>> getReposts({
    required String userId,
    required String postId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final token = await _getToken();
      final response = await dio.get(
        'https://tawasolapp.me/api/posts/$userId/$postId/reposts',
        queryParameters: {'page': page, 'limit': limit},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final posts =
          (response.data as List)
              .map((json) => PostModel.fromJson(json))
              .toList();

      return Right(posts);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
