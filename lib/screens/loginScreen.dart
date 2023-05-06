import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:video_player_lilac/screens/registrationScreen.dart';

import 'homeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobileNumberController = TextEditingController();
  bool _isOTPSent = false;

  Timer? _timer;
  int _start = 20;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }
  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: _mediaQuery.height * 0.3,
                  width: _mediaQuery.width * 0.7,

                  child: _isOTPSent == false
                      ? Image.asset("assets/loginvector1.png")
                      : Lottie.asset("assets/otp_verification.json"),
                ),
                SizedBox(
                  height: _mediaQuery.height * 0.15,
                  child: Column(
                    children: [
                      const Text(
                        "OTP Verification",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _isOTPSent == false
                          ? const Text(
                              "We will sent you a one time password\n to this number",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Enter the OTP sent to ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "${_mobileNumberController.text}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isOTPSent = false;
                                      _timer!.cancel();
                                      _start = 20;

                                    });
                                  },
                                  child: Text(
                                    " Edit",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: _mediaQuery.height * 0.1,
                  child: Column(
                    children: [
                      _isOTPSent == false
                          ? Text(
                              "Enter the mobile number",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            )
                          : SizedBox(),
                      SizedBox(
                        width: _mediaQuery.width * 0.6,
                        height: 50,
                        child: _isOTPSent == false
                            ? TextFormField(
                                controller: _mobileNumberController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "please enter the mobile number";
                                  }
                                  if (value.length != 10) {
                                    return "please enter the valid mobile number";
                                  }
                                },
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(87, 238, 157, 5),
                                        width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(87, 238, 157, 5),
                                        width: 2),
                                  ),
                                ),
                              )
                            : PinFieldAutoFill(
                                decoration: UnderlineDecoration(
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  colorBuilder: FixedColorBuilder(
                                    Color.fromRGBO(87, 238, 157, 5),
                                  ),
                                ),
                                //currentCode: _code,
                                onCodeSubmitted: (code) {},
                                onCodeChanged: (code) {
                                  if (code!.length == 6) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  }
                                },
                              ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      _isOTPSent == true
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Didn't you receive the OTP",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Text(
                                    " 0:${_start}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blue),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (_isOTPSent == false) {
                        setState(() {
                          _isOTPSent = true;
                          startTimer();
                        });
                      } else {
                        _timer!.cancel();
                        _start=20;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                      }
                    }
                  },
                  child: Container(
                    height: _mediaQuery.height * 0.06,
                    width: _mediaQuery.width * 0.62,
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Center(
                        child: _isOTPSent == false
                            ? Text(
                                "Get OTP",
                                style: TextStyle(fontWeight: FontWeight.w800),
                              )
                            : Text(
                                "Verify OTP",
                                style: TextStyle(fontWeight: FontWeight.w800),
                              )),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(87, 238, 157, 5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              _isOTPSent == false ?  SizedBox(
                  width: _mediaQuery.width * 0.66,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't you receive the OTP",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegistrationScreen(),));
                        },
                        child: Text(
                          " SignUp",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ):SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
