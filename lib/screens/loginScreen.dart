import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Text("Login",style: TextStyle(fontSize: 50,fontWeight: FontWeight.w600),),

            Text("Enter Mobile Number",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
            Container(
              height: _mediaQuery.height*0.08,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),

              ),
              child: TextFormField(
                controller: _mobileNumberController,
                validator: (value){
                  if(value!.isEmpty){
                    return "Please enter your mobile number";
                  }

                  if(value.length != 10){
                    return "Please enter valid phone number";
                  }
                },
                keyboardType: TextInputType.number,

                decoration: InputDecoration(
                  hintText: "Mobile Number",
                )
              ),
            ),
            Container(
              height: _mediaQuery.height*0.1,
              child: Center(child: Text("Get OTP")),
              decoration: BoxDecoration(
                color: Colors.grey
                ,
                borderRadius: BorderRadius.circular(20),

              ),
            )
          ],
        ),
      ),
    );
  }
}
