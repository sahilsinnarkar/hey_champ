import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'firebase_options.dart';
import 'routes/app_routes.dart';

// Controllers
import 'package:hey_champ_app/features/chatbot/application/chatbot_controller.dart';
import 'package:hey_champ_app/features/daily_habit/application/habit_controller.dart';
import 'package:hey_champ_app/features/expenses/application/expenses_controller.dart';
import 'package:hey_champ_app/features/study_session/application/focus_session_controller.dart';
import 'package:hey_champ_app/features/study_session/application/subject_controller.dart';
import 'package:hey_champ_app/features/take_note/application/note_model.dart';
import 'package:hey_champ_app/features/todo/application/todo_controller.dart';

// Hive Models
import 'package:hey_champ_app/features/reminder/application/reminder_model.dart';
import 'package:hey_champ_app/features/study_session/application/focus_session_model.dart';
import 'package:hey_champ_app/features/study_session/application/subject_model.dart';
import 'package:hey_champ_app/features/todo/application/todo_model.dart';
import 'package:hey_champ_app/features/daily_habit/application/habit_model.dart';
import 'package:hey_champ_app/features/expenses/application/expenses_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();

  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  // Load environment variables
  await dotenv.load();

  // Lock orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Hive
  await Hive.initFlutter();

  // Timezone data
  tz.initializeTimeZones();

  _registerHiveAdapters();

  // Open Hive Boxes
  await Future.wait([
    Hive.openBox<Reminder>('reminders'),
    Hive.openBox<Subject>('subjects'),
    Hive.openBox<FocusSession>('sessions'),
    Hive.openBox<Todo>('todos'),
    Hive.openBox<Habit>('daily-habits'),
    Hive.openBox<Note>('notes'),
    Hive.openBox<ExpenseList>('expenses'),
  ]);
}

void _registerHiveAdapters() {
  Hive.registerAdapter(ReminderAdapter());       // 0
  Hive.registerAdapter(SubjectAdapter());        // 1
  Hive.registerAdapter(FocusSessionAdapter());   // 2
  Hive.registerAdapter(TodoAdapter());           // 3
  Hive.registerAdapter(HabitAdapter());          // 4
  Hive.registerAdapter(NoteAdapter());           // 5
  Hive.registerAdapter(ExpenseListAdapter());    // 6
  Hive.registerAdapter(ExpenseItemAdapter());    // 7
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiKey = dotenv.get('MY_GEMINI_API_KEY');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubjectController()),
        ChangeNotifierProvider(create: (_) => FocusSessionController()),
        ChangeNotifierProvider(create: (_) => ChatbotController(apiKey)),
        ChangeNotifierProvider(create: (_) => TodoController()),
        ChangeNotifierProvider(create: (_) => HabitController()),
        ChangeNotifierProvider(create: (_) => ExpenseController()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: "Hey Champ App",
        routerConfig: router,
        theme: ThemeData(textTheme: GoogleFonts.montserratTextTheme()),
      ),
    );
  }
}
