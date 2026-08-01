class ApiEndpoints {
  ApiEndpoints._();

  static const String _base = '/auth';

  // Auth
  static const String register = '$_base/register';
  static const String login = '$_base/login';
  static const String refresh = '$_base/refresh';
  static const String logout = '$_base/logout';
  static const String forgotPassword = '$_base/password/forgot';
  static const String resetPassword = '$_base/password/reset';
  static const String changePassword = '$_base/password/change';

  // Me
  static const String me = '/me';
  static const String meNotificationRead = '/me/notifications/';  // append {id}/read
  static const String meDashboard = '/me/dashboard';
  static const String meProfile = '/me/profile';
  static const String meEmail = '/me/email';
  static const String meBadges = '/me/badges';
  static const String meLearning = '/me/learning';
  static const String meSkills = '/me/skills';
  static const String meActivity = '/me/activity';
  static const String meNotifications = '/me/notifications';
  static const String meNotificationsUnreadCount = '/me/notifications/unread-count';
  static const String meNotificationsReadAll = '/me/notifications/read-all';
  static const String meCertificates = '/me/certificates';
  static const String mePlanUsage = '/me/plan-usage';

  // Paths
  static const String paths = '/paths';
  static const String pathEnroll = '/paths/';  // append {slug}/enroll

  // Lessons
  static const String lessons = '/lessons';

  // Challenges
  static const String challenges = '/challenges';
  static const String challengesFeed = '/challenges/feed';
  static const String challengesDaily = '/challenges/daily';

  // Hackathons
  static const String hackathons = '/hackathons';

  // Community
  static const String communityPosts = '/community/posts';
  static const String communityTopicsTrending = '/community/topics/trending';
  static const String communityMediaImages = '/community/media/images';

  // Leaderboard
  static const String leaderboard = '/leaderboard';

  // Users
  static const String users = '/users';

  // Plans & Billing
  static const String plans = '/plans';
  static const String billingSubscriptions = '/billing/subscriptions';
  static const String billingSubscriptionsCancel = '/billing/subscriptions/cancel';

  // Certificates
  static const String certificates = '/certificates';
  static const String certificateDownload = '/certificates/';  // append {id}/download
}
