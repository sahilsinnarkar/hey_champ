import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hey_champ_app/features/reminder/application/reminder_model.dart';
import 'package:hey_champ_app/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:timezone/data/latest_all.dart' as tz;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp]
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  tz.initializeTimeZones();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(ReminderAdapter()); // You'll define this adapter
  await Hive.openBox<Reminder>('reminders');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Hey Champ App",
      routerConfig: router,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
    );
  }
}
