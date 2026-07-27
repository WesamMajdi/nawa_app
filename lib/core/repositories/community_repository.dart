import '../models/post_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';
import '../network/api_response.dart';

class CommunityRepository {
  final ApiClient _api;

  CommunityRepository(this._api);

  Future<PaginatedResponse<PostModel>> getPosts({
    String? type,
    String? topic,
    String? sort,
    String? author,
    String? cursor,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{'limit': limit};
    if (type != null) params['type'] = type;
    if (topic != null) params['topic'] = topic;
    if (sort != null) params['sort'] = sort;
    if (author != null) params['author'] = author;
    if (cursor != null) params['cursor'] = cursor;

    final response = await _api.get(ApiEndpoints.communityPosts, queryParameters: params);
    final data = response.data;
    return PaginatedResponse(
      items: (data['items'] as List).map((e) => PostModel.fromJson(e)).toList(),
      pageInfo: PageInfo.fromJson(data['pageInfo']),
    );
  }

  Future<List<TrendingTopicModel>> getTrendingTopics({int limit = 10}) async {
    final response = await _api.get(
      ApiEndpoints.communityTopicsTrending,
      queryParameters: {'limit': limit},
    );
    return (response.data as List).map((e) => TrendingTopicModel.fromJson(e)).toList();
  }

  Future<PostModel> createPost({
    required String type,
    required String title,
    required String body,
    String? languageCode,
    List<String>? imageUrls,
    List<String>? topics,
  }) async {
    final data = {
      'type': type,
      'title': title,
      'body': body,
      if (languageCode != null) 'languageCode': languageCode,
      if (imageUrls != null) 'imageUrls': imageUrls,
      if (topics != null) 'topics': topics,
    };
    final response = await _api.post(ApiEndpoints.communityPosts, data: data);
    return PostModel.fromJson(response.data);
  }

  Future<String> uploadImage(String filePath) async {
    // TODO: Implement multipart upload
    final response = await _api.post(ApiEndpoints.communityMediaImages);
    return response.data['url'] as String;
  }

  Future<List<ReplyModel>> getReplies(String postId, {String? cursor}) async {
    final params = <String, dynamic>{};
    if (cursor != null) params['cursor'] = cursor;

    final response = await _api.get(
      '${ApiEndpoints.communityPosts}/$postId/replies',
      queryParameters: params,
    );
    return (response.data as List).map((e) => ReplyModel.fromJson(e)).toList();
  }

  Future<ReplyModel> createReply({
    required String postId,
    required String body,
  }) async {
    final response = await _api.post(
      '${ApiEndpoints.communityPosts}/$postId/replies',
      data: {'body': body},
    );
    return ReplyModel.fromJson(response.data);
  }

  Future<Map<String, dynamic>> toggleLike(String postId) async {
    final response = await _api.post('${ApiEndpoints.communityPosts}/$postId/like');
    return response.data;
  }

  Future<void> removeLike(String postId) async {
    await _api.delete('${ApiEndpoints.communityPosts}/$postId/like');
  }
}
