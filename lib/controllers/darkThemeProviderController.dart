import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player_lilac/utilites/darkThemePreference.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  static const THEME_STATUS = "THEMESTATUS";

  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;

    darkThemePreference.setDarkTheme(value);

    notifyListeners();
  }
}
