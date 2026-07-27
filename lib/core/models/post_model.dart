class PostModel {
  final String id;
  final String type;
  final String? title;
  final String body;
  final String authorId;
  final String authorName;
  final String? authorRole;
  final String? authorJobTitle;
  final String? authorAvatarUrl;
  final String? authorInitials;
  final String? authorHandle;
  final int likesCount;
  final int repliesCount;
  final bool isSolved;
  final bool isLikedByMe;
  final DateTime? createdAt;
  final List<String>? imageUrls;
  final List<String>? topics;

  PostModel({
    required this.id,
    required this.type,
    this.title,
    required this.body,
    required this.authorId,
    required this.authorName,
    this.authorRole,
    this.authorJobTitle,
    this.authorAvatarUrl,
    this.authorInitials,
    this.authorHandle,
    this.likesCount = 0,
    this.repliesCount = 0,
    this.isSolved = false,
    this.isLikedByMe = false,
    this.createdAt,
    this.imageUrls,
    this.topics,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String?,
      body: json['body'] as String? ?? '',
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorRole: json['authorRole'] as String?,
      authorJobTitle: json['authorJobTitle'] as String?,
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      authorInitials: json['authorInitials'] as String?,
      authorHandle: json['authorHandle'] as String?,
      likesCount: json['likesCount'] as int? ?? 0,
      repliesCount: json['repliesCount'] as int? ?? 0,
      isSolved: json['isSolved'] as bool? ?? false,
      isLikedByMe: json['isLikedByMe'] as bool? ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      imageUrls: (json['imageUrls'] as List?)?.map((e) => e.toString()).toList(),
      topics: (json['topics'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}

class TrendingTopicModel {
  final String name;
  final int postsCount;

  TrendingTopicModel({required this.name, required this.postsCount});

  factory TrendingTopicModel.fromJson(Map<String, dynamic> json) {
    return TrendingTopicModel(
      name: json['name'] as String,
      postsCount: json['postsCount'] as int? ?? 0,
    );
  }
}

class ReplyModel {
  final String id;
  final String body;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String? authorInitials;
  final DateTime? createdAt;

  ReplyModel({
    required this.id,
    required this.body,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    this.authorInitials,
    this.createdAt,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      id: json['id'] as String,
      body: json['body'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorAvatarUrl: json['authorAvatarUrl'] as String?,
      authorInitials: json['authorInitials'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
