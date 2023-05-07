import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";
  static const VIDEO_PATH = "videoPath";

  setDownloadedVideoPath(List<String> videoPathList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(VIDEO_PATH, videoPathList);
  }

  Future<List<String>?> getDownloadedVideoPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(VIDEO_PATH) ?? [];
  }

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}
