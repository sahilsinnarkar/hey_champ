import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hey_champ_app/features/auth/application/auth_service.dart';
import 'package:hey_champ_app/features/auth/presentation/signin_screen.dart';
import 'package:hey_champ_app/features/auth/presentation/signup_screen.dart';
import 'package:hey_champ_app/features/chatbot/presentation/chatbot_screen.dart';
import 'package:hey_champ_app/features/daily_habit/application/habit_model.dart';
import 'package:hey_champ_app/features/daily_habit/presentation/create_habit_screen.dart';
import 'package:hey_champ_app/features/daily_habit/presentation/daily_haibit_tracker_list_screen.dart';
import 'package:hey_champ_app/features/daily_habit/presentation/habit_detail_screen.dart';
import 'package:hey_champ_app/features/expenses/presentation/expense_detail_screen.dart';
import 'package:hey_champ_app/features/expenses/presentation/expenses_list_screen.dart';
import 'package:hey_champ_app/home/presentation/home_screen.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:hey_champ_app/features/reminder/presentation/new_reminder_screen.dart';
import 'package:hey_champ_app/features/reminder/presentation/reminder_screen.dart';
import 'package:hey_champ_app/features/study_session/application/subject_model.dart';
import 'package:hey_champ_app/features/study_session/presentation/add_edit_subject_screen.dart';
import 'package:hey_champ_app/features/study_session/presentation/subject_detail_screen.dart';
import 'package:hey_champ_app/features/study_session/presentation/subject_list_screen.dart';
import 'package:hey_champ_app/features/take_note/presentation/note_list_screen.dart';
import 'package:hey_champ_app/features/take_note/presentation/take_note_screen.dart';
import 'package:hey_champ_app/features/todo/presentation/todo_screen.dart';

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
    GoRoute(
      path: '/todo-screen',
      name: 'todo-screen',
      builder: (context, state) => TodoScreen(),
    ),
    GoRoute(
      path: '/daily-habit-tracker-list-screen',
      name: 'daily-habit-tracker-list-screen',
      builder: (context, state) => DailyHabitTrackerListScreen(),
    ),
    GoRoute(
      path: '/create-habit-screen',
      name: 'create-habit-screen',
      builder: (context, state) => CreateHabitScreen(),
    ),
    GoRoute(
      path: '/habit-detail-screen',
      name: 'habit-detail-screen',
      builder: (context, state) {
        final habit = state.extra;
        if (habit == null || habit is! Habit) {
          return const Scaffold(
            body: Center(child: Text("Invalid habit data")),
          );
        }
        return HabitDetailScreen(habit: habit);
      },
    ),
    GoRoute(
      path: '/note-list-screen',
      name: 'note-list-screen',
      builder: (context, state) => NoteListScreen(),
    ),
    GoRoute(
      path: '/take-note-screen',
      name: 'take-note-screen',
      builder: (context, state) => TakeNoteScreen(),
    ),
    GoRoute(
      path: '/expenses-list-screen',
      name: 'expenses-list-screen',
      builder: (context, state) => ExpensesListScreen(),
    ),
    GoRoute(
      path: '/expense-detail-screen',
      name: 'expense-detail-screen',
      builder: (context, state) => ExpenseDetailScreen(),
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
