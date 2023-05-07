import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player_lilac/screens/loginScreen.dart';
import 'package:video_player_lilac/screens/profileScreen.dart';
import 'package:video_player_lilac/screens/video_player.dart';

import '../controllers/darkThemeProviderController.dart';
import '../utilites/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _sideMenuKey = GlobalKey<ScaffoldState>();

  bool _isdark = false;
  bool? _isPlatformDark;
  @override
  void initState() {
    // TODO: implement initState
    getDeatils();
    super.initState();

    Future.delayed(Duration(seconds: 3)).then((value) {
      setState(() {
        getDeatils();
      });
    });
    _isPlatformDark =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
  }

  String? imagePath;

  getDeatils() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var number = await sharedPreferences.getString("number");
    var details =
        await FirebaseFirestore.instance.collection("userdeatils").get();

    details.docs.forEach((element) {
      if (element["number"] == number) {
        setState(() {
          imagePath = element["imagePath"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      key: _sideMenuKey,
      backgroundColor:
          Provider.of<DarkThemeProvider>(context).darkTheme == false
              ? Colors.grey.shade200
              : Colors.black,
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color:
                    Provider.of<DarkThemeProvider>(context).darkTheme == false
                        ? Colors.grey.shade200
                        : Colors.grey.shade900,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: imagePath == null ? BoxFit.contain : BoxFit.fill,
                      image: imagePath == null
                          ? NetworkImage(
                              "https://thumbs.dreamstime.com/b/person-gray-photo-placeholder-man-t-shirt-white-background-147541161.jpg")
                          : NetworkImage(imagePath!)),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Profile"),
                leading: Icon(
                  Icons.account_circle_sharp,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ));
                },
              ),
            ),
            Card(
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                textColor:
                    Provider.of<DarkThemeProvider>(context).darkTheme == false
                        ? Colors.black
                        : Colors.white,
                iconColor:
                    Provider.of<DarkThemeProvider>(context).darkTheme == false
                        ? Colors.black
                        : Colors.white,
                title: ListTile(
                  title: Text("Settings"),
                  leading: Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                ),
                children: [
                  ListTile(
                    title: Text("Dark"),
                    leading: Icon(
                      _isdark == true
                          ? Icons.dark_mode_sharp
                          : Icons.dark_mode_outlined,
                      color: Colors.black,
                    ),
                    trailing: Switch(
                      activeColor: Colors.black,
                      onChanged: (value) {
                        setState(() {
                          themeChange.darkTheme = value;
                          _isdark = value;
                        });
                      },
                      value: themeChange.darkTheme,
                    ),
                  )
                ],
              ),
            ),
            Card(
              child: ListTile(
                onTap: () async {
                  await CommonUtils.firebaseSignOut();
                  SharedPreferences shedpref =
                      await SharedPreferences.getInstance();
                  await shedpref.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                    // the new route
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          LoginScreen(isGetOTPSent: false),
                    ),

                    (Route route) => false,
                  );
                },
                title: Text("Logout"),
                leading: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: _mediaQuery.height * 0.37,
              child: Stack(
                children: [
                  Video_Player(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            _sideMenuKey.currentState!.openDrawer();
                          },
                          child: SizedBox(
                            height: 38,
                            width: 38,
                            child: Image.asset(
                              "assets/menu-bar.png",
                              color: Provider.of<DarkThemeProvider>(context)
                                          .darkTheme ==
                                      false
                                  ? Colors.white
                                  : Colors.grey.shade900,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 38,
                        width: 38,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                                fit: imagePath == null
                                    ? BoxFit.contain
                                    : BoxFit.fill,
                                image: imagePath == null
                                    ? NetworkImage(
                                        "https://thumbs.dreamstime.com/b/person-gray-photo-placeholder-man-t-shirt-white-background-147541161.jpg")
                                    : NetworkImage(imagePath!)),
                            borderRadius: BorderRadius.circular(14)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
