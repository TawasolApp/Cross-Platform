import './sub_post_entities.dart';

class PostEntity {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorPicture;
  final String authorBio;
  final String content;
  final List<String>? media;
  final Map<String, bool>? reactions; // For reacting to a post
  final Map<String, int>? reactCounts; // For fetching reactions
  int comments;
  final int shares;
  final List<String>? taggedUsers;
  final String visibility;
  final String authorType;
  final String reactType;
  //final RepostDetails? repostDetails;
  final DateTime timestamp;
  final bool isSaved;
  final bool isFollowing;
  final bool isConnected;
  final bool isEdited;
  final bool isSilentRepost;
  final PostEntity? parentPost; // For reposting
  final String? parentPostId; // For reposting

  PostEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorPicture,
    required this.authorBio,
    required this.content,
    this.media,
    this.reactions = const {},
    this.reactCounts,
    this.comments = 0,
    this.shares = 0,
    this.taggedUsers,
    required this.visibility,
    required this.authorType,
    required this.reactType,
    required this.timestamp,
    //this.repostDetails,
    this.isSaved = false,
    this.isFollowing = false,
    this.isConnected = false,
    this.isEdited = false,
    this.isSilentRepost = false,
    this.parentPost,
    this.parentPostId,
  });

  PostEntity copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorPicture,
    String? authorBio,
    String? content,
    List<String>? media,
    Map<String, bool>? reactions,
    Map<String, int>? reactCounts,
    int? comments,
    int? shares,
    List<String>? taggedUsers,
    String? visibility,
    String? authorType,
    DateTime? timestamp,
    String? reactType,
    RepostDetails? repostDetails,
    bool? isSaved,
    bool? isFollowing,
    bool? isConnected,
    bool? isEdited,
    bool? isSilentRepost,
    PostEntity? parentPost,
    String? parentPostId,
  }) {
    return PostEntity(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorPicture: authorPicture ?? this.authorPicture,
      authorBio: authorBio ?? this.authorBio,
      content: content ?? this.content,
      media: media ?? this.media,
      reactions: reactions ?? this.reactions,
      reactCounts: reactCounts ?? this.reactCounts,
      //likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      taggedUsers: taggedUsers ?? this.taggedUsers,
      visibility: visibility ?? this.visibility,
      authorType: authorType ?? this.authorType,
      reactType: reactType ?? this.reactType,
      //isLiked: isLiked ?? this.isLiked,
      timestamp: timestamp ?? this.timestamp,
      //repostDetails: repostDetails ?? this.repostDetails,
      isSaved: isSaved ?? this.isSaved,
      isFollowing: isFollowing ?? this.isFollowing,
      isConnected: isConnected ?? this.isConnected,
      isEdited: isEdited ?? this.isEdited,
      isSilentRepost: isSilentRepost ?? this.isSilentRepost,
      parentPost: parentPost ?? this.parentPost,
      parentPostId: parentPostId ?? this.parentPostId,
    );
  }
}
