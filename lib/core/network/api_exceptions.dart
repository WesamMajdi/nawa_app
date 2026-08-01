class ApiException implements Exception {
  final String code;
  final String title;
  final int status;
  final String? detail;
  final String? traceId;
  final Map<String, List<String>>? errors;

  ApiException({
    required this.code,
    required this.title,
    required this.status,
    this.detail,
    this.traceId,
    this.errors,
  });

  @override
  String toString() => 'ApiException($code): $title';

  String toUserMessage() {
    switch (code) {
      case 'invalid_credentials':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
      case 'account_suspended':
        return 'حسابك موقوف، يرجى التواصل مع الدعم';
      case 'account_rejected':
        return 'لم يتم قبول حسابك، يرجى التواصل مع الدعم';
      case 'email_taken':
        return 'البريد الإلكتروني مستخدم مسبقاً';
      case 'handle_taken':
        return 'اسم المستخدم مستخدم مسبقاً';
      case 'validation_failed':
        return 'يرجى التحقق من البيانات المدخلة';
      case 'not_enrolled':
        return 'يجب التسجيل في المسار أولاً';
      case 'upgrade_required':
        return 'هذا المحتوى يتطلب باقة أعلى، يرجى الترقية';
      case 'plan_daily_limit_reached':
        return 'لقد تجاوزت الحد اليومي للتحديات، قم بالترقية للحصول على تحديات غير محدودة';
      case 'already_enrolled':
        return 'أنت مسجل في هذا المسار مسبقاً';
      case 'refresh_reuse_detected':
        return 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى';
      case 'not_found':
        return 'المحتوى غير موجود';
      case 'hackathon_not_live':
        return 'الهاكاثون غير متاح حالياً';
      case 'already_joined':
        return 'أنت منضم للهاكاثون مسبقاً';
      case 'unauthorized':
        return 'يرجى تسجيل الدخول للمتابعة';
      case 'internal_error':
        return 'حدث خطأ في الخادم، يرجى المحاولة لاحقاً';
      case 'unknown':
      case 'network':
      case 'network_error':
        return 'تعذر الاتصال بالخادم، تحقق من اتصالك بالإنترنت';
      default:
        return title;
    }
  }

  static ApiException fromJson(Map<String, dynamic> json) {
    return ApiException(
      code: json['code'] as String? ?? 'unknown',
      title: json['title'] as String? ?? 'Unknown error',
      status: json['status'] as int? ?? 500,
      detail: json['detail'] as String?,
      traceId: json['traceId'] as String?,
      errors: (json['errors'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          key,
          (value as List).map((e) => e.toString()).toList(),
        ),
      ),
    );
  }
}
