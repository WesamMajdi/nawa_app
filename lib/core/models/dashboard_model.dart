class DashboardModel {
  final DashboardStats stats;
  final ContinueData? continueData;
  final DailyChallengeModel? dailyChallenge;
  final List<WeeklyActivityItem> weeklyActivity;
  final int weeklyDelta;
  final List<LeaderboardPreviewItem> leaderboardPreview;
  final List<PathCardModel> recommendedPaths;

  DashboardModel({
    required this.stats,
    this.continueData,
    this.dailyChallenge,
    required this.weeklyActivity,
    required this.weeklyDelta,
    required this.leaderboardPreview,
    required this.recommendedPaths,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      stats: DashboardStats.fromJson(json['stats'] as Map<String, dynamic>),
      continueData: json['continue'] != null
          ? ContinueData.fromJson(json['continue'] as Map<String, dynamic>)
          : null,
      dailyChallenge: json['dailyChallenge'] != null
          ? DailyChallengeModel.fromJson(json['dailyChallenge'] as Map<String, dynamic>)
          : null,
      weeklyActivity: (json['weeklyActivity'] as List?)
              ?.map((e) => WeeklyActivityItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      weeklyDelta: json['weeklyDelta'] as int? ?? 0,
      leaderboardPreview: (json['leaderboardPreview'] as List?)
              ?.map((e) => LeaderboardPreviewItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recommendedPaths: (json['recommendedPaths'] as List?)
              ?.map((e) => PathCardModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class DashboardStats {
  final int streakDays;
  final int xp;
  final int level;
  final int xpToNext;
  final int globalRank;
  final int challengesSolved;
  final int lessonsCompleted;
  final int lessonsThisWeek;
  final int percentileAhead;

  DashboardStats({
    required this.streakDays,
    required this.xp,
    required this.level,
    required this.xpToNext,
    required this.globalRank,
    required this.challengesSolved,
    required this.lessonsCompleted,
    required this.lessonsThisWeek,
    required this.percentileAhead,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      streakDays: json['streakDays'] as int? ?? 0,
      xp: json['xp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      xpToNext: json['xpToNext'] as int? ?? 0,
      globalRank: json['globalRank'] as int? ?? 0,
      challengesSolved: json['challengesSolved'] as int? ?? 0,
      lessonsCompleted: json['lessonsCompleted'] as int? ?? 0,
      lessonsThisWeek: json['lessonsThisWeek'] as int? ?? 0,
      percentileAhead: json['percentileAhead'] as int? ?? 0,
    );
  }
}

class ContinueData {
  final String pathId;
  final String pathSlug;
  final String pathTitle;
  final String moduleId;
  final String moduleTitle;
  final String lessonId;
  final String lessonTitle;
  final String? languageCode;
  final int progressPct;
  final int durationMinutes;

  ContinueData({
    required this.pathId,
    required this.pathSlug,
    required this.pathTitle,
    required this.moduleId,
    required this.moduleTitle,
    required this.lessonId,
    required this.lessonTitle,
    this.languageCode,
    required this.progressPct,
    required this.durationMinutes,
  });

  factory ContinueData.fromJson(Map<String, dynamic> json) {
    return ContinueData(
      pathId: json['pathId'] as String,
      pathSlug: json['pathSlug'] as String,
      pathTitle: json['pathTitle'] as String,
      moduleId: json['moduleId'] as String,
      moduleTitle: json['moduleTitle'] as String,
      lessonId: json['lessonId'] as String,
      lessonTitle: json['lessonTitle'] as String,
      languageCode: json['languageCode'] as String?,
      progressPct: json['progressPct'] as int? ?? 0,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
    );
  }
}

class DailyChallengeModel {
  final String id;
  final String kind;
  final String category;
  final String title;
  final String? description;
  final int? participantsCount;
  final String? endsAt;
  final int? xpReward;
  final String? prize;
  final String? badgeReward;
  final String? difficulty;
  final String? languageCode;
  final String? imageUrl;
  final String? color;
  final bool joinedOrSolved;
  final int? solvedCount;
  final double? successRatePct;
  final String? tag;
  final bool isDaily;
  final bool solved;

  DailyChallengeModel({
    required this.id,
    required this.kind,
    required this.category,
    required this.title,
    this.description,
    this.participantsCount,
    this.endsAt,
    this.xpReward,
    this.prize,
    this.badgeReward,
    this.difficulty,
    this.languageCode,
    this.imageUrl,
    this.color,
    this.joinedOrSolved = false,
    this.solvedCount,
    this.successRatePct,
    this.tag,
    this.isDaily = false,
    this.solved = false,
  });

  factory DailyChallengeModel.fromJson(Map<String, dynamic> json) {
    return DailyChallengeModel(
      id: json['id'] as String,
      kind: json['kind'] as String? ?? 'challenge',
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      participantsCount: json['participantsCount'] as int?,
      endsAt: json['endsAt'] as String?,
      xpReward: json['xpReward'] as int?,
      prize: json['prize'] as String?,
      badgeReward: json['badgeReward'] as String?,
      difficulty: json['difficulty'] as String?,
      languageCode: json['languageCode'] as String?,
      imageUrl: json['imageUrl'] as String?,
      color: json['color'] as String?,
      joinedOrSolved: json['joinedOrSolved'] as bool? ?? false,
      solvedCount: json['solvedCount'] as int?,
      successRatePct: (json['successRatePct'] as num?)?.toDouble(),
      tag: json['tag'] as String?,
      isDaily: json['isDaily'] as bool? ?? false,
      solved: json['solved'] as bool? ?? false,
    );
  }
}

class WeeklyActivityItem {
  final String date;
  final int lessons;
  final int events;

  WeeklyActivityItem({required this.date, required this.lessons, required this.events});

  factory WeeklyActivityItem.fromJson(Map<String, dynamic> json) {
    return WeeklyActivityItem(
      date: json['date'] as String,
      lessons: json['lessons'] as int? ?? 0,
      events: json['events'] as int? ?? 0,
    );
  }
}

class LeaderboardPreviewItem {
  final int rank;
  final String userId;
  final String name;
  final String? initials;
  final String? avatarUrl;
  final int xp;
  final String? trend;
  final bool isCurrentUser;

  LeaderboardPreviewItem({
    required this.rank,
    required this.userId,
    required this.name,
    this.initials,
    this.avatarUrl,
    required this.xp,
    this.trend,
    required this.isCurrentUser,
  });

  factory LeaderboardPreviewItem.fromJson(Map<String, dynamic> json) {
    return LeaderboardPreviewItem(
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

class PathCardModel {
  final String id;
  final String slug;
  final String title;
  final String? languageCode;
  final String? level;
  final int? estimatedHours;
  final int? coursesCount;
  final int? learnersCount;
  final double? rating;
  final String? color;
  final String? coverImageUrl;
  final List<String>? tags;
  final bool isEnrolled;
  final int progressPct;
  final String? blurb;
  final String? minPlanTier;
  final bool requiresUpgrade;
  final InstructorModel? instructor;

  PathCardModel({
    required this.id,
    required this.slug,
    required this.title,
    this.languageCode,
    this.level,
    this.estimatedHours,
    this.coursesCount,
    this.learnersCount,
    this.rating,
    this.color,
    this.coverImageUrl,
    this.tags,
    this.isEnrolled = false,
    this.progressPct = 0,
    this.blurb,
    this.minPlanTier,
    this.requiresUpgrade = false,
    this.instructor,
  });

  factory PathCardModel.fromJson(Map<String, dynamic> json) {
    return PathCardModel(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      languageCode: json['languageCode'] as String?,
      level: json['level'] as String?,
      estimatedHours: json['estimatedHours'] as int?,
      coursesCount: json['coursesCount'] as int?,
      learnersCount: json['learnersCount'] as int?,
      rating: (json['rating'] as num?)?.toDouble(),
      color: json['color'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList(),
      isEnrolled: json['isEnrolled'] as bool? ?? false,
      progressPct: json['progressPct'] as int? ?? 0,
      blurb: json['blurb'] as String?,
      minPlanTier: json['minPlanTier'] as String?,
      requiresUpgrade: json['requiresUpgrade'] as bool? ?? false,
      instructor: json['instructor'] != null
          ? InstructorModel.fromJson(json['instructor'] as Map<String, dynamic>)
          : null,
    );
  }
}

class InstructorModel {
  final String id;
  final String name;
  final String? handle;
  final String? avatarUrl;
  final String? initials;
  final String? title;
  final String? bio;
  final double? rating;
  final int? studentsCount;

  InstructorModel({
    required this.id,
    required this.name,
    this.handle,
    this.avatarUrl,
    this.initials,
    this.title,
    this.bio,
    this.rating,
    this.studentsCount,
  });

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      handle: json['handle'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      initials: json['initials'] as String?,
      title: json['title'] as String?,
      bio: json['bio'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      studentsCount: json['studentsCount'] as int?,
    );
  }
}
