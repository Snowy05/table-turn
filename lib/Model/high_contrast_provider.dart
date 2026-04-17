import 'package:flutter/material.dart';

class HighContrastProvider extends ChangeNotifier {
  bool _highContrast = false;
  bool get highContrast => _highContrast;

  void setHighContrast(bool value) {
    _highContrast = value;
    notifyListeners();
  }
}
