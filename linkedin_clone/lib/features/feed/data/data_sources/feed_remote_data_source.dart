// features/feed/data/data_sources/feed_remote_data_source.dart
import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/post_model.dart';

abstract class FeedRemoteDataSource {
  Future<List<PostModel>> getNewsFeed({required int page, required int limit});
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final Dio dio;

  FeedRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PostModel>> getNewsFeed({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await dio.get(
        '/posts',
        queryParameters: {'page': page, 'limit': limit},
      );
      return (response.data as List)
          .map((json) => PostModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch posts');
    }
  }
}
