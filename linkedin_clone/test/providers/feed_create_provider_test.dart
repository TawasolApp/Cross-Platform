import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/feed/domain/entities/post_entity.dart';
import 'package:linkedin_clone/features/feed/presentation/provider/feed_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_saved_posts_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_reposts_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_post_by_id_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/search_posts_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_posts_usecase.dart';
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
import 'package:linkedin_clone/features/feed/domain/usecases/get_user_posts_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_post_by_id_usecase.dart';
import 'package:flutter/widgets.dart';

class MockGetSavedPostsUseCase extends Mock implements GetSavedPostsUseCase {}

class MockGetRepostsUseCase extends Mock implements GetRepostsUseCase {}

class MockFetchPostByIdUseCase extends Mock implements FetchPostByIdUseCase {}

class MockSearchPostsUseCase extends Mock implements SearchPostsUseCase {}

class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}

class MockCreatePostUseCase extends Mock implements CreatePostUseCase {}

class MockDeletePostUseCase extends Mock implements DeletePostUseCase {}

class MockSavePostUseCase extends Mock implements SavePostUseCase {}

class MockUnsavePostUseCase extends Mock implements UnsavePostUseCase {}

class MockEditPostUseCase extends Mock implements EditPostUseCase {}

class MockCommentPostUseCase extends Mock implements CommentPostUseCase {}

class MockDeleteCommentUseCase extends Mock implements DeleteCommentUseCase {}

class MockFetchCommentsUseCase extends Mock implements FetchCommentsUseCase {}

class MockEditCommentUseCase extends Mock implements EditCommentUseCase {}

class MockReactToPostUseCase extends Mock implements ReactToPostUseCase {}

class MockGetPostReactionsUseCase extends Mock
    implements GetPostReactionsUseCase {}

class MockGetUserPostsUseCase extends Mock implements GetUserPostsUseCase {}

class MockGetPostByIdUseCase extends Mock implements FetchPostByIdUseCase {}

