import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tableturn_project0/View/Dashboard.dart';
import 'package:tableturn_project0/Model/font_size_provider.dart';
import 'package:tableturn_project0/Model/high_contrast_provider.dart';
import 'theme/light_theme.dart';
import 'theme/high_contrast_theme.dart';

import 'Controller/app_localizations.dart';
import 'package:tableturn_project0/View/Login.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'Model/bookingFormModel.dart';
import 'app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingFormModel()..load()),
        ChangeNotifierProvider(create: (_) => FontSizeProvider()),
        ChangeNotifierProvider(create: (_) => HighContrastProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<FontSizeProvider, HighContrastProvider>(
      builder: (context, fontSizeProvider, highContrastProvider, child) {
        return Builder(
          builder: (context) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(fontSizeProvider.fontScale),
              ),
              child: MaterialApp(
                title: 'TableTurn',
                debugShowCheckedModeBanner: false,
                theme: highContrastProvider.highContrast
                    ? HighContrastTheme.theme
                    : AppTheme.lightTheme,
                locale: _locale,
                home: FirebaseAuth.instance.currentUser == null
                    ? const LoginPage()
                    : const DashboardPage(),
                routes: appRoutes,
                // Localization setup
                localizationsDelegates: const [
                  AppLocalizationsDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en'), Locale('es')],
                localeResolutionCallback: (locale, supportedLocales) {
                  if (locale == null) return supportedLocales.first;
                  for (var supported in supportedLocales) {
                    if (supported.languageCode == locale.languageCode) {
                      return supported;
                    }
                  }
                  return supportedLocales.first;
                },
              ),
            );
          },
        );
      },
    );
  }
}
