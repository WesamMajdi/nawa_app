import '../models/plan_model.dart';
import '../models/certificate_model.dart';
import '../network/api_client.dart';
import '../network/api_endpoints.dart';

class CertificateRepository {
  final ApiClient _api;

  CertificateRepository(this._api);

  Future<List<CertificateModel>> getCertificates() async {
    final response = await _api.get(ApiEndpoints.meCertificates);
    return (response.data as List).map((e) => CertificateModel.fromJson(e)).toList();
  }

  Future<List<PlanModel>> getPlans() async {
    final response = await _api.get(ApiEndpoints.plans);
    return (response.data as List).map((e) => PlanModel.fromJson(e)).toList();
  }

  Future<void> subscribe({
    required String planCode,
    required String billingCycle,
  }) async {
    await _api.post(ApiEndpoints.billingSubscriptions, data: {
      'planCode': planCode,
      'billingCycle': billingCycle,
    });
  }

  Future<void> cancelSubscription() async {
    await _api.post(ApiEndpoints.billingSubscriptionsCancel);
  }

  Future<PlanUsageModel> getPlanUsage() async {
    final response = await _api.get(ApiEndpoints.mePlanUsage);
    return PlanUsageModel.fromJson(response.data);
  }
}
