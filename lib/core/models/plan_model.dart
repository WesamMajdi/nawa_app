class CertificateModel {
  final String id;
  final String title;
  final String serialCode;
  final DateTime? issuedAt;
  final String? pathTitle;
  final String? color;
  final String? pdfUrl;
  final String? grade;

  CertificateModel({
    required this.id,
    required this.title,
    required this.serialCode,
    this.issuedAt,
    this.pathTitle,
    this.color,
    this.pdfUrl,
    this.grade,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] as String,
      title: json['title'] as String,
      serialCode: json['serialCode'] as String,
      issuedAt: json['issuedAt'] != null ? DateTime.parse(json['issuedAt']) : null,
      pathTitle: json['pathTitle'] as String?,
      color: json['color'] as String?,
      pdfUrl: json['pdfUrl'] as String?,
      grade: json['grade'] as String?,
    );
  }
}

class PlanModel {
  final String code;
  final String name;
  final int priceCents;
  final String currency;
  final String billingCycle;
  final String period;
  final String? tagline;
  final bool isPopular;
  final bool isCurrent;
  final List<String> features;

  PlanModel({
    required this.code,
    required this.name,
    required this.priceCents,
    this.currency = 'usd',
    this.billingCycle = 'monthly',
    this.period = 'month',
    this.tagline,
    this.isPopular = false,
    this.isCurrent = false,
    this.features = const [],
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      code: json['code'] as String,
      name: json['name'] as String,
      priceCents: json['priceCents'] as int? ?? 0,
      currency: json['currency'] as String? ?? 'usd',
      billingCycle: json['billingCycle'] as String? ?? 'monthly',
      period: json['period'] as String? ?? 'month',
      tagline: json['tagline'] as String?,
      isPopular: json['isPopular'] as bool? ?? false,
      isCurrent: json['isCurrent'] as bool? ?? false,
      features: (json['features'] as List?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }
}

class PlanUsageModel {
  final String planCode;
  final String tier;
  final String planName;
  final String status;
  final String? billingCycle;
  final DateTime? renewsAt;
  final bool cancelAtPeriodEnd;
  final int enrolledPaths;
  final int completedPaths;
  final int certificates;
  final int challengesToday;
  final int? dailyChallengeLimit;
  final PlanEntitlements entitlements;

  PlanUsageModel({
    required this.planCode,
    required this.tier,
    required this.planName,
    required this.status,
    this.billingCycle,
    this.renewsAt,
    this.cancelAtPeriodEnd = false,
    this.enrolledPaths = 0,
    this.completedPaths = 0,
    this.certificates = 0,
    this.challengesToday = 0,
    this.dailyChallengeLimit,
    required this.entitlements,
  });

  factory PlanUsageModel.fromJson(Map<String, dynamic> json) {
    return PlanUsageModel(
      planCode: json['planCode'] as String,
      tier: json['tier'] as String? ?? '',
      planName: json['planName'] as String? ?? '',
      status: json['status'] as String? ?? '',
      billingCycle: json['billingCycle'] as String?,
      renewsAt: json['renewsAt'] != null ? DateTime.parse(json['renewsAt']) : null,
      cancelAtPeriodEnd: json['cancelAtPeriodEnd'] as bool? ?? false,
      enrolledPaths: json['enrolledPaths'] as int? ?? 0,
      completedPaths: json['completedPaths'] as int? ?? 0,
      certificates: json['certificates'] as int? ?? 0,
      challengesToday: json['challengesToday'] as int? ?? 0,
      dailyChallengeLimit: json['dailyChallengeLimit'] as int?,
      entitlements: PlanEntitlements.fromJson(json['entitlements'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class PlanEntitlements {
  final bool aiTutor;
  final bool proPaths;
  final bool unlimitedChallenges;
  final int? teamSeats;

  PlanEntitlements({
    this.aiTutor = false,
    this.proPaths = false,
    this.unlimitedChallenges = false,
    this.teamSeats,
  });

  factory PlanEntitlements.fromJson(Map<String, dynamic> json) {
    return PlanEntitlements(
      aiTutor: json['aiTutor'] as bool? ?? false,
      proPaths: json['proPaths'] as bool? ?? false,
      unlimitedChallenges: json['unlimitedChallenges'] as bool? ?? false,
      teamSeats: json['teamSeats'] as int?,
    );
  }
}
