import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/darkThemeProviderController.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();

  String? imagePath;

  getDeatils() async {
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    var number = await sharedPreferences.getString("number");
    var details =
        await FirebaseFirestore.instance.collection("userdeatils").get();

    details.docs.forEach((element) {
      if (element["number"] == number) {
        setState(() {
          _nameController.text = element["name"];
          _emailController.text = element["email"];
          _dobController.text = element["age"];
          imagePath = element["imagePath"];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeatils();
  }

  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:
          Provider.of<DarkThemeProvider>(context).darkTheme == false
              ? Colors.grey.shade200
              : Colors.black,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_sharp,
                    size: 35,
                  ),
                ),
                Expanded(
                    child: Container(
                        child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 22.0),
                    child: Text(
                      "Profile",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                )))
              ],
            ),
          ),
          Column(
            children: [
              Container(
                height: _mediaQuery.height * 0.24,
                width: _mediaQuery.width * 0.55,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit:imagePath == null? BoxFit.contain:BoxFit.fill,
                        image: imagePath == null
                            ? NetworkImage(
                                "https://thumbs.dreamstime.com/b/person-gray-photo-placeholder-man-t-shirt-white-background-147541161.jpg")
                            : NetworkImage(imagePath!))),
              ),
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color:
                      Provider.of<DarkThemeProvider>(context).darkTheme == false
                          ? Colors.white
                          : Colors.grey.shade900,
                ),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 8)),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color:
                      Provider.of<DarkThemeProvider>(context).darkTheme == false
                          ? Colors.white
                          : Colors.grey.shade900,
                ),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 8)),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color:
                      Provider.of<DarkThemeProvider>(context).darkTheme == false
                          ? Colors.white
                          : Colors.grey.shade900,
                ),
                child: TextField(
                  controller: _dobController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 8)),
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
