import '../models/challenge_model.dart';
import '../models/dashboard_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class ChallengeRepository {
  final ApiClient _api;

  ChallengeRepository(this._api);

  Future<List<ChallengeModel>> getFeed({
    String? category,
    String? cursor,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{'limit': limit};
    if (category != null) params['category'] = category;
    if (cursor != null) params['cursor'] = cursor;

    final response = await _api.get(ApiEndpoints.challengesFeed, queryParameters: params);
    return (response.data as List)
        .map((e) => ChallengeModel.fromJson(e as Map<String, dynamic>))
        .toList();
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

  Future<DailyChallengeModel> getDailyChallenge() async {
    final response = await _api.get(ApiEndpoints.challengesDaily);
    return DailyChallengeModel.fromJson(response.data);
  }

  Future<void> joinHackathon(String id) async {
    await _api.post('${ApiEndpoints.hackathons}/$id/join');
  }

  Future<void> remindHackathon(String id) async {
    await _api.post('${ApiEndpoints.hackathons}/$id/remind');
  }
}
