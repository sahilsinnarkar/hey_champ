import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hey_champ_app/features/auth/application/auth_service.dart';
import 'package:hey_champ_app/features/auth/presentation/signin_screen.dart';
import 'package:hey_champ_app/features/auth/presentation/signup_screen.dart';
import 'package:hey_champ_app/features/chatbot/presentation/chatbot_screen.dart';
import 'package:hey_champ_app/features/home/presentation/home_screen.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:hey_champ_app/features/reminder/presentation/new_reminder_screen.dart';
import 'package:hey_champ_app/features/reminder/presentation/reminder_screen.dart';
import 'package:hey_champ_app/features/study_session/application/subject_model.dart';
import 'package:hey_champ_app/features/study_session/presentation/add_edit_subject_screen.dart';
import 'package:hey_champ_app/features/study_session/presentation/subject_detail_screen.dart';
import 'package:hey_champ_app/features/study_session/presentation/subject_list_screen.dart';

final router = GoRouter(
  initialLocation: '/signin',

  refreshListenable: GoRouterRefreshStream(authServices.value.authStateChanges),
  redirect: (BuildContext context, GoRouterState state) {
    final loggedIn = authServices.value.currentUser != null;
    final goingToSignIn =
        state.fullPath == '/signin' || state.fullPath == '/signup';

    if (!loggedIn && !goingToSignIn) {
      return '/signin';
    }

    if (loggedIn && goingToSignIn) {
      return '/home';
    }
    return null;
  },

  routes: [
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => SignUpScreen(),
    ),
    GoRoute(
      path: '/signin',
      name: 'signin',
      builder: (context, state) => SignInScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/reminder',
      name: 'reminder',
      builder: (context, state) => ReminderScreen(),
    ),
    GoRoute(
      path: '/new-reminder',
      name: 'new-reminder',
      builder: (context, state) => NewReminderScreen(),
    ),
    GoRoute(
      path: '/subject-screen',
      name: 'subject-screen',
      builder: (context, state) => SubjectListScreen(),
    ),
    GoRoute(
      path: '/add-edit-subject-screen',
      name: 'add-edit-subject-screen',
      builder: (context, state) => AddEditSubjectScreen(),
    ),
    GoRoute(
      path: '/subject-detail-screen',
      name: 'subject-detail-screen',
      builder: (context, state) {
        final subject = state.extra as Subject; // ✅ Cast safely
        return SubjectDetailScreen(subject: subject); // ✅ Pass it to screen
      },
    ),
    GoRoute(
      path: '/chatbot-screen',
      name: 'chatbot-screen',
      builder: (context, state) => ChatbotScreen(),
    ),
  ],
);

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((event) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
