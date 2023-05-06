import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            height: 400,
            width: 300,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  // offset: Offset(2,2),
                  color: Colors.yellow,
                  spreadRadius: 3,
                  blurRadius: 4
                )
              ],
              
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                Container(
                  height: _mediaQuery.height * 0.06,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                      controller: _mobileNumberController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your mobile number";
                        }

                        if (value.length != 10) {
                          return "Please enter valid phone number";
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          //border: InputBorder.none,
                           enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.black,width: 2),   
                      ),  
              focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black,width: 2),
                   ), 
                          hintText: "Mobile Number",
                          hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.only(left: 8))),
                ),
                Container(
                  height: _mediaQuery.height * 0.06,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PinFieldAutoFill(
                      decoration: UnderlineDecoration(
                        textStyle:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        colorBuilder: FixedColorBuilder(Colors.black),
                      ),
                      //currentCode: _code,
                      onCodeSubmitted: (code) {},
                      onCodeChanged: (code) {
                        if (code!.length == 6) {
                          FocusScope.of(context).requestFocus(FocusNode());
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  height: _mediaQuery.height * 0.06,
                  width: 100,
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  child: Center(
                      child: Text(
                    "Get OTP",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  )),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
