import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tableturn_project0/main.dart' as MyApp;
import '../Model/font_size_provider.dart';
import '../Model/high_contrast_provider.dart';
import '../Controller/app_localizations.dart';
import '../GlobalWidgets/GlobalDropdownField.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Locale? _selectedLocale;

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required String description,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final isHighContrast = theme.colorScheme.primary == Colors.black;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isHighContrast ? Colors.black : Colors.white.withOpacity(0.86),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isHighContrast
              ? Colors.white.withOpacity(0.28)
              : const Color(0xFFE6D1B0),
        ),
        boxShadow: isHighContrast
            ? const []
            : [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.10),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isHighContrast
                  ? Colors.white.withOpacity(0.78)
                  : Colors.brown.shade700,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fontSizeProvider = Provider.of<FontSizeProvider>(context);
    final highContrastProvider = Provider.of<HighContrastProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final currentLocale = _selectedLocale ?? Localizations.localeOf(context);
    final theme = Theme.of(context);
    final isHighContrast = theme.colorScheme.primary == Colors.black;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.get('settings'))),
      body: Container(
        decoration: BoxDecoration(
          gradient: isHighContrast
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.black],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFFFFF), Color(0xFFF9E6C1)],
                ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSectionCard(
                            context: context,
                            title: localizations.get('fontSize'),
                            description:
                                'Scale text across the app for a more comfortable reading size.',
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Text scale',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isHighContrast
                                            ? Colors.white.withOpacity(0.10)
                                            : const Color(0xFFFFF4E3),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: Text(
                                        '${(fontSizeProvider.fontScale * 100).round()}%',
                                        style: theme.textTheme.labelLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Slider(
                                  value: fontSizeProvider.fontScale,
                                  min: 0.8,
                                  max: 1.8,
                                  divisions: 10,
                                  label: fontSizeProvider.fontScale
                                      .toStringAsFixed(2),
                                  onChanged: (value) {
                                    fontSizeProvider.setFontScale(value);
                                  },
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Smaller',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    const Spacer(),
                                    Text(
                                      'Larger',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSectionCard(
                            context: context,
                            title: localizations.get('highContrast'),
                            description:
                                'Increase contrast to make text and controls stand out more clearly.',
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'High contrast mode',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        highContrastProvider.highContrast
                                            ? 'Stronger contrast is currently enabled.'
                                            : 'Use stronger contrast for improved readability.',
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Switch.adaptive(
                                  value: highContrastProvider.highContrast,
                                  onChanged: (value) {
                                    highContrastProvider.setHighContrast(value);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSectionCard(
                            context: context,
                            title: localizations.get('language'),
                            description:
                                'Choose which language the app uses for labels and navigation.',
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: SizedBox(
                                width: 220,
                                child: GlobalDropdownField<Locale>(
                                  value: currentLocale,
                                  hintText: localizations.get('language'),
                                  maxWidth: double.infinity,
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
                                    Locale newLocale =
                                        locale ?? const Locale('en');
                                    MyApp.MyApp.setLocale(context, newLocale);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
