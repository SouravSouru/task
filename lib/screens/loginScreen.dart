import 'dart:async';

import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player_lilac/screens/registrationScreen.dart';

import '../utilites/services.dart';
import 'homeScreen.dart';

class LoginScreen extends StatefulWidget {
  static String verify = "";
  bool isGetOTPSent;
  String? number;
  String? name;
  String? age;
  String? email;
  String? path;
  bool? registrtionVia;

  LoginScreen(
      {required this.isGetOTPSent,
      this.number,
      this.age,
      this.email,
      this.name,
      this.registrtionVia,
      this.path,
      Key? key})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _addDetailsToFirebase() async {
    Map<String, String> details = {
      "name": widget.name!,
      "age": widget.age!,
      "number": widget.number!,
      "email": widget.email!,
      "imagePath": widget.path!
    };

    await FirebaseFirestore.instance.collection("userdeatils").add(details);
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController? _otpController;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String _comingSms = 'Unknown';

  Future<void> initSmsListener() async {
    String? comingSms;
    try {
      comingSms = await AltSmsAutofill().listenForSms;
      setState(() {
        _comingSms = comingSms!;
        print("====>Message: ${_comingSms}");

        print("${_comingSms[1]}");
        _otpController!.text = _comingSms.toString().split("is").first.trim();
      });
    } catch (e) {
      comingSms = 'Failed to get Sms.';
      await AltSmsAutofill().unregisterListener();
    }

    await AltSmsAutofill().unregisterListener();
  }

  bool _isOTPSent = false;
  String _OTPCode = "";

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
    // _timer!.cancel();
    // _otpController!.dispose();
    // _mobileNumberController.dispose();
    AltSmsAutofill().unregisterListener();
    print("Unregistered Listener");
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _isOTPSent = widget.isGetOTPSent;
    if (widget.isGetOTPSent == true) {
      startTimer();
    }
    if (widget.number != null) {
      _mobileNumberController.text = widget.number!;
    }
    if (widget.registrtionVia == true) {
      startTimer();
      Future.delayed(Duration(seconds: 2)).then((value) => initSmsListener());
    }
    super.initState();
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
                  height: _mediaQuery.height * 0.13,
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
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(87, 238, 157, 5),
                                          width: 2),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(87, 238, 157, 5),
                                          width: 2),
                                    ),
                                  ),
                                )
                              : PinCodeTextField(
                                  length: 6,
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                  animationType: AnimationType.fade,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(5),
                                    fieldHeight: 50,
                                    fieldWidth: 40,
                                    activeColor: Colors.white,
                                    inactiveColor: Colors.white,
                                    disabledColor: Colors.white,
                                    inactiveFillColor: Colors.transparent,
                                    selectedFillColor:
                                        Color.fromRGBO(87, 238, 157, 5),
                                    activeFillColor: Colors.white,
                                  ),
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  backgroundColor: Colors.white,
                                  enableActiveFill: true,
                                  controller: _otpController,
                                  onCompleted: (v) {
                                    print("Completed");
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _OTPCode = value;
                                    });
                                  },
                                  appContext: context,
                                )),
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
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_isOTPSent == false) {
                        var details = await FirebaseFirestore.instance
                            .collection("userdeatils")
                            .get();
                        var userIsExist = details.docs.where((element) =>
                            element["number"] == _mobileNumberController.text);

                        if (details == null) {
                          Fluttertoast.showToast(
                              msg: "please create a account",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0);
                        }
                        if (userIsExist.isNotEmpty) {
                          LoginScreen.verify =
                              await CommonUtils.firebasePhoneAuth(
                                  phone: "+91${_mobileNumberController.text}",
                                  context: context);

                          Fluttertoast.showToast(
                              msg: "OTP sent",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0);

                          if (LoginScreen.verify == "verificationFailed") {
                            Fluttertoast.showToast(
                                msg: "Please try again later",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 16.0);
                          } else {
                            Future.delayed(const Duration(seconds: 4))
                                .then((e) {
                              setState(() {
                                _otpController = TextEditingController();
                                initSmsListener();
                                _isOTPSent = true;
                                startTimer();
                              });
                            });
                          }
                        } else {
                          ///------- no user
                          Fluttertoast.showToast(
                              msg: "please create a account",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0);
                        }
                      } else {
                        ///-------------------- verify otp section
                        try {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: CommonUtils.verify,
                                  smsCode: "$_OTPCode");
                          print("step -------------1");
                          UserCredential userCredential =
                              await auth.signInWithCredential(credential);
                          print("step -------------2");
                          SharedPreferences sharefpref =
                              await SharedPreferences.getInstance();
                          Fluttertoast.showToast(
                              msg: "OTP verified",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0);
                          print("step -------------3");
                          await sharefpref.setString(
                              "number", _mobileNumberController.text);

                          ///---------------- number saved to shared pref
                          print("step -------------4");
                          Navigator.of(context).pushAndRemoveUntil(
                            // the new route
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomeScreen(),
                            ),

                            (Route route) => false,
                          );
                          print("step -------------5");
                          if (widget.registrtionVia == true) {
                            _addDetailsToFirebase();
                          }
                          print("step -------------6");
                          _otpController!.dispose();
                          _mobileNumberController.dispose();
                        } catch (e) {
                          setState(() {
                            //  isLoaded = false;
                          });
                        }

                        _timer!.cancel();
                        _start = 20;
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
                _isOTPSent == false
                    ? SizedBox(
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
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegistrationScreen(),
                                ));
                              },
                              child: Text(
                                " SignUp",
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
