import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();
  runApp(const NawahApp());
}

class NawahApp extends StatelessWidget {
  const NawahApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        ],
        child: MaterialApp.router(
          title: 'نواة',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          builder: (context, child) => Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
