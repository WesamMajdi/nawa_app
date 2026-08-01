import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nawa_flutter/core/models/challenge_model.dart';
import 'package:nawa_flutter/core/models/dashboard_model.dart';
import 'package:nawa_flutter/core/models/leaderboard_model.dart';
import 'package:nawa_flutter/core/models/path_model.dart';
import 'package:nawa_flutter/core/models/plan_model.dart';
import 'package:nawa_flutter/core/models/user_model.dart';
import 'package:nawa_flutter/core/models/user_models.dart';

Future<void> main() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://nawahtareq-001-site1.jtempurl.com/api/v1',
  ));
  final token = File('/tmp/opencode/token.txt').readAsStringSync().trim();
  dio.options.headers['Authorization'] = 'Bearer $token';
  dio.options.headers['X-Client'] = 'mobile';

  Future<void> check(String label, Future<void> Function() run) async {
    try {
      await run();
      print('OK   $label');
    } catch (e) {
      print('FAIL $label: $e');
    }
  }

  await check('me', () async {
    final r = await dio.get('/me');
    UserModel.fromJson(r.data['user'] as Map<String, dynamic>);
  });
  await check('me/dashboard', () async {
    final r = await dio.get('/me/dashboard');
    DashboardModel.fromJson(r.data);
  });
  await check('me/plan-usage', () async {
    final r = await dio.get('/me/plan-usage');
    final d = r.data['planUsage'] as Map<String, dynamic>? ?? r.data as Map<String, dynamic>;
    PlanUsageModel.fromJson(d);
  });
  await check('challenges/feed (plain array)', () async {
    final r = await dio.get('/challenges/feed', queryParameters: {'limit': 20});
    final list = r.data as List;
    list.map((e) => ChallengeModel.fromJson(e as Map<String, dynamic>)).toList();
  });
  await check('challenge detail', () async {
    final r = await dio.get('/challenges/0ddf3059-b9df-4fd9-8770-0240f539421d');
    ChallengeDetailModel.fromJson(r.data);
  });
  await check('paths list', () async {
    final r = await dio.get('/paths');
    (r.data as List).map((e) => PathCardModel.fromJson(e as Map<String, dynamic>)).toList();
  });
  await check('path detail', () async {
    final r = await dio.get('/paths/web-pro');
    PathDetailModel.fromJson(r.data);
  });
  await check('plans', () async {
    final r = await dio.get('/plans');
    (r.data as List).map((e) => PlanModel.fromJson(e as Map<String, dynamic>)).toList();
  });
  await check('me/badges', () async {
    final r = await dio.get('/me/badges');
    final list = r.data as List;
    list.map((e) => BadgeModel.fromJson(e as Map<String, dynamic>)).toList();
  });
  await check('me/learning', () async {
    final r = await dio.get('/me/learning');
    final list = r.data as List;
    list.map((e) => UserLearningModel.fromJson(e as Map<String, dynamic>)).toList();
  });
  await check('me/skills', () async {
    final r = await dio.get('/me/skills');
    final list = r.data as List;
    list.map((e) => SkillModel.fromJson(e as Map<String, dynamic>)).toList();
  });
  await check('me/activity', () async {
    final r = await dio.get('/me/activity', queryParameters: {'range': '30d'});
    ActivityModel.fromJson(r.data as Map<String, dynamic>);
  });
  await check('me/certificates', () async {
    final r = await dio.get('/me/certificates');
    (r.data as List).map((e) => CertificateModel.fromJson(e as Map<String, dynamic>)).toList();
  });
  await check('leaderboard', () async {
    final r = await dio.get('/leaderboard');
    final list = r.data['items'] as List? ?? r.data as List;
    list.map((e) => LeaderboardModel.fromJson(e as Map<String, dynamic>)).toList();
  });
}
