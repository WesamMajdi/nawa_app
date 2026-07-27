import '../models/lesson_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class LessonRepository {
  final ApiClient _api;

  LessonRepository(this._api);

  Future<LessonDetailModel> getLesson(String id) async {
    final response = await _api.get('${ApiEndpoints.lessons}/$id');
    return LessonDetailModel.fromJson(response.data);
  }

  Future<LessonCompletionResult> completeLesson(String id) async {
    final response = await _api.post('${ApiEndpoints.lessons}/$id/complete');
    return LessonCompletionResult.fromJson(response.data);
  }

  Future<LessonCompletionResult> submitCode({
    required String id,
    required String sourceCode,
    required String languageCode,
  }) async {
    final response = await _api.post('${ApiEndpoints.lessons}/$id/submit', data: {
      'sourceCode': sourceCode,
      'languageCode': languageCode,
    });
    return LessonCompletionResult.fromJson(response.data);
  }

  Future<LessonCompletionResult> submitQuiz({
    required String id,
    required List<Map<String, dynamic>> answers,
  }) async {
    final response = await _api.post('${ApiEndpoints.lessons}/$id/quiz-submit', data: {
      'answers': answers,
    });
    return LessonCompletionResult.fromJson(response.data);
  }
}
