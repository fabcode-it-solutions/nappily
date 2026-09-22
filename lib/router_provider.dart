import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:notizen/features/advice/screens/ai_advice_screen.dart';
import 'package:notizen/features/advice/screens/expert_advice_screen.dart';
import 'package:notizen/features/auth/auth.dart';
import 'package:notizen/features/auth/screens/delete_account_screen.dart';
import 'package:notizen/features/coaching-plan/screens/coaching_plan_screen.dart';
import 'package:notizen/features/coaching-plan/screens/finishing_screen.dart';
import 'package:notizen/features/general-info/controller/reading_controller.dart';
import 'package:notizen/features/general-info/screens/general_info_screen.dart';
import 'package:notizen/features/general-info/screens/reading_screen.dart';
import 'package:notizen/features/privacy-policy/screens/privacy_screen.dart';
import 'package:notizen/features/question-results/screens/result_screen.dart';
import 'package:notizen/features/questionnaire/screens/questionnaire_screen.dart';
import 'package:notizen/features/questionnaire/screens/subscribe_now_screen.dart';
import 'package:notizen/features/recent-notifications/screen/read_notification_screen.dart';
import 'package:notizen/features/recent-notifications/screen/recent_notification_screen.dart';
import 'package:notizen/features/user-profile/screens/user_screen.dart';
import 'package:notizen/models/recent_notification_model.dart';
import 'package:notizen/utils/user_local_storage.dart';
import 'package:notizen/features/auth/screens/forgot_password.dart';
import 'package:notizen/features/auth/screens/login_screen.dart';
import 'package:notizen/features/baby-profile/screens/baby_profile_screen.dart';
import 'package:notizen/features/notifications/screens/notifications.dart';
import 'package:notizen/features/settings/screens/settings.dart';
import 'package:notizen/features/subscription-plan/screens/subscription_screen.dart';
import 'package:notizen/welcome/screens/home_screen.dart';
import 'package:notizen/welcome/screens/home_without_sub_screen.dart';
import 'package:notizen/welcome/screens/hurdle_screen.dart';

import 'welcome/screens/welcome.dart';

import 'features/auth/screens/sign_up.dart';
import 'features/auth/screens/email_verify.dart';

final authProvider = ChangeNotifierProvider<AppAuth>((ref) => AppAuth());

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: auth,
    redirect: (context, state) async {
      final signedIn = auth.signedIn;

      final isAuthRoute = [
        '/welcome',
        '/sign-up',
        '/verify-email',
        '/forgot-password',
        '/login',
      ].contains(state.uri.toString());

      if (!signedIn && !isAuthRoute) {
        final welcomeSeen = await UserLocalStorage.getLocalStorage(
          key: 'isWelcomeScreen',
        );
        return welcomeSeen != null ? '/login' : '/welcome';
      }

      if (signedIn && isAuthRoute) return '/settings';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) {
          return auth.signedIn
              ? '/home'
              : '/welcome'; // It should be "auth.signedIn ? '/home' : '/welcome'" After developement;
        },
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) {
          return Builder(
            builder: (context) {
              return WelcomeScreen();
            },
          );
        },
      ),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) {
          return customTransition(state, HomeScreen());
        },
      ),
      GoRoute(
        path: '/home-with-subscription',
        pageBuilder: (context, state) {
          return customTransition(state, HomeWithoutSubScreen());
        },
      ),
      GoRoute(
        path: '/sign-up',
        pageBuilder: (context, state) {
          return customTransition(state, SignUpScreen());
        },
      ),
      GoRoute(
        path: '/verify-email',
        pageBuilder: (context, state) {
          return customTransition(state, EmailVerifyScreen());
        },
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) {
          return customTransition(state, LoginScreen());
        },
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) {
          return customTransition(state, ForgotPasswordScreen());
        },
      ),
      GoRoute(
        path: '/baby-profile',
        pageBuilder: (context, state) {
          return customTransition(state, BabyProfileScreen());
        },
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) {
          return customTransition(state, SettingsScreen());
        },
      ),
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) {
          return customTransition(state, NotificationsScreen());
        },
      ),
      GoRoute(
        path: '/subscription-plans',
        pageBuilder: (context, state) {
          return customTransition(state, SubscriptionScreen());
        },
      ),
      GoRoute(
        path: '/questionnaire',
        pageBuilder: (context, state) {
          return customTransition(state, QuestionnaireScreen());
        },
      ),
      GoRoute(
        path: '/subscribe-now',
        pageBuilder: (context, state) {
          return customTransition(state, SubscribeNowScreen());
        },
      ),
      GoRoute(
        path: '/expert-advice',
        pageBuilder: (context, state) {
          return customTransition(state, ExpertAdviceScreen());
        },
      ),
      GoRoute(
        path: '/ai-advice',
        pageBuilder: (context, state) {
          return customTransition(state, AiAdviceScreen());
        },
      ),
      GoRoute(
        path: '/question-results',
        pageBuilder: (context, state) {
          return customTransition(state, ResultScreen());
        },
      ),
      GoRoute(
        path: '/coaching-plans',
        pageBuilder: (context, state) {
          return customTransition(state, CoachingPlanScreen());
        },
      ),
      GoRoute(
        path: '/finishing',
        pageBuilder: (context, state) {
          return customTransition(state, FinishingScreen());
        },
      ),
      GoRoute(
        path: '/general-info',
        pageBuilder: (context, state) {
          return customTransition(state, GeneralInfoScreen());
        },
      ),
      GoRoute(
        path: '/privacy-policy',
        pageBuilder: (context, state) {
          return customTransition(state, PrivacyPolicyScreen());
        },
      ),
      GoRoute(
        path: '/delete-account',
        pageBuilder: (context, state) {
          return customTransition(state, DeleteAccountScreen());
        },
      ),
      GoRoute(
        path: '/recent-notifications',
        pageBuilder: (context, state) {
          return customTransition(state, RecentNotificationsScreen());
        },
      ),
      GoRoute(
        path: '/edit-profile',
        pageBuilder: (context, state) {
          return customTransition(state, EditProfileScreen());
        },
      ),

      GoRoute(
        path: '/topic-detail',
        name: 'topic-detail',
        builder: (context, state) {
          final args = state.extra as TopicDetailArgs;
          return ProviderScope(
            overrides: [currentTopicsProvider.overrideWithValue(args.topics)],
            child: TopicDetailScreen(initialIndex: args.initialIndex),
          );
        },
      ),

      GoRoute(
        path: '/notification/:id',
        name: 'notificationDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final notification = state.extra as AppNotification?;
          return NotificationDetailScreen(
            notificationId: id,
            notification: notification,
          );
        },
      ),
      GoRoute(
        path: '/hurdle-details/:id',
        name: 'hurdleDetail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return HurdleDetailScreen(id: id);
        },
      ),
    ],
  );
});
CustomTransitionPage<dynamic> customTransition(GoRouterState state, screen) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      );
    },
  );
}
