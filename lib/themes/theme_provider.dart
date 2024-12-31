import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chat_app/themes/dark_mode.dart';
import 'package:minimal_chat_app/themes/light_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;
  Color _themeColor = Colors.green;
  Color get themeColor => _themeColor;
  bool get isDarkMode => _themeData == darkMode;
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_themeData == lightMode) {
      themeData = darkMode;
      prefs.setBool('isDark', true);
    } else {
      themeData = lightMode;
      prefs.setBool('isDark', false);
    }
  }

  ThemeProvider(int color, bool isDark) {
    if (color != 0) {
      _themeColor = Color(color);
    }
    if (isDark) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }

  void setThemeColor(Color color) async {
    _themeColor = color;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeColor', color.value); // Save color
  }

  Future<void> loadThemeColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? colorValue = prefs.getInt('theme_color');
    if (colorValue != null) {
      _themeColor = Color(colorValue);
      log(colorValue.toString());
      notifyListeners();
    }
  }
}
