import 'package:flutter/material.dart';
import 'GlobalWidgets/dice_roll_loading.dart';
import 'View/SignUp.dart';
import 'View/Login.dart';
import 'View/Dashboard.dart';
import 'View/BoardGame/BoardGame.dart';
import 'View/Profile/ProfileView.dart';
import 'View/Booking/BookingPage.dart';
import 'View/Menu/MenuView.dart';
import 'View/GOW/GOWVotingPage.dart';
import 'View/GOW/GOWPage.dart';
import 'View/LoyaltyScheme/LoyaltyPage.dart';
import 'View/LoyaltyScheme/QrCodeGenerator.dart';
import 'View/FindYourGame.dart';
import 'View/Settings.dart';
import 'View/Profile/MyBookings.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/signup': (context) => SignUpPage(),
  '/login': (context) => LoginPage(),
  '/dashboard': (context) => DashboardPage(),
  '/boardgames': (context) => const PageIntroLoader(
    message: 'Loading board games...',
    child: BoardGame(),
  ),
  '/profile': (context) => ProfileView(),
  '/bookings': (context) => const PageIntroLoader(
    message: 'Loading bookings...',
    child: BookingPage(),
  ),
  '/menu': (context) =>
      const PageIntroLoader(message: 'Loading menu...', child: MenuView()),
  '/gow': (context) => GOWVotingPage(),
  '/gowresults': (context) => GOWPage(),
  '/loyalty': (context) => LoyaltyPage(),
  '/qr': (context) => QrCodeGenerator(),
  '/findyourgame': (context) => FindYourGameQuiz(),
  '/settings': (context) => SettingsPage(),
  '/mybookings': (context) => MyBookings(),
};
