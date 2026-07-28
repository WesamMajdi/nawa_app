import '../network/api_client.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/path_repository.dart';
import '../repositories/lesson_repository.dart';
import '../repositories/challenge_repository.dart';
import '../repositories/community_repository.dart';
import '../repositories/leaderboard_repository.dart';
import '../repositories/notification_repository.dart';
import '../repositories/certificate_repository.dart';

class DependencyInjection {
  static late final ApiClient _apiClient;
  static late final AuthRepository _authRepository;
  static late final UserRepository _userRepository;
  static late final PathRepository _pathRepository;
  static late final LessonRepository _lessonRepository;
  static late final ChallengeRepository _challengeRepository;
  static late final CommunityRepository _communityRepository;
  static late final LeaderboardRepository _leaderboardRepository;
  static late final NotificationRepository _notificationRepository;
  static late final CertificateRepository _certificateRepository;

  static void init() {
    _apiClient = ApiClient();
    _authRepository = AuthRepository(_apiClient);
    _userRepository = UserRepository(_apiClient);
    _pathRepository = PathRepository(_apiClient);
    _lessonRepository = LessonRepository(_apiClient);
    _challengeRepository = ChallengeRepository(_apiClient);
    _communityRepository = CommunityRepository(_apiClient);
    _leaderboardRepository = LeaderboardRepository(_apiClient);
    _notificationRepository = NotificationRepository(_apiClient);
    _certificateRepository = CertificateRepository(_apiClient);
  }

  static ApiClient get apiClient => _apiClient;
  static AuthRepository get authRepository => _authRepository;
  static UserRepository get userRepository => _userRepository;
  static PathRepository get pathRepository => _pathRepository;
  static LessonRepository get lessonRepository => _lessonRepository;
  static ChallengeRepository get challengeRepository => _challengeRepository;
  static CommunityRepository get communityRepository => _communityRepository;
  static LeaderboardRepository get leaderboardRepository => _leaderboardRepository;
  static NotificationRepository get notificationRepository => _notificationRepository;
  static CertificateRepository get certificateRepository => _certificateRepository;
}
