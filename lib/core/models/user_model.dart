class UserModel {
  final String id;
  final String name;
  final String? handle;
  final String email;
  final String? jobTitle;
  final String? bio;
  final String? avatarUrl;
  final String? initials;
  final String? accentColor;
  final String role;
  final String status;
  final String planCode;
  final int level;
  final String? levelTitle;
  final int xp;
  final int xpToNext;
  final int streakDays;
  final int globalRank;
  final bool emailVerified;
  final bool isVerified;
  final bool verificationRequired;
  final bool isAvailableForHire;
  final DateTime? joinedAt;

  UserModel({
    required this.id,
    required this.name,
    this.handle,
    required this.email,
    this.jobTitle,
    this.bio,
    this.avatarUrl,
    this.initials,
    this.accentColor,
    required this.role,
    required this.status,
    required this.planCode,
    required this.level,
    this.levelTitle,
    required this.xp,
    required this.xpToNext,
    required this.streakDays,
    required this.globalRank,
    required this.emailVerified,
    this.isVerified = false,
    this.verificationRequired = false,
    required this.isAvailableForHire,
    this.joinedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      handle: json['handle'] as String?,
      email: json['email'] as String,
      jobTitle: json['jobTitle'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      initials: json['initials'] as String?,
      accentColor: json['accentColor'] as String?,
      role: json['role'] as String? ?? 'student',
      status: json['status'] as String? ?? 'active',
      planCode: json['planCode'] as String? ?? 'free',
      level: json['level'] as int? ?? 1,
      levelTitle: json['levelTitle'] as String?,
      xp: json['xp'] as int? ?? 0,
      xpToNext: json['xpToNext'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
      globalRank: json['globalRank'] as int? ?? 0,
      emailVerified: json['emailVerified'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      verificationRequired: json['verificationRequired'] as bool? ?? false,
      isAvailableForHire: json['isAvailableForHire'] as bool? ?? false,
      joinedAt: json['joinedAt'] != null ? DateTime.parse(json['joinedAt']) : null,
    );
  }
}
