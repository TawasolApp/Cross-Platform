import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/post_model.dart';

abstract class FeedRemoteDataSource {
  Future<List<PostModel>> getNewsFeed({int? page, int limit});
}

class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  final Dio dio;

  FeedRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PostModel>> getNewsFeed({int? page, int limit = 10}) async {
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
}
