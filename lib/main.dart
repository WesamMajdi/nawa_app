import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'core/theme/app_theme.dart';
import 'core/di/dependency_injection.dart';
import 'core/router/app_router.dart';
import 'core/blocs/auth/auth_bloc.dart';
import 'core/blocs/dashboard/dashboard_bloc.dart';
import 'core/blocs/path/path_bloc.dart';
import 'core/blocs/challenge/challenge_bloc.dart';
import 'core/blocs/community/community_bloc.dart';
import 'core/blocs/leaderboard/leaderboard_bloc.dart';
import 'core/blocs/notification/notification_bloc.dart';
import 'core/blocs/lesson/lesson_bloc.dart';
import 'core/blocs/certificate/certificate_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();
  Bloc.observer = const _AppBlocObserver();
  runApp(const NawahApp());
}

class NawahApp extends StatelessWidget {
  const NawahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilPlusInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: DependencyInjection.authRepository),
            RepositoryProvider.value(value: DependencyInjection.userRepository),
            RepositoryProvider.value(value: DependencyInjection.pathRepository),
            RepositoryProvider.value(value: DependencyInjection.lessonRepository),
            RepositoryProvider.value(value: DependencyInjection.challengeRepository),
            RepositoryProvider.value(value: DependencyInjection.communityRepository),
            RepositoryProvider.value(value: DependencyInjection.leaderboardRepository),
            RepositoryProvider.value(value: DependencyInjection.notificationRepository),
            RepositoryProvider.value(value: DependencyInjection.certificateRepository),
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => AuthBloc(DependencyInjection.authRepository)),
              BlocProvider(create: (_) => DashboardBloc(DependencyInjection.userRepository)),
              BlocProvider(create: (_) => PathBloc(DependencyInjection.pathRepository)),
              BlocProvider(create: (_) => ChallengeBloc(DependencyInjection.challengeRepository)),
              BlocProvider(create: (_) => CommunityBloc(DependencyInjection.communityRepository)),
              BlocProvider(create: (_) => LeaderboardBloc(DependencyInjection.leaderboardRepository)),
              BlocProvider(create: (_) => NotificationBloc(DependencyInjection.notificationRepository)),
              BlocProvider(create: (_) => LessonBloc(DependencyInjection.lessonRepository)),
              BlocProvider(create: (_) => CertificateBloc(DependencyInjection.certificateRepository)),
            ],
            child: MaterialApp.router(
              title: 'نواة',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.dark,
              builder: (context, child) => Directionality(
                textDirection: TextDirection.rtl,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0,
                  ),
                  child: child!,
                ),
              ),
              routerConfig: appRouter,
            ),
          ),
        );
      },
    );
  }
}

class _AppBlocObserver extends BlocObserver {
  const _AppBlocObserver();

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint('BlocError in ${bloc.runtimeType}: $error');
    super.onError(bloc, error, stackTrace);
  }
}
