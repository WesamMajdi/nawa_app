import '../models/dashboard_model.dart';
import '../models/user_model.dart';
import '../models/user_models.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class UserRepository {
  final ApiClient _api;

  UserRepository(this._api);

  Future<UserModel> getMe() async {
    final response = await _api.get(ApiEndpoints.me);
    return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
  }

  Future<DashboardModel> getDashboard() async {
    final response = await _api.get(ApiEndpoints.meDashboard);
    return DashboardModel.fromJson(response.data);
  }

  Future<UserModel> updateProfile({
    String? name,
    String? handle,
    String? avatarUrl,
    String? accentColor,
    String? jobTitle,
    String? bio,
    bool? isAvailableForHire,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (handle != null) data['handle'] = handle;
    if (avatarUrl != null) data['avatarUrl'] = avatarUrl;
    if (accentColor != null) data['accentColor'] = accentColor;
    if (jobTitle != null) data['jobTitle'] = jobTitle;
    if (bio != null) data['bio'] = bio;
    if (isAvailableForHire != null) data['isAvailableForHire'] = isAvailableForHire;

    final response = await _api.patch(ApiEndpoints.meProfile, data: data);
    return UserModel.fromJson(response.data);
  }

  Future<void> changeEmail({
    required String newEmail,
    required String currentPassword,
  }) async {
    await _api.patch(ApiEndpoints.meEmail, data: {
      'newEmail': newEmail,
      'currentPassword': currentPassword,
    });
  }

  Future<List<BadgeModel>> getBadges() async {
    final response = await _api.get(ApiEndpoints.meBadges);
    return (response.data as List).map((e) => BadgeModel.fromJson(e)).toList();
  }

  Future<List<UserLearningModel>> getLearning() async {
    final response = await _api.get(ApiEndpoints.meLearning);
    return (response.data as List).map((e) => UserLearningModel.fromJson(e)).toList();
  }

  Future<List<SkillModel>> getSkills() async {
    final response = await _api.get(ApiEndpoints.meSkills);
    return (response.data as List).map((e) => SkillModel.fromJson(e)).toList();
  }

  Future<ActivityModel> getActivity({String range = 'week'}) async {
    final response = await _api.get(ApiEndpoints.meActivity, queryParameters: {'range': range});
    return ActivityModel.fromJson(response.data);
  }
}
