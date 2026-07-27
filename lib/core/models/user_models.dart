class BadgeModel {
  final String id;
  final String name;
  final String icon;
  final String color;
  final bool unlocked;
  final DateTime? unlockedAt;

  BadgeModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.unlocked = false,
    this.unlockedAt,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '🏆',
      color: json['color'] as String? ?? '#FFD700',
      unlocked: json['unlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt']) : null,
    );
  }
}

class UserLearningModel {
  final String pathId;
  final String slug;
  final String title;
  final String? languageCode;
  final String? level;
  final String? color;
  final int progressPct;
  final int lessonsDone;
  final int lessonsTotal;
  final bool isCompleted;
  final DateTime? enrolledAt;
  final DateTime? lastActivityAt;
  final LearningContinue? continueData;

  UserLearningModel({
    required this.pathId,
    required this.slug,
    required this.title,
    this.languageCode,
    this.level,
    this.color,
    this.progressPct = 0,
    this.lessonsDone = 0,
    this.lessonsTotal = 0,
    this.isCompleted = false,
    this.enrolledAt,
    this.lastActivityAt,
    this.continueData,
  });

  factory UserLearningModel.fromJson(Map<String, dynamic> json) {
    return UserLearningModel(
      pathId: json['pathId'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      languageCode: json['languageCode'] as String?,
      level: json['level'] as String?,
      color: json['color'] as String?,
      progressPct: json['progressPct'] as int? ?? 0,
      lessonsDone: json['lessonsDone'] as int? ?? 0,
      lessonsTotal: json['lessonsTotal'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      enrolledAt: json['enrolledAt'] != null ? DateTime.parse(json['enrolledAt']) : null,
      lastActivityAt: json['lastActivityAt'] != null
          ? DateTime.parse(json['lastActivityAt'])
          : null,
      continueData: json['continue'] != null
          ? LearningContinue.fromJson(json['continue'] as Map<String, dynamic>)
          : null,
    );
  }
}

class LearningContinue {
  final String lessonId;
  final String title;
  final String type;
  final String moduleId;
  final String moduleTitle;

  LearningContinue({
    required this.lessonId,
    required this.title,
    required this.type,
    required this.moduleId,
    required this.moduleTitle,
  });

  factory LearningContinue.fromJson(Map<String, dynamic> json) {
    return LearningContinue(
      lessonId: json['lessonId'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      moduleId: json['moduleId'] as String,
      moduleTitle: json['moduleTitle'] as String,
    );
  }
}

class SkillModel {
  final String name;
  final int value;

  SkillModel({required this.name, required this.value});

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      name: json['name'] as String,
      value: json['value'] as int? ?? 0,
    );
  }
}

class ActivityModel {
  final String range;
  final List<ActivityDay> days;
  final int total;
  final int streakDays;

  ActivityModel({
    required this.range,
    required this.days,
    required this.total,
    required this.streakDays,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      range: json['range'] as String,
      days: (json['days'] as List?)
              ?.map((e) => ActivityDay.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
    );
  }
}

class ActivityDay {
  final String date;
  final int lessons;
  final int events;

  ActivityDay({required this.date, required this.lessons, required this.events});

  factory ActivityDay.fromJson(Map<String, dynamic> json) {
    return ActivityDay(
      date: json['date'] as String,
      lessons: json['lessons'] as int? ?? 0,
      events: json['events'] as int? ?? 0,
    );
  }
}
