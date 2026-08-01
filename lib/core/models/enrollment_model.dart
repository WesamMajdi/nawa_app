class EnrollmentModel {
  final String enrollmentId;
  final String pathId;
  final int progressPct;
  final String status;

  EnrollmentModel({
    required this.enrollmentId,
    required this.pathId,
    required this.progressPct,
    required this.status,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      enrollmentId: json['enrollmentId'] as String,
      pathId: json['pathId'] as String,
      progressPct: json['progressPct'] as int? ?? 0,
      status: json['status'] as String,
    );
  }
}