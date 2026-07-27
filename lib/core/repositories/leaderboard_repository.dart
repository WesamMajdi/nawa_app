import '../models/leaderboard_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/api_response.dart';

class LeaderboardRepository {
  final ApiClient _api;

  LeaderboardRepository(this._api);

  Future<PaginatedResponse<LeaderboardModel>> getLeaderboard({
    String period = 'weekly',
    bool aroundMe = false,
    String? cursor,
    int limit = 50,
  }) async {
    final params = <String, dynamic>{
      'period': period,
      'limit': limit,
    };
    if (aroundMe) params['around'] = 'me';
    if (cursor != null) params['cursor'] = cursor;

    final response = await _api.get(ApiEndpoints.leaderboard, queryParameters: params);
    final data = response.data;
    return PaginatedResponse(
      items: (data['items'] as List).map((e) => LeaderboardModel.fromJson(e)).toList(),
      pageInfo: PageInfo.fromJson(data['pageInfo']),
    );
  }
}
