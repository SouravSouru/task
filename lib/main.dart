import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:video_player_lilac/screens/homeScreen.dart';
import 'package:video_player_lilac/screens/loginScreen.dart';
import 'package:video_player_lilac/screens/splashScreen.dart';
import 'package:video_player_lilac/utilites/darkThemePreference.dart';

import 'controllers/darkThemeProviderController.dart';
import 'utilites/themedata.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool currentTheme = await DarkThemePreference().getTheme() ?? false;
  await Firebase.initializeApp();
  runApp(MyApp(
    currentTheme: currentTheme,
  ));
}

class MyApp extends StatelessWidget {
  bool currentTheme;
  MyApp({required this.currentTheme, super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: Consumer<DarkThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: Styles.themeData(value.darkTheme, context),
            builder: FToastBuilder(),
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SplasScreen(
                      fromLogin: false,
                    );
                  } else {
                    return SplasScreen(
                      fromLogin: true,
                    );
                  }
                }),
          );
        },
      ),
      create: (BuildContext context) {
        return DarkThemeProvider();
      },
    );
  }
}
