class LessonDetailModel {
  final String id;
  final String title;
  final String type;
  final String? instructionsMd;
  final String? hintMd;
  final String? starterCode;
  final String? videoUrl;
  final String? videoProvider;
  final String? languageCode;
  final int? durationMinutes;
  final bool isCompleted;
  final List<AttachmentModel> attachments;
  final LessonPathContext pathContext;
  final List<TestModel>? tests;
  final List<QuizQuestionModel>? quiz;
  final int? passThresholdPct;

  LessonDetailModel({
    required this.id,
    required this.title,
    required this.type,
    this.instructionsMd,
    this.hintMd,
    this.starterCode,
    this.videoUrl,
    this.videoProvider,
    this.languageCode,
    this.durationMinutes,
    required this.isCompleted,
    required this.attachments,
    required this.pathContext,
    this.tests,
    this.quiz,
    this.passThresholdPct,
  });

  factory LessonDetailModel.fromJson(Map<String, dynamic> json) {
    return LessonDetailModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      instructionsMd: json['instructionsMd'] as String?,
      hintMd: json['hintMd'] as String?,
      starterCode: json['starterCode'] as String?,
      videoUrl: json['videoUrl'] as String?,
      videoProvider: json['videoProvider'] as String?,
      languageCode: json['languageCode'] as String?,
      durationMinutes: json['durationMinutes'] as int?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      attachments: (json['attachments'] as List?)
              ?.map((e) => AttachmentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pathContext: LessonPathContext.fromJson(json['pathContext'] as Map<String, dynamic>),
      tests: (json['tests'] as List?)
          ?.map((e) => TestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      quiz: (json['quiz'] as List?)
          ?.map((e) => QuizQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      passThresholdPct: json['passThresholdPct'] as int?,
    );
  }
}

class LessonPathContext {
  final String pathId;
  final String pathSlug;
  final String pathTitle;
  final String moduleId;
  final String moduleTitle;

  LessonPathContext({
    required this.pathId,
    required this.pathSlug,
    required this.pathTitle,
    required this.moduleId,
    required this.moduleTitle,
  });

  factory LessonPathContext.fromJson(Map<String, dynamic> json) {
    return LessonPathContext(
      pathId: json['pathId'] as String,
      pathSlug: json['pathSlug'] as String,
      pathTitle: json['pathTitle'] as String,
      moduleId: json['moduleId'] as String,
      moduleTitle: json['moduleTitle'] as String,
    );
  }
}

class AttachmentModel {
  final String id;
  final String title;
  final String url;
  final String kind;
  final int? sizeBytes;

  AttachmentModel({
    required this.id,
    required this.title,
    required this.url,
    required this.kind,
    this.sizeBytes,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return AttachmentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      kind: json['kind'] as String,
      sizeBytes: json['sizeBytes'] as int?,
    );
  }
}

class TestModel {
  final String id;
  final String name;

  TestModel({required this.id, required this.name});

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(id: json['id'] as String, name: json['name'] as String);
  }
}

class QuizQuestionModel {
  final String id;
  final String question;
  final List<QuizOptionModel> options;
  final bool allowMultiple;

  QuizQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    this.allowMultiple = false,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] as String,
      question: json['question'] as String,
      options: (json['options'] as List?)
              ?.map((e) => QuizOptionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      allowMultiple: json['allowMultiple'] as bool? ?? false,
    );
  }
}

class QuizOptionModel {
  final String id;
  final String text;

  QuizOptionModel({required this.id, required this.text});

  factory QuizOptionModel.fromJson(Map<String, dynamic> json) {
    return QuizOptionModel(id: json['id'] as String, text: json['text'] as String);
  }
}

class LessonCompletionResult {
  final bool lessonCompleted;
  final int xpAwarded;
  final int newXpTotal;
  final int level;
  final int enrollmentProgressPct;
  final bool certificateIssued;

  LessonCompletionResult({
    required this.lessonCompleted,
    required this.xpAwarded,
    required this.newXpTotal,
    required this.level,
    required this.enrollmentProgressPct,
    required this.certificateIssued,
  });

  factory LessonCompletionResult.fromJson(Map<String, dynamic> json) {
    return LessonCompletionResult(
      lessonCompleted: json['lessonCompleted'] as bool? ?? false,
      xpAwarded: json['xpAwarded'] as int? ?? 0,
      newXpTotal: json['newXpTotal'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      enrollmentProgressPct: json['enrollmentProgressPct'] as int? ?? 0,
      certificateIssued: json['certificateIssued'] as bool? ?? false,
    );
  }
}
