import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tableturn_project0/Model/font_size_provider.dart';
import 'package:tableturn_project0/View/BoardGame/BoardGame.dart';
import 'package:tableturn_project0/View/Booking/BookingPage.dart';
import 'package:tableturn_project0/View/FindYourGame.dart';
import 'package:tableturn_project0/View/GOW/GOWPage.dart';
import 'package:tableturn_project0/View/GOW/GOWVotingPage.dart';
import 'package:tableturn_project0/View/LoyaltyScheme/LoyaltyPage.dart';
import 'package:tableturn_project0/View/LoyaltyScheme/QrCodeGenerator.dart';
import 'package:tableturn_project0/View/Menu/MenuView.dart';
import 'package:tableturn_project0/View/ProfileView.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'Model/bookingFormModel.dart';
import 'View/SignUp.dart';
import 'View/Login.dart';
import 'View/Dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingFormModel()..load()),
        ChangeNotifierProvider(create: (_) => FontSizeProvider()),
      ],
      child: MyApp(),
    ),
  );
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(primaryColor),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        side: WidgetStateProperty.all(
          const BorderSide(color: Colors.black, width: 1),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.black, width: 1),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            // White text, black stroke will be handled in button child
          ),
        ),
        elevation: WidgetStateProperty.all(2),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(primaryColor),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        side: WidgetStateProperty.all(
          const BorderSide(color: Colors.black, width: 1),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.black, width: 1),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(primaryColor),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        side: WidgetStateProperty.all(
          const BorderSide(color: Colors.black, width: 1),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.black, width: 1),
          ),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.brown[300],
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<FontSizeProvider>(
      //fontsize provider manages the scaling of text across the app, allowing dynamic adjustment of font sizes based on user preferences or accessibility needs. By wrapping the MaterialApp in a Consumer widget
      // we can listen for changes in the FontSizeProvider and update the text scaling throughout the app 
      builder: (context, fontSizeProvider, child) {
        return Builder(
          builder: (context) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(fontSizeProvider.fontScale),
              ),
              child: MaterialApp(
                title: 'TableTurn',
                theme: lightTheme,
                home: LoginPage(),
                routes: {
                  '/signup': (context) => SignUpPage(),
                  '/login': (context) => LoginPage(),
                  '/dashboard': (context) => DashboardPage(),
                  '/boardgames': (context) => BoardGame(),
                  '/profile': (context) => ProfileView(),
                  '/bookings': (context) => BookingPage(),
                  '/menu': (context) => MenuView(),
                  '/gow': (context) => GOWVotingPage(),
                  '/gowresults': (context) => GOWPage(),
                  '/loyalty': (context) => LoyaltyPage(),
                  '/qr': (context) => QrCodeGenerator(),
                  '/findyourgame': (context) => FindYourGameQuiz(),
                },
              ),
            );
          },
        );
      },
    );
  }
}
