import 'package:mockito/annotations.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_post_by_id_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/search_posts_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_news_feed_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_user_posts_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/create_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/delete_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/save_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/unsave_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/edit_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/comment_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/delete_comment_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/fetch_comments_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/edit_comment_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/react_to_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_post_reactions_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_saved_posts_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_reposts_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_post_by_id_usecase.dart';

// Import other usecases...

@GenerateMocks([
  FetchPostByIdUseCase,
  SearchPostsUseCase,
  GetNewsFeedUseCase,
  GetUserPostsUseCase,
  CreatePostUseCase,
  DeletePostUseCase,
  SavePostUseCase,
  UnsavePostUseCase,
  EditPostUseCase,
  CommentPostUseCase,
  DeleteCommentUseCase,
  FetchCommentsUseCase,
  EditCommentUseCase,
  ReactToPostUseCase,
  GetPostReactionsUseCase,
  GetSavedPostsUseCase,
  GetRepostsUseCase,

  // Add all the usecases you want to mock
])
void main() {}
