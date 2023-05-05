import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_lilac/screens/profileScreen.dart';
import 'package:video_player_lilac/screens/video_player.dart';

import '../controllers/darkThemeProviderController.dart';

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

    super.initState();
    _isPlatformDark =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    var _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      key: _sideMenuKey,
      backgroundColor:  Provider.of<DarkThemeProvider>(context).darkTheme == false
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
                      fit: BoxFit.contain,
                      image: NetworkImage(
                          "https://thumbs.dreamstime.com/b/person-gray-photo-placeholder-man-t-shirt-white-background-147541161.jpg"),
                    )),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Profile"),
                leading: Icon(
                  Icons.account_circle_sharp,
                  color: Colors.black,
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(),));
                },
              ),
            ),
            Card(
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                textColor:Provider.of<DarkThemeProvider>(context).darkTheme ==
                                  false
                              ? Colors.black
                              : Colors.white,
                iconColor:Provider.of<DarkThemeProvider>(context).darkTheme ==
                                  false
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
                            borderRadius: BorderRadius.circular(14)),
                      )
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 30,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Container(
            //       height: _mediaQuery.height * 0.06,
            //       width: _mediaQuery.width * 0.14,
            //       decoration: BoxDecoration(
            //           color:
            //               Provider.of<DarkThemeProvider>(context).darkTheme ==
            //                       false
            //                   ? Colors.white
            //                   : Colors.grey.shade900,
            //           borderRadius: BorderRadius.circular(14)),
            //       child: Center(
            //         child: Icon(Icons.arrow_back_ios_new),
            //       ),
            //     ),
            //     Container(
            //       height: _mediaQuery.height * 0.06,
            //       width: _mediaQuery.width * 0.43,
            //       decoration: BoxDecoration(
            //           color:
            //               Provider.of<DarkThemeProvider>(context).darkTheme ==
            //                       false
            //                   ? Colors.white
            //                   : Colors.grey.shade900,
            //           borderRadius: BorderRadius.circular(14)),
            //       child: Center(
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Padding(
            //               padding: const EdgeInsets.only(right: 8.0),
            //               child: Icon(
            //                 Icons.arrow_drop_down_sharp,
            //                 size: 36,
            //                 color: Colors.lightGreen,
            //               ),
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.only(right: 12.0),
            //               child: Text(
            //                 "Download",
            //                 style: TextStyle(fontSize: 19),
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //     Container(
            //       height: _mediaQuery.height * 0.06,
            //       width: _mediaQuery.width * 0.14,
            //       decoration: BoxDecoration(
            //           color:
            //               Provider.of<DarkThemeProvider>(context).darkTheme ==
            //                       false
            //                   ? Colors.white
            //                   : Colors.grey.shade900,
            //           borderRadius: BorderRadius.circular(14)),
            //       child: Center(
            //         child: Icon(Icons.arrow_forward_ios),
            //       ),
            //     )
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
