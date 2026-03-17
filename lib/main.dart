import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
// Importing the views and controller
import 'View/SignUp.dart';
import 'View/Login.dart';
import 'View/DashBoard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( MyApp());
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
  );

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableTurn',
      theme: lightTheme,
      home: SignUpPage(),
      routes: {
        //  routes for navigation
        '/signup': (context) => SignUpPage(),
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashBoardPage(),
      },
    );
  }
}
