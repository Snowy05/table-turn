import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Model/font_size_provider.dart';
import '../Model/high_contrast_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final highContrastProvider = Provider.of<HighContrastProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Font Size',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                const Text(
                  'High Contrast Mode',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
            // Add more settings here (e.g., theme, language)
          ],
        ),
      ),
    );
  }
}
