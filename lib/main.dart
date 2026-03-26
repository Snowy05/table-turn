import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tableturn_project0/View/BoardGame/BoardGame.dart';

import 'firebase_options.dart';
// Importing the views and controller
import 'View/SignUp.dart';
import 'View/Login.dart';
import 'View/Dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //theme settings, add dark later on
  static const Color primaryColor = Color(0xFF8C3F23);
  static const Color secondaryColor = Color(0xFF593825);

  final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    cardTheme: CardThemeData(
      color: Colors.brown[110],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.black, width: 2),
      ),
    ),
  );

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableTurn',
      theme: lightTheme,
      home: LoginPage(),
      routes: {
        //  routes for navigation
        '/signup': (context) => SignUpPage(),
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardPage(),
        '/boardgames': (context) => BoardGame(),
      },
    );
  }
}
