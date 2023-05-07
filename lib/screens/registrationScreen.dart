import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player_lilac/screens/loginScreen.dart';

import '../utilites/services.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _mobileNumberControler = TextEditingController();

  String? _videoPath;

  Future<String> _videoIpload(File selectedImage) async {
    try {
      Reference reference = await FirebaseStorage.instance
          .ref()
          .child("image/${selectedImage!.path}");

      var uploadtask = await reference.putFile(selectedImage!);
      String url = await reference.getDownloadURL();

      setState(() {
        _videoPath = url;
      });
      print(url);
    } on Exception catch (e) {
      // TODO
    }
    return _videoPath!;
  }

  _dobselect() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2025));
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(date!);
    setState(() {
      _dobController.text = formatted;
    });
  }

  File? _profilePhoto;

  _pickImage() async {
    ImagePicker imagePicker = ImagePicker();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pick Image From"),
          content: Container(
            height: 100,
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    XFile? image = await imagePicker.pickImage(
                        source: ImageSource.gallery);

                    if (image != null) {
                      setState(() {
                        _profilePhoto = File(image.path);

                        Navigator.pop(context);
                      });
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 190,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(87, 238, 157, 5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(4, 4),
                            spreadRadius: 1,
                            blurRadius: 2,
                          )
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: Text(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () async {
                    XFile? image =
                        await imagePicker.pickImage(source: ImageSource.camera);

                    if (image != null) {
                      setState(() {
                        _profilePhoto = File(image.path);

                        Navigator.pop(context);
                      });
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 190,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(87, 238, 157, 5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(4, 4),
                            spreadRadius: 1,
                            blurRadius: 2,
                          )
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: Text(
                        "Camera",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: _mediaQuery.height * 0.25,
                    width: _mediaQuery.width * 0.7,
                    //color: Colors.black,

                    child: Lottie.asset("assets/42618-welcome.json",
                        fit: BoxFit.fill),
                  ),
                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: _mediaQuery.height * 0.15,
                    width: _mediaQuery.width * 0.3,
                    child: Stack(
                      children: [
                        Container(
                          height: _mediaQuery.height * 0.15,
                          width: _mediaQuery.width * 0.55,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: _profilePhoto == null
                                    ? BoxFit.contain
                                    : BoxFit.fill,
                                image: _profilePhoto == null
                                    ? NetworkImage(
                                        "https://thumbs.dreamstime.com/b/person-gray-photo-placeholder-man-t-shirt-white-background-147541161.jpg")
                                    : FileImage(_profilePhoto!)
                                        as ImageProvider<Object>,
                              )),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              child: InkWell(
                                  onTap: () {
                                    _pickImage();
                                  },
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 35,
                                  ))),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: _mediaQuery.height * 0.34,
                    width: _mediaQuery.width * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter your name";
                            }
                          },
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: "Enter your name",
                            hintStyle: TextStyle(color: Colors.grey),
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
                        ),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter the email";
                            }
                          },
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            hintText: "Enter your email",
                            hintStyle: TextStyle(color: Colors.grey),
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
                        ),
                        TextFormField(
                          controller: _dobController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please select date of birth";
                            }
                          },
                          textAlign: TextAlign.center,
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          onTap: () {
                            _dobselect();
                          },
                          decoration: const InputDecoration(
                            hintText: "Date of birth",
                            hintStyle: TextStyle(color: Colors.grey),
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
                        ),
                        TextFormField(
                          controller: _mobileNumberControler,
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
                            hintText: "Enter your mobile number",
                            hintStyle: TextStyle(color: Colors.grey),
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
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_profilePhoto != null) {
                          var details = await FirebaseFirestore.instance
                              .collection("userdeatils")
                              .get();
                          var userIsExist = details.docs.where((element) =>
                              element["number"] == _mobileNumberControler.text);

                          if (userIsExist.isEmpty || details == null) {
                            LoginScreen.verify =
                                await CommonUtils.firebasePhoneAuth(
                                    phone: "+91${_mobileNumberControler.text}",
                                    context: context);
                            var imageUploaded =
                                await _videoIpload(_profilePhoto!);

                            if (imageUploaded != null) {
                              Fluttertoast.showToast(
                                  msg: "OTP sent",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 16.0);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreen(
                                    isGetOTPSent: true,
                                    name: _nameController.text,
                                    age: _dobController.text,
                                    email: _emailController.text,
                                    registrtionVia: true,
                                    path: _videoPath,
                                    number: _mobileNumberControler.text),
                              ));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "something went wrong, please try again",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
                                  fontSize: 16.0);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Already have an account, please try to login",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.white,
                                textColor: Colors.black,
                                fontSize: 16.0);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please upload profile photo",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              fontSize: 16.0);
                        }
                      }
                    },
                    child: Container(
                      height: _mediaQuery.height * 0.06,
                      width: _mediaQuery.width * 0.62,
                      margin: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Center(
                          child: Text(
                        "Get OTP",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      )),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(87, 238, 157, 5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
