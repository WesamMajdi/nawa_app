import '../models/notification_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/api_response.dart';

class NotificationRepository {
  final ApiClient _api;

  NotificationRepository(this._api);

  Future<PaginatedResponse<NotificationModel>> getNotifications({
    String? status,
    String? cursor,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{'limit': limit};
    if (status != null) params['status'] = status;
    if (cursor != null) params['cursor'] = cursor;

    final response = await _api.get(ApiEndpoints.meNotifications, queryParameters: params);
    final data = response.data;
    return PaginatedResponse(
      items: (data['items'] as List).map((e) => NotificationModel.fromJson(e)).toList(),
      pageInfo: PageInfo.fromJson(data['pageInfo']),
    );
  }

  Future<int> getUnreadCount() async {
    final response = await _api.get(ApiEndpoints.meNotificationsUnreadCount);
    return response.data['count'] as int? ?? 0;
  }

  Future<void> markAsRead(String id) async {
    await _api.post('${ApiEndpoints.meNotifications}/$id/read');
  }

  Future<void> markAllAsRead() async {
    await _api.post(ApiEndpoints.meNotificationsReadAll);
  }
}
