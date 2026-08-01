class ChallengeModel {
  final String id;
  final String kind;
  final String category;
  final String title;
  final String? description;
  final int? participantsCount;
  final DateTime? endsAt;
  final int? xpReward;
  final String? prize;
  final String? badgeReward;
  final String? difficulty;
  final String? languageCode;
  final String? imageUrl;
  final String? color;
  final String? sponsorName;
  final bool joinedOrSolved;

  ChallengeModel({
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
    this.sponsorName,
    this.joinedOrSolved = false,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['id'] as String,
      kind: json['kind'] as String? ?? 'challenge',
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      participantsCount: json['participantsCount'] as int?,
      endsAt: json['endsAt'] != null ? DateTime.parse(json['endsAt']) : null,
      xpReward: json['xpReward'] as int?,
      prize: json['prize'] as String?,
      badgeReward: json['badgeReward'] as String?,
      difficulty: json['difficulty'] as String?,
      languageCode: json['languageCode'] as String?,
      imageUrl: json['imageUrl'] as String?,
      color: json['color'] as String?,
      sponsorName: json['sponsorName'] as String?,
      joinedOrSolved: json['joinedOrSolved'] as bool? ?? false,
    );
  }

  ChallengeModel copyWith({bool? joinedOrSolved}) {
    return ChallengeModel(
      id: id,
      kind: kind,
      category: category,
      title: title,
      description: description,
      participantsCount: participantsCount,
      endsAt: endsAt,
      xpReward: xpReward,
      prize: prize,
      badgeReward: badgeReward,
      difficulty: difficulty,
      languageCode: languageCode,
      imageUrl: imageUrl,
      color: color,
      sponsorName: sponsorName,
      joinedOrSolved: joinedOrSolved ?? this.joinedOrSolved,
    );
  }
}

class ChallengeDetailModel {
  final String id;
  final String title;
  final String? description;
  final String? difficulty;
  final String? languageCode;
  final String? category;
  final int? xpReward;
  final String? badgeReward;
  final int? participantsCount;
  final DateTime? endsAt;
  final String? requirementsMd;
  final String? imageUrl;
  final int? solvedCount;
  final double? successRatePct;
  final bool isDaily;
  final bool solved;
  final String? starterCode;
  final List<ChallengeTestModel>? tests;

  ChallengeDetailModel({
    required this.id,
    required this.title,
    this.description,
    this.difficulty,
    this.languageCode,
    this.category,
    this.xpReward,
    this.badgeReward,
    this.participantsCount,
    this.endsAt,
    this.requirementsMd,
    this.imageUrl,
    this.solvedCount,
    this.successRatePct,
    this.isDaily = false,
    this.solved = false,
    this.starterCode,
    this.tests,
  });

  factory ChallengeDetailModel.fromJson(Map<String, dynamic> json) {
    return ChallengeDetailModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      difficulty: json['difficulty'] as String?,
      languageCode: json['languageCode'] as String?,
      category: json['category'] as String?,
      xpReward: json['xpReward'] as int?,
      badgeReward: json['badgeReward'] as String?,
      participantsCount: json['participantsCount'] as int?,
      endsAt: json['endsAt'] != null ? DateTime.parse(json['endsAt']) : null,
      requirementsMd: json['requirementsMd'] as String?,
      imageUrl: json['imageUrl'] as String?,
      solvedCount: json['solvedCount'] as int?,
      successRatePct: (json['successRatePct'] as num?)?.toDouble(),
      isDaily: json['isDaily'] as bool? ?? false,
      solved: json['solved'] as bool? ?? false,
      starterCode: json['starterCode'] as String?,
      tests: (json['tests'] as List?)
          ?.map((e) => ChallengeTestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ChallengeTestModel {
  final String id;
  final String name;

  ChallengeTestModel({required this.id, required this.name});

  factory ChallengeTestModel.fromJson(Map<String, dynamic> json) {
    return ChallengeTestModel(id: json['id'] as String, name: json['name'] as String);
  }
}

class SubmissionResult {
  final SubmissionData submission;
  final bool solved;
  final int? xpAwarded;
  final int? remainingToday;

  SubmissionResult({
    required this.submission,
    required this.solved,
    this.xpAwarded,
    this.remainingToday,
  });

  factory SubmissionResult.fromJson(Map<String, dynamic> json) {
    return SubmissionResult(
      submission: SubmissionData.fromJson(json['submission'] as Map<String, dynamic>),
      solved: json['solved'] as bool? ?? false,
      xpAwarded: json['xpAwarded'] as int?,
      remainingToday: json['remainingToday'] as int?,
    );
  }
}

class SubmissionData {
  final String id;
  final String status;
  final bool passed;
  final int testsPassed;
  final int testsTotal;
  final int? xpAwarded;
  final int? runtimeMs;
  final List<SubmissionTestResult>? results;

  SubmissionData({
    required this.id,
    required this.status,
    required this.passed,
    required this.testsPassed,
    required this.testsTotal,
    this.xpAwarded,
    this.runtimeMs,
    this.results,
  });

  factory SubmissionData.fromJson(Map<String, dynamic> json) {
    return SubmissionData(
      id: json['id'] as String,
      status: json['status'] as String,
      passed: json['passed'] as bool? ?? false,
      testsPassed: json['testsPassed'] as int? ?? 0,
      testsTotal: json['testsTotal'] as int? ?? 0,
      xpAwarded: json['xpAwarded'] as int?,
      runtimeMs: json['runtimeMs'] as int?,
      results: (json['results'] as List?)
          ?.map((e) => SubmissionTestResult.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SubmissionTestResult {
  final String name;
  final bool ok;
  final String? actualOutput;
  final int? durationMs;

  SubmissionTestResult({
    required this.name,
    required this.ok,
    this.actualOutput,
    this.durationMs,
  });

  factory SubmissionTestResult.fromJson(Map<String, dynamic> json) {
    return SubmissionTestResult(
      name: json['name'] as String,
      ok: json['ok'] as bool? ?? false,
      actualOutput: json['actualOutput'] as String?,
      durationMs: json['durationMs'] as int?,
    );
  }
}
