import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/dependency_injection.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
import '../blocs/path/path_bloc.dart';
import '../blocs/challenge/challenge_bloc.dart';
import '../blocs/community/community_bloc.dart';
import '../blocs/leaderboard/leaderboard_bloc.dart';
import '../blocs/notification/notification_bloc.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login/login_screen.dart';
import '../../features/auth/signup/signup_screen.dart';
import '../../features/home/dashboard_screen.dart';
import '../../features/explore/explore_screen.dart';
import '../../features/path_details/path_details_screen.dart';
import '../../features/lesson_viewing/lesson_viewing_screen.dart';
import '../../features/challenges/challenges_screen.dart';
import '../../features/challenge_details/challenge_details_screen.dart';
import '../../features/community/community_screen.dart';
import '../../features/leaderboard/leaderboard_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/account_settings/account_settings_screen.dart';
import '../../features/certificates_store/certificates_store_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/explore',
      builder: (context, state) => const ExploreScreen(),
    ),
    GoRoute(
      path: '/path/:slug',
      builder: (context, state) => PathDetailsScreen(
        pathSlug: state.pathParameters['slug']!,
      ),
    ),
    GoRoute(
      path: '/lesson/:id',
      builder: (context, state) => LessonViewingScreen(
        lessonId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/challenges',
      builder: (context, state) => const ChallengesScreen(),
    ),
    GoRoute(
      path: '/challenge/:id',
      builder: (context, state) => ChallengeDetailsScreen(
        challengeId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/community',
      builder: (context, state) => const CommunityScreen(),
    ),
    GoRoute(
      path: '/leaderboard',
      builder: (context, state) => const LeaderboardScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/account-settings',
      builder: (context, state) => const AccountSettingsScreen(),
    ),
    GoRoute(
      path: '/certificates-store',
      builder: (context, state) => const CertificatesStoreScreen(),
    ),
  ],
);
