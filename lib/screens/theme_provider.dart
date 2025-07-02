import 'package:flutter/material.dart';
import 'preferences_services.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    _isDarkMode = await PreferencesService.getDarkMode();
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await PreferencesService.setDarkMode(_isDarkMode);
    notifyListeners();
  }
}
