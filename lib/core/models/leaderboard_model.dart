class LeaderboardModel {
  final int rank;
  final String userId;
  final String name;
  final String? initials;
  final String? avatarUrl;
  final int xp;
  final String? trend;
  final bool isCurrentUser;

  LeaderboardModel({
    required this.rank,
    required this.userId,
    required this.name,
    this.initials,
    this.avatarUrl,
    required this.xp,
    this.trend,
    this.isCurrentUser = false,
  });

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      rank: json['rank'] as int,
      userId: json['userId'] as String,
      name: json['name'] as String,
      initials: json['initials'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      xp: json['xp'] as int? ?? 0,
      trend: json['trend'] as String?,
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
    );
  }
}
