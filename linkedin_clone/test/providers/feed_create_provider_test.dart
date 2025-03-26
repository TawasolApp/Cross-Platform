import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/create_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/get_posts_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/delete_post_usecase.dart';
import 'package:linkedin_clone/features/feed/domain/usecases/save_post_usecase.dart';
import 'package:linkedin_clone/features/feed/presentation/provider/feed_provider.dart';
import 'package:linkedin_clone/features/feed/domain/entities/post_entity.dart';
import 'package:fpdart/fpdart.dart';

class MockGetPostsUseCase extends Mock implements GetPostsUseCase {}

class MockCreatePostUseCase extends Mock implements CreatePostUseCase {}

class MockDeletePostUseCase extends Mock implements DeletePostUseCase {}

class MockSavePostUseCase extends Mock implements SavePostUseCase {}

void main() {
  late FeedProvider provider;
  late MockGetPostsUseCase mockGetPosts;
  late MockCreatePostUseCase mockCreatePost;
  late MockDeletePostUseCase mockDeletePost;
  late MockSavePostUseCase mockSavePost;

  setUp(() {
    mockGetPosts = MockGetPostsUseCase();
    mockCreatePost = MockCreatePostUseCase();
    mockDeletePost = MockDeletePostUseCase();
    mockSavePost = MockSavePostUseCase();

    provider = FeedProvider(
      getPostsUseCase: mockGetPosts,
      createPostUseCase: mockCreatePost,
      deletePostUseCase: mockDeletePost,
      savePostUseCase: mockSavePost,
    );
  });

  test('Initial values are correct', () {
    expect(provider.posts, []);
    expect(provider.isLoading, false);
    expect(provider.errorMessage, null);
  });

  test('Create post adds post to list (mock mode)', () async {
    provider.setVisibility("Public");
    await provider.createPost(
      content: "Test content",
      media: [],
      visibility: 'public',
    );
    expect(provider.posts.length, 1);
    expect(provider.posts.first.content, "Test content");
  });

  test('Delete post removes it from the list (mock mode)', () async {
    await provider.createPost(
      content: "To be deleted",
      media: [],
      visibility: 'public',
    );
    final postId = provider.posts.first.id;
    await provider.deletePost(postId);
    expect(provider.posts.where((p) => p.id == postId).isEmpty, true);
  });

  test('Save post does not throw error (mock mode)', () async {
    await provider.createPost(
      content: "To be saved",
      media: [],
      visibility: 'public',
    );
    final postId = provider.posts.first.id;
    await provider.savePost(postId);
    expect(provider.errorMessage, null);
  });

  test('Save post toggles isSaved in mock mode', () async {
    await provider.createPost(
      content: "Save toggle test",
      media: [],
      visibility: 'public',
    );
    final postId = provider.posts.first.id;
    await provider.savePost(postId);
    expect(provider.posts.first.isSaved, true);
    await provider.savePost(postId);
    expect(provider.posts.first.isSaved, false);
  });

  test('Multiple posts can be created', () async {
    await provider.createPost(
      content: "Post 1",
      media: [],
      visibility: 'public',
    );
    await provider.createPost(
      content: "Post 2",
      media: [],
      visibility: 'public',
    );
    expect(provider.posts.length, 2);
  });

  test('Set visibility works correctly', () {
    provider.setVisibility("Private");
    expect(provider.visibility, "Private");
  });

  test('Creating post resets errorMessage', () async {
    provider.setVisibility("Public");
    await provider.createPost(
      content: "New Post",
      media: [],
      visibility: 'public',
    );
    expect(provider.errorMessage, null);
  });

  test('Deleting non-existent post does not crash', () async {
    await provider.deletePost("non-existent-id");
    expect(provider.errorMessage, null);
  });

  test('Save post works for multiple posts', () async {
    // Create first post (Post A)
    await provider.createPost(
      content: "Post A",
      media: [],
      visibility: 'public',
    );
    final postAId = provider.posts.first.id;

    // Create second post (Post B)
    await provider.createPost(
      content: "Post B",
      media: [],
      visibility: 'public',
    );
    final postBId = provider.posts.first.id;

    // Save Post A
    await provider.savePost(postAId);
    print(provider.posts.map((p) => {'id': p.id, 'saved': p.isSaved}));

    // Save Post B
    await provider.savePost(postBId);
    print(provider.posts.map((p) => {'id': p.id, 'saved': p.isSaved}));

    // Re-fetch posts by ID to confirm correct toggle
    final postA = provider.posts.firstWhere((p) => p.id == postAId);
    final postB = provider.posts.firstWhere((p) => p.id == postBId);

    expect(postA.isSaved, true, reason: 'Post A should be saved');
    expect(postB.isSaved, true, reason: 'Post B should be saved');
  });

  test('Error message is null after successful delete', () async {
    await provider.createPost(
      content: "Temp post",
      media: [],
      visibility: 'public',
    );
    final postId = provider.posts.first.id;
    await provider.deletePost(postId);
    expect(provider.errorMessage, null);
  });

  test('isCreating is false after post creation completes', () async {
    expect(provider.isCreating, false);

    await provider.createPost(
      content: "Creating...",
      media: [],
      visibility: 'public',
    );

    expect(provider.isCreating, false);
    expect(provider.posts.length, 1);
  });

  test('isLoading is set during fetch', () async {
    final future = provider.fetchPosts();
    expect(provider.isLoading, true);
    await future;
    expect(provider.isLoading, false);
  });

  test('Create post fills all fields', () async {
    await provider.createPost(
      content: "Field Check",
      media: ["media1.png"],
      visibility: "public",
      taggedUsers: ["user123"],
    );
    final post = provider.posts.first;
    expect(post.authorName.isNotEmpty, true);
    expect(post.media?.isNotEmpty, true);
    expect(post.taggedUsers?.isNotEmpty, true);
  });

  test('Fetch posts populates mock data', () async {
    await provider.fetchPosts();
    expect(provider.posts.length, 2);
  });
}
