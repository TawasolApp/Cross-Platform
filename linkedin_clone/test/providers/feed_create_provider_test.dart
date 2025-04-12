import 'package:flutter_test/flutter_test.dart';
import 'package:linkedin_clone/features/feed/domain/entities/post_entity.dart';
import 'package:linkedin_clone/features/feed/presentation/provider/feed_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:linkedin_clone/core/errors/failures.dart';
import 'package:linkedin_clone/features/feed/data/models/comment_model.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/comment_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/create_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/delete_comment_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/delete_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/edit_comment_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/edit_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/fetch_comments_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_post_reactions_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_posts_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_user_posts_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/react_to_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/save_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/unsave_post_usecase.dart';

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

void main() {
  late FeedProvider provider;

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

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(<String>[]);
    registerFallbackValue('');
    registerFallbackValue(true);
  });

  setUp(() {
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

    provider = FeedProvider(
      getPostsUseCase: getPosts,
      createPostUseCase: createPost,
      deletePostUseCase: deletePost,
      savePostUseCase: savePost,
      editPostUseCase: editPost,
      commentPostUseCase: commentPost,
      fetchCommentsUseCase: fetchComments,
      editCommentUseCase: editComment,
      reactToPostUseCase: reactToPost,
      getPostReactionsUseCase: getPostReactions,
      unsavePostUseCase: unsavePost,
      getUserPostsUseCase: getUserPosts,
      deleteCommentUseCase: deleteComment,
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

  test('fetchPosts - success', () async {
    when(
      () => getPosts(page: any(named: "page"), limit: any(named: "limit")),
    ).thenAnswer((_) async => Right([mockPost()]));

    await provider.fetchPosts();

    expect(provider.posts.length, 1);
    expect(provider.posts.first.content, "Post");
  });

  test('createPost - success', () async {
    final post = mockPost(content: "New");
    when(
      () => createPost(
        content: any(named: "content"),
        media: any(named: "media"),
        taggedUsers: any(named: "taggedUsers"),
        visibility: any(named: "visibility"),
        parentPostId: any(named: "parentPostId"),
        isSilentRepost: any(named: "isSilentRepost"),
      ),
    ).thenAnswer((_) async => Right(post));

    await provider.createPost(content: "New", media: [], visibility: "Public");

    expect(provider.posts.first.content, "New");
  });

  test('savePost - success', () async {
    final post = mockPost(id: "1", isSaved: false);
    provider.posts.add(post);
    when(() => savePost("1")).thenAnswer((_) async => Right(unit));

    await provider.savePost("1");
    expect(provider.posts.first.isSaved, true);
  });

  test('unsavePost - success', () async {
    final post = mockPost(id: "1", isSaved: true);
    provider.posts.add(post);
    when(() => unsavePost("1")).thenAnswer((_) async => Right(unit));

    await provider.unsavePost("1");
    expect(provider.posts.first.isSaved, false);
  });

  test('deletePost - success', () async {
    final post = mockPost(id: "1");
    provider.posts.add(post);
    when(() => deletePost("1")).thenAnswer((_) async => Right(unit));

    await provider.deletePost("1");
    expect(provider.posts.any((p) => p.id == "1"), false);
  });

  test('editPost - success', () async {
    final post = mockPost(id: "1", content: "Old");
    provider.posts.add(post);
    when(
      () => editPost(
        postId: "1",
        content: "Updated",
        media: [],
        taggedUsers: [],
        visibility: "Connections",
      ),
    ).thenAnswer((_) async => Right(unit));

    await provider.editPost(
      postId: "1",
      content: "Updated",
      media: [],
      taggedUsers: [],
      visibility: "Connections",
    );

    expect(provider.posts.first.content, "Updated");
  });

  test('reactToPost - success', () async {
    final post = mockPost(id: "1");
    provider.posts.add(post);

    final reactions = {"Like": true, "Love": false, "Funny": false};
    when(
      () => reactToPost(
        postId: "1",
        reactions: reactions,
        postType: any(named: "postType"),
      ),
    ).thenAnswer((_) async => Right(unit));

    await provider.reactToPost("1", reactions, "normal");

    expect(provider.posts.first.reactType, "Like");
  });
  test('addComment - success', () async {
    final post = mockPost(id: "1");
    provider.posts.add(post);

    final comment = CommentModel(
      id: "c1",
      content: "Nice post!",
      postId: "1",
      authorId: "u1",
      authorName: "Tester",
      authorPicture: "url",
      authorBio: "Bio",
      reactCount: 0,
      timestamp: DateTime.now(),
      replies: [],
      taggedUsers: [],
    );

    when(
      () => commentPost(postId: "1", content: "Nice post!", isReply: false),
    ).thenAnswer((_) async => Right(comment));

    await provider.addComment("1", "Nice post!", false);

    expect(provider.comments.length, 1);
    expect(provider.comments.first.content, "Nice post!");
    expect(provider.posts.first.comments, 1);
  });
  test('deleteComment - success', () async {
    final comment = CommentModel(
      id: "c1",
      content: "To delete",
      postId: "1",
      authorId: "u1",
      authorName: "Tester",
      authorPicture: "url",
      authorBio: "Bio",
      reactCount: 0,
      timestamp: DateTime.now(),
      replies: [],
      taggedUsers: [],
    );

    provider.comments.add(comment);

    when(() => deleteComment("c1")).thenAnswer((_) async => Right(unit));
    when(
      () => fetchComments(
        "1",
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer(
      (_) async => Right([]),
    ); // mocked because called inside deleteComment

    await provider.deleteComment("1", "c1");

    expect(provider.comments.any((c) => c.id == "c1"), false);
  });
  test('editComment - success', () async {
    final comment = CommentModel(
      id: "c1",
      content: "Old content",
      postId: "1",
      authorId: "u1",
      authorName: "Tester",
      authorPicture: "url",
      authorBio: "Bio",
      reactCount: 0,
      timestamp: DateTime.now(),
      replies: [],
      taggedUsers: [],
    );

    provider.comments.add(comment);

    when(
      () => editComment(
        commentId: "c1",
        content: "Updated comment",
        tagged: any(named: "tagged"),
        isReply: any(named: "isReply"),
      ),
    ).thenAnswer((_) async => Right(unit));

    when(
      () => fetchComments(
        "1",
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => Right([]));

    await provider.editComment(
      commentId: "c1",
      updatedContent: "Updated comment",
      taggedUsers: [],
      isReply: false,
    );

    expect(provider.comments.first.content, "Updated comment");
  });
  test('getPostReactions - success', () async {
    final reactions = [
      {"reaction": "Like", "count": 3},
      {"reaction": "Love", "count": 1},
    ];

    when(() => getPostReactions("1")).thenAnswer((_) async => Right(reactions));

    final result = await provider.getPostReactions("1");

    expect(result.length, 2);
    expect(result.first["reaction"], "Like");
  });
  test('fetchUserPosts - success', () async {
    final userPosts = [mockPost(id: "u1", content: "User post")];

    when(
      () => getUserPosts(
        "user123",
        page: any(named: "page"),
        limit: any(named: "limit"),
      ),
    ).thenAnswer((_) async => Right(userPosts));

    await provider.fetchUserPosts("user123");

    expect(provider.userPosts.length, 1);
    expect(provider.userPosts.first.content, "User post");
  });

  test('fetchPosts - failure', () async {
    when(
      () => getPosts(page: any(named: "page"), limit: any(named: "limit")),
    ).thenAnswer((_) async => Left(ServerFailure()));

    await provider.fetchPosts();

    expect(provider.posts.length, 0);
    expect(provider.errorMessage, isNotNull);
  });
  test('createPost - failure', () async {
    when(
      () => createPost(
        content: any(named: "content"),
        media: any(named: "media"),
        taggedUsers: any(named: "taggedUsers"),
        visibility: any(named: "visibility"),
        parentPostId: any(named: "parentPostId"),
        isSilentRepost: any(named: "isSilentRepost"),
      ),
    ).thenAnswer((_) async => Left(ServerFailure()));

    await provider.createPost(content: "Fail", media: [], visibility: "Public");

    expect(provider.errorMessage, isNotNull);
  });
  test('savePost - failure', () async {
    provider.posts.add(mockPost(id: "1", isSaved: false));

    when(() => savePost("1")).thenAnswer((_) async => Left(ServerFailure()));

    await provider.savePost("1");

    expect(provider.posts.first.isSaved, false);
    expect(provider.errorMessage, isNotNull);
  });
  test('unsavePost - failure', () async {
    provider.posts.add(mockPost(id: "1", isSaved: true));

    when(() => unsavePost("1")).thenAnswer((_) async => Left(ServerFailure()));

    await provider.unsavePost("1");

    expect(provider.posts.first.isSaved, true);
    expect(provider.errorMessage, isNotNull);
  });
  test('deletePost - failure', () async {
    provider.posts.add(mockPost(id: "1"));

    when(() => deletePost("1")).thenAnswer((_) async => Left(ServerFailure()));

    await provider.deletePost("1");

    expect(provider.posts.any((p) => p.id == "1"), true);
    expect(provider.errorMessage, isNotNull);
  });
  test('editPost - failure', () async {
    final post = mockPost(id: "1", content: "Old");
    provider.posts.add(post);

    when(
      () => editPost(
        postId: "1",
        content: "Fail",
        media: any(named: "media"),
        taggedUsers: any(named: "taggedUsers"),
        visibility: "Connections",
      ),
    ).thenAnswer((_) async => Left(ServerFailure()));

    await provider.editPost(
      postId: "1",
      content: "Fail",
      media: [],
      taggedUsers: [],
      visibility: "Connections",
    );

    expect(provider.posts.first.content, "Old");
  });
  test('reactToPost - failure', () async {
    provider.posts.add(mockPost(id: "1"));

    final reactions = {"Like": true};

    when(
      () => reactToPost(
        postId: "1",
        reactions: reactions,
        postType: any(named: "postType"),
      ),
    ).thenAnswer((_) async => Left(ServerFailure()));

    await provider.reactToPost("1", reactions, "normal");

    expect(provider.posts.first.reactType, "");
    expect(provider.errorMessage, isNotNull);
  });
  test('addComment - failure', () async {
    provider.posts.add(mockPost(id: "1"));

    when(
      () => commentPost(postId: "1", content: "Oops", isReply: false),
    ).thenAnswer((_) async => Left(ServerFailure()));

    await provider.addComment("1", "Oops", false);

    expect(provider.comments.isEmpty, true);
    expect(provider.errorMessage, isNotNull);
  });
  test('deleteComment - failure', () async {
    final comment = CommentModel(
      id: "c1",
      content: "Oops",
      postId: "1",
      authorId: "u1",
      authorName: "Tester",
      authorPicture: "url",
      authorBio: "Bio",
      reactCount: 0,
      timestamp: DateTime.now(),
      replies: [],
      taggedUsers: [],
    );

    provider.comments.add(comment);

    when(
      () => deleteComment("c1"),
    ).thenAnswer((_) async => Left(ServerFailure()));
    when(
      () => fetchComments(
        "1",
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => Right([])); // fallback

    await provider.deleteComment("1", "c1");

    expect(provider.comments.length, 1);
  });
  test('editComment - failure', () async {
    final comment = CommentModel(
      id: "c1",
      content: "Wrong",
      postId: "1",
      authorId: "u1",
      authorName: "Tester",
      authorPicture: "url",
      authorBio: "Bio",
      reactCount: 0,
      timestamp: DateTime.now(),
      replies: [],
      taggedUsers: [],
    );

    provider.comments.add(comment);

    when(
      () => editComment(
        commentId: "c1",
        content: "Corrected",
        tagged: any(named: "tagged"),
        isReply: any(named: "isReply"),
      ),
    ).thenAnswer((_) async => Left(ServerFailure()));

    await provider.editComment(
      commentId: "c1",
      updatedContent: "Corrected",
      taggedUsers: [],
      isReply: false,
    );

    expect(provider.comments.first.content, "Wrong");
  });
  test('getPostReactions - failure', () async {
    when(
      () => getPostReactions("p1"),
    ).thenAnswer((_) async => Left(ServerFailure()));

    final result = await provider.getPostReactions("p1");

    expect(result, []);
  });
  test('fetchUserPosts - failure', () async {
    when(
      () => getUserPosts(
        "user123",
        page: any(named: "page"),
        limit: any(named: "limit"),
      ),
    ).thenAnswer((_) async => Left(ServerFailure()));

    await provider.fetchUserPosts("user123");

    expect(provider.userPosts.isEmpty, true);
    expect(provider.errorMessage, isNotNull);
  });
}
