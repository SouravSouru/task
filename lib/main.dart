import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:video_player_lilac/screens/homeScreen.dart';
import 'package:video_player_lilac/screens/loginScreen.dart';

import 'controllers/darkThemeProviderController.dart';
import 'controllers/themedata.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // final isPlatformDark =
    //     WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    // final initTheme = isPlatformDark ? darkTheme : lightTheme;
    return ChangeNotifierProvider(
      child: Consumer<DarkThemeProvider>(
        builder: ( context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: Styles.themeData(value.darkTheme, context),
            builder: FToastBuilder(),

            home: LoginScreen(),
          );
        },
      ),
    create: (BuildContext context) {
        return DarkThemeProvider();
    },
    );
  }
}