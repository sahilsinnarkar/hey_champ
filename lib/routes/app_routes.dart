import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hey_champ_app/features/auth/application/auth_service.dart';
import 'package:hey_champ_app/features/auth/presentation/signin_screen.dart';
import 'package:hey_champ_app/features/auth/presentation/signup_screen.dart';
import 'package:hey_champ_app/features/home/presentation/home_screen.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:hey_champ_app/features/reminder/presentation/new_reminder_screen.dart';
import 'package:hey_champ_app/features/reminder/presentation/reminder_screen.dart';

final router = GoRouter(

  initialLocation: '/signin',

  refreshListenable: GoRouterRefreshStream(authServices.value.authStateChanges),
  redirect: (BuildContext context, GoRouterState state) {
    final loggedIn = authServices.value.currentUser != null;
    final goingToSignIn = state.fullPath == '/signin' || state.fullPath == '/signup';

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
  ]

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
