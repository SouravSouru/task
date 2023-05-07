import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player_lilac/screens/loginScreen.dart';

import 'homeScreen.dart';

class SplasScreen extends StatefulWidget {
  bool fromLogin;
  SplasScreen({required this.fromLogin, Key? key}) : super(key: key);

  @override
  State<SplasScreen> createState() => _SplasScreenState();
}

class _SplasScreenState extends State<SplasScreen> {
  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration(seconds: 3)).then((value) {
      if (widget.fromLogin == true) {
        Navigator.of(context).pushAndRemoveUntil(
          // the new route
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(isGetOTPSent: false),
          ),

          (Route route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          // the new route
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(),
          ),

          (Route route) => false,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Lottie.asset("assets/42618-welcome.json"),
        ),
      ),
    );
  }
}
