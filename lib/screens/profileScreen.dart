import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _nameController.text = "Sourav";
    _emailController.text = "Sourav@gmail.com";
    _dobController.text = "29/9/2023";
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
                onTap: (){
                  Navigator.pop(context);
                },
                 child:const  Icon(
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
          Container(
            height: _mediaQuery.height * 0.24,
            width: _mediaQuery.width * 0.55,
            decoration:const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: NetworkImage(
                      "https://thumbs.dreamstime.com/b/person-gray-photo-placeholder-man-t-shirt-white-background-147541161.jpg"),
                )),
          ),
          Container(
            margin:const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Provider.of<DarkThemeProvider>(context).darkTheme == false
                  ? Colors.white
                  : Colors.grey.shade900,
            ),
            child: TextField(
              controller: _nameController,
              decoration:const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 8)),
            ),
          ),
          Container(
            margin:const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Provider.of<DarkThemeProvider>(context).darkTheme == false
                  ? Colors.white
                  : Colors.grey.shade900,
            ),
            child: TextField(
              controller: _emailController,
              decoration:const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 8)),
            ),
          ),
          Container(
            margin:const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Provider.of<DarkThemeProvider>(context).darkTheme == false
                  ? Colors.white
                  : Colors.grey.shade900,
            ),
            child: TextField(
              controller: _dobController,
              decoration:const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 8)),
            ),
          )
        ],
      )),
    );
  }
}
