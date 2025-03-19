// presentation/provider/feed_provider.dart
import 'package:flutter/material.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/entities/post_entity.dart';
import '../../../../core/errors/failures.dart';

class FeedProvider with ChangeNotifier {
  final GetNewsFeedUseCase getNewsFeedUseCase;

  List<Post> _posts = [];
  bool _isLoading = false;
  Failure? _error;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  Failure? get error => _error;

  FeedProvider({required this.getNewsFeedUseCase});

  Future<void> loadPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getNewsFeedUseCase.execute(page: 1, limit: 10);

    result.fold(
      (failure) {
        _error = failure;
        _posts = [];
      },
      (posts) {
        _posts = posts;
        _error = null;
      },
    );

    _isLoading = false;
    notifyListeners();
  }
}
