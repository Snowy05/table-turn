import 'package:flutter/material.dart';
// used to manage font size scaling across the app, allowing dynamic adjustment of text sizes based on user preferences or accessibility needs. The provider pattern is used to notify listeners of changes in font scale, enabling responsive UI updates when the font size is changed.
class FontSizeProvider extends ChangeNotifier {
  double _fontScale = 1.0;
  double get fontScale => _fontScale;

  void setFontScale(double scale) {
    _fontScale = scale;
    notifyListeners();
  }
}