void main() {
  late FeedProvider provider;
  late MockGetSavedPostsUseCase getSavedPosts;
  late MockGetRepostsUseCase getReposts;
  late MockFetchPostByIdUseCase getPostById;
  late MockSearchPostsUseCase searchPosts;
  late MockGetPostsUseCase getPosts;
  late MockCreatePostUseCase createPost;
  late MockDeletePostUseCase deletePost;
  late MockSavePostUseCase savePost;

  late MockUnsavePostUseCase unsavePost;
  late MockEditPostUseCase editPost;
  late MockCommentPostUseCase commentPost;
  late MockDeleteCommentUseCase deleteComment;
  late MockFetchCommentsUseCase fetchComments;
  late MockEditCommentUseCase editComment;
  late MockReactToPostUseCase reactToPost;
  late MockGetPostReactionsUseCase getPostReactions;
  late MockGetUserPostsUseCase getUserPosts;
  late MockGetPostByIdUseCase fetchPostById;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(<String>[]);
    registerFallbackValue('');
    registerFallbackValue(true);
  });

  setUp(() {
    getSavedPosts = MockGetSavedPostsUseCase();
    getReposts = MockGetRepostsUseCase();
    getPostById = MockFetchPostByIdUseCase();
    searchPosts = MockSearchPostsUseCase();
    getPosts = MockGetPostsUseCase();
    createPost = MockCreatePostUseCase();
    deletePost = MockDeletePostUseCase();
    savePost = MockSavePostUseCase();
    unsavePost = MockUnsavePostUseCase();
    editPost = MockEditPostUseCase();
    commentPost = MockCommentPostUseCase();
    deleteComment = MockDeleteCommentUseCase();
    fetchComments = MockFetchCommentsUseCase();
    editComment = MockEditCommentUseCase();
    reactToPost = MockReactToPostUseCase();
    getPostReactions = MockGetPostReactionsUseCase();
    getUserPosts = MockGetUserPostsUseCase();
    getSavedPosts = MockGetSavedPostsUseCase();
    getReposts = MockGetRepostsUseCase();
    getPostById = MockFetchPostByIdUseCase();
    searchPosts = MockSearchPostsUseCase();

    provider = FeedProvider(
      getPostsUseCase: getPosts,
      createPostUseCase: createPost,
      deletePostUseCase: deletePost,
      savePostUseCase: savePost,

      unsavePostUseCase: unsavePost,
      editPostUseCase: editPost,
      commentPostUseCase: commentPost,
      deleteCommentUseCase: deleteComment,
      fetchCommentsUseCase: fetchComments,
      editCommentUseCase: editComment,
      reactToPostUseCase: reactToPost,
      getPostReactionsUseCase: getPostReactions,
      getUserPostsUseCase: getUserPosts,

      getSavedPostsUseCase: getSavedPosts,
      getRepostsUseCase: getReposts,
      fetchPostByIdUseCase: getPostById,
      searchPostsUseCase: searchPosts,
    );
  });

  PostEntity mockPost({
    String id = "1",
    String content = "Post",
    bool isSaved = false,
  }) {
    return PostEntity(
      id: id,
      content: content,
      authorId: "1",
      authorName: "User",
      authorBio: "Bio",
      authorPicture: null,
      authorType: "user",
      timestamp: DateTime.now(),
      visibility: "Public",
      isSaved: isSaved,
      isEdited: false,
      reactType: "",
      reactions: {},
      reactCounts: {},
      comments: 0,
      shares: 0,
      media: [],
      taggedUsers: [],
      isConnected: false,
      isFollowing: false,
      isSilentRepost: false,
    );
  }

  test('fetchSavedPosts - success', () async {
    when(() => getSavedPosts(any(named: "page"))).thenAnswer(
      (_) async => Right([mockPost(id: "s1", content: "Saved post")]),
    );

    await provider.fetchSavedPosts();

    expect(provider.savedPosts.length, 1);
    expect(provider.savedPosts.first.id, "s1");
  });

  test('fetchSavedPosts - failure', () async {
    when(
      () => getSavedPosts(any(named: "page")),
    ).thenAnswer((_) async => Left(ServerFailure()));

    await provider.fetchSavedPosts();

    expect(provider.savedPosts.isEmpty, true);
    expect(provider.errorMessage, isNotNull);
  });

  test('fetchReposts - success', () async {
    when(
      () => getReposts(
        page: any(named: "page"),
        postId: any(named: "postId"),
        limit: any(named: "limit"),
        userId: any(named: "userId"),
      ),
    ).thenAnswer((_) async => Right([mockPost(id: "r1", content: "Repost")]));

    await provider.fetchReposts("somePostId");

    expect(provider.reposts.length, 1);
    expect(provider.reposts.first.id, "r1");
  });

  test('fetchReposts - failure', () async {
    when(
      () => getReposts(
        page: any(named: "page"),
        postId: any(named: "postId"),
        limit: any(named: "limit"),
        userId: any(named: "userId"),
      ),
    ).thenAnswer((_) async => Left(ServerFailure()));

    await provider.fetchReposts("somePostId");

    expect(provider.reposts.isEmpty, true);
    expect(provider.errorMessage, isNotNull);
  });

  test('getPostById - success', () async {
    final post = mockPost(id: "xyz", content: "Detail View");

    when(
      () => getPostById(
        userId: any(named: "userId"),
        postId: any(named: "postId"),
      ),
    ).thenAnswer((_) async => Right(post));

    final result = await provider.fetchPostById("user123", "xyz");

    expect(result?.id, "xyz");
    expect(result?.content, "Detail View");
  });

  test('getPostById - failure', () async {
    when(
      () => getPostById(
        userId: any(named: "userId"),
        postId: any(named: "postId"),
      ),
    ).thenAnswer((_) async => Left(ServerFailure()));

    final result = await provider.fetchPostById("user123", "xyz");

    expect(result, isNull);
    expect(provider.errorMessage, isNotNull);
  });

  test('searchPosts - success', () async {
    when(
      () => searchPosts(
        companyId: any(named: "companyId"),
        query: "flutter",
        page: any(named: "page"),
        limit: any(named: "limit"),
      ),
    ).thenAnswer(
      (_) async => Right([mockPost(id: "search1", content: "Flutter Rocks")]),
    );

    await provider.searchPosts(
      "flutter",
      query: 'flutter',
      page: 1,
      limit: 10,
      companyId: null,
    );

    expect(provider.searchResults.length, 1);
    expect(provider.searchResults.first.content, "Flutter Rocks");
  });
}
