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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableTurn',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
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
