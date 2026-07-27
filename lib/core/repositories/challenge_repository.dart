import '../models/challenge_model.dart';
import '../models/dashboard_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/api_response.dart';

class ChallengeRepository {
  final ApiClient _api;

  ChallengeRepository(this._api);

  Future<PaginatedResponse<ChallengeModel>> getFeed({
    String? category,
    String? cursor,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{'limit': limit};
    if (category != null) params['category'] = category;
    if (cursor != null) params['cursor'] = cursor;

    final response = await _api.get(ApiEndpoints.challengesFeed, queryParameters: params);
    final data = response.data;
    return PaginatedResponse(
      items: (data['items'] as List).map((e) => ChallengeModel.fromJson(e)).toList(),
      pageInfo: PageInfo.fromJson(data['pageInfo']),
    );
  }

  Future<ChallengeDetailModel> getChallenge(String id) async {
    final response = await _api.get('${ApiEndpoints.challenges}/$id');
    return ChallengeDetailModel.fromJson(response.data);
  }

  Future<SubmissionResult> submitChallenge({
    required String id,
    required String sourceCode,
    required String languageCode,
  }) async {
    final response = await _api.post('${ApiEndpoints.challenges}/$id/submit', data: {
      'sourceCode': sourceCode,
      'languageCode': languageCode,
    });
    return SubmissionResult.fromJson(response.data);
  }

  Future<DailyChallengeModel?> getDailyChallenge() async {
    try {
      final response = await _api.get(ApiEndpoints.challengesDaily);
      return DailyChallengeModel.fromJson(response.data);
    } catch (_) {
      return null;
    }
  }

  Future<void> joinHackathon(String id) async {
    await _api.post('${ApiEndpoints.hackathons}/$id/join');
  }

  Future<void> remindHackathon(String id) async {
    await _api.post('${ApiEndpoints.hackathons}/$id/remind');
  }
}
