import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tableturn_project0/main.dart' as MyApp;
import '../Model/font_size_provider.dart';
import '../Model/high_contrast_provider.dart';
import '../Controller/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Locale? _selectedLocale;

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final highContrastProvider = Provider.of<HighContrastProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final currentLocale = _selectedLocale ?? Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.get('settings'))),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.get('fontSize'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 16),
            Slider(
              value: fontSizeProvider.fontScale,
              min: 0.8,
              max: 1.8,
              divisions: 10,
              label: fontSizeProvider.fontScale.toStringAsFixed(2),
              onChanged: (value) {
                fontSizeProvider.setFontScale(value);
              },
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.get('highContrast'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Switch(
                  value: highContrastProvider.highContrast,
                  onChanged: (value) {
                    highContrastProvider.setHighContrast(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.get('language'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                DropdownButton<Locale>(
                  value: currentLocale,
                  items: const [
                    DropdownMenuItem(
                      value: Locale('en'),
                      child: Text('English'),
                    ),
                    DropdownMenuItem(
                      value: Locale('es'),
                      child: Text('Español'),
                    ),
                  ],
                  onChanged: (locale) {
                    setState(() {
                      _selectedLocale = locale;
                    });
                    // Set the locale for the app
                    Locale newLocale = locale ?? const Locale('en');
                    MyApp.MyApp.setLocale(context, newLocale);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
