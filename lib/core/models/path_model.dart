import 'dashboard_model.dart';

class PathDetailModel {
  final String id;
  final String slug;
  final String title;
  final String? languageCode;
  final String? level;
  final String? blurb;
  final int? estimatedHours;
  final double? rating;
  final String? color;
  final String? coverImageUrl;
  final List<String>? tags;
  final bool isEnrolled;
  final int progressPct;
  final String? minPlanTier;
  final bool requiresUpgrade;
  final PathTotals? totals;
  final InstructorModel? instructor;
  final List<ModuleModel> modules;

  PathDetailModel({
    required this.id,
    required this.slug,
    required this.title,
    this.languageCode,
    this.level,
    this.blurb,
    this.estimatedHours,
    this.rating,
    this.color,
    this.coverImageUrl,
    this.tags,
    this.isEnrolled = false,
    this.progressPct = 0,
    this.minPlanTier,
    this.requiresUpgrade = false,
    this.totals,
    this.instructor,
    required this.modules,
  });

  factory PathDetailModel.fromJson(Map<String, dynamic> json) {
    return PathDetailModel(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      languageCode: json['languageCode'] as String?,
      level: json['level'] as String?,
      blurb: json['blurb'] as String?,
      estimatedHours: json['estimatedHours'] as int?,
      rating: (json['rating'] as num?)?.toDouble(),
      color: json['color'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList(),
      isEnrolled: json['isEnrolled'] as bool? ?? false,
      progressPct: json['progressPct'] as int? ?? 0,
      minPlanTier: json['minPlanTier'] as String?,
      requiresUpgrade: json['requiresUpgrade'] as bool? ?? false,
      totals: json['totals'] != null
          ? PathTotals.fromJson(json['totals'] as Map<String, dynamic>)
          : null,
      instructor: json['instructor'] != null
          ? InstructorModel.fromJson(json['instructor'] as Map<String, dynamic>)
          : null,
      modules: (json['modules'] as List?)
              ?.map((e) => ModuleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PathTotals {
  final int lessonsDone;
  final int lessonsTotal;

  PathTotals({required this.lessonsDone, required this.lessonsTotal});

  factory PathTotals.fromJson(Map<String, dynamic> json) {
    return PathTotals(
      lessonsDone: json['lessonsDone'] as int? ?? 0,
      lessonsTotal: json['lessonsTotal'] as int? ?? 0,
    );
  }
}

class ModuleModel {
  final String id;
  final String title;
  final String? description;
  final int sort;
  final int lessonsCount;
  final int doneCount;
  final bool isLocked;
  final bool isDone;
  final bool isCurrent;
  final List<LessonItemModel> lessons;

  ModuleModel({
    required this.id,
    required this.title,
    this.description,
    required this.sort,
    required this.lessonsCount,
    required this.doneCount,
    required this.isLocked,
    required this.isDone,
    required this.isCurrent,
    required this.lessons,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      sort: json['sort'] as int? ?? 0,
      lessonsCount: json['lessonsCount'] as int? ?? 0,
      doneCount: json['doneCount'] as int? ?? 0,
      isLocked: json['isLocked'] as bool? ?? false,
      isDone: json['isDone'] as bool? ?? false,
      isCurrent: json['isCurrent'] as bool? ?? false,
      lessons: (json['lessons'] as List?)
              ?.map((e) => LessonItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class LessonItemModel {
  final String id;
  final String title;
  final String type;
  final int? durationMinutes;
  final int sort;
  final String status;
  final bool isCurrent;

  LessonItemModel({
    required this.id,
    required this.title,
    required this.type,
    this.durationMinutes,
    required this.sort,
    required this.status,
    required this.isCurrent,
  });

  factory LessonItemModel.fromJson(Map<String, dynamic> json) {
    return LessonItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      durationMinutes: json['durationMinutes'] as int?,
      sort: json['sort'] as int? ?? 0,
      status: json['status'] as String? ?? 'not_started',
      isCurrent: json['isCurrent'] as bool? ?? false,
    );
  }
}
