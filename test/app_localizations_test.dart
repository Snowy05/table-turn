import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tableturn_project0/Controller/app_localizations.dart';

void main() {
  group('AppLocalizations', () {
    test('returns the Spanish translation for a known key', () {
      final localizations = AppLocalizations(const Locale('es'));

      expect(localizations.get('settings'), 'Configuración');
      expect(localizations.get('login'), 'Iniciar sesión');
    });

    test('falls back to English for unsupported locales', () {
      final localizations = AppLocalizations(const Locale('fr'));

      expect(localizations.get('settings'), 'Settings');
    });

    test('returns the key when no translation exists', () {
      final localizations = AppLocalizations(const Locale('en'));

      expect(localizations.get('missingKey'), 'missingKey');
    });

    test('delegate only supports configured locales', () {
      const delegate = AppLocalizationsDelegate();

      expect(delegate.isSupported(const Locale('en')), isTrue);
      expect(delegate.isSupported(const Locale('es')), isTrue);
      expect(delegate.isSupported(const Locale('fr')), isFalse);
    });
  });
}
