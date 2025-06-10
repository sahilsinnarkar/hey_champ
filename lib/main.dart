import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hey_champ_app/features/chatbot/application/chatbot_controller.dart';
import 'package:hey_champ_app/features/daily_habit/application/habit_controller.dart';
import 'package:hey_champ_app/features/daily_habit/application/habit_model.dart';
import 'package:hey_champ_app/features/reminder/application/reminder_model.dart';
import 'package:hey_champ_app/features/study_session/application/focus_session_model.dart';
import 'package:hey_champ_app/features/study_session/application/focus_session_controller.dart';
import 'package:hey_champ_app/features/study_session/application/subject_controller.dart';
import 'package:hey_champ_app/features/study_session/application/subject_model.dart';
import 'package:hey_champ_app/features/todo/application/todo_controller.dart';
import 'package:hey_champ_app/features/todo/application/todo_model.dart';
import 'package:hey_champ_app/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ENV
  await dotenv.load();

  // Orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Time
  tz.initializeTimeZones();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  /*

  Type Ids for Hive g.model files

  ReminderAdapter: 0
  SubjectAdapter: 1
  FocusSessionAdapter: 2
  TodoAdapter: 3
  HabitAdapter: 4

  */

  // Reminder feature
  Hive.registerAdapter(ReminderAdapter());
  await Hive.openBox<Reminder>('reminders');

  // Subject and session feature
  await Hive.initFlutter();
  Hive.registerAdapter(SubjectAdapter());
  Hive.registerAdapter(FocusSessionAdapter());
  await Hive.openBox<Subject>('subjects');
  await Hive.openBox<FocusSession>('sessions');

  // Todo feature
  Hive.registerAdapter(TodoAdapter());
  await Hive.openBox<Todo>('todos');

  // Daily habit feature
  Hive.registerAdapter(HabitAdapter());
  await Hive.openBox<Habit>('daily-habits');

  // Api key
  String apiKey = dotenv.get('MY_GEMINI_API_KEY');

  runApp(
    // Providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SubjectController()),
        ChangeNotifierProvider(create: (_) => FocusSessionController()),
        ChangeNotifierProvider(create: (_) => ChatbotController(apiKey)),
        ChangeNotifierProvider(create: (_) => TodoController()),
        ChangeNotifierProvider(create: (_) => HabitController()),
      ],

      // App
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Hey Champ App",
      routerConfig: router,
      theme: ThemeData(textTheme: GoogleFonts.montserratTextTheme()),
    );
  }
}
