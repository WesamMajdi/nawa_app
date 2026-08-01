import '../models/dashboard_model.dart';
import '../models/path_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class PathRepository {
  final ApiClient _api;

  PathRepository(this._api);

  Future<List<PathCardModel>> getPaths({
    String? query,
    String? tag,
    String? level,
    String? filter,
  }) async {
    final params = <String, dynamic>{};
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (tag != null) params['tag'] = tag;
    if (level != null) params['level'] = level;
    if (filter != null) params['filter'] = filter;

    final response = await _api.get(ApiEndpoints.paths, queryParameters: params);
    return (response.data as List).map((e) => PathCardModel.fromJson(e)).toList();
  }

  Future<PathDetailModel> getPathDetail(String slug) async {
    final response = await _api.get('${ApiEndpoints.paths}/$slug');
    return PathDetailModel.fromJson(response.data);
  }

  Future<PathDetailModel> enrollPath(String slug) async {
    final response = await _api.post('${ApiEndpoints.paths}/$slug/enroll');
    return PathDetailModel.fromJson(response.data);
  }
}
