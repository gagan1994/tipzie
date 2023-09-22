import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tripzie/auth/authentication.dart';
import 'package:tripzie/background_task/background_location.dart';
import 'package:tripzie/ui/main/main_screen.dart';

import '../api/api_wrapper.dart';
import '../utils/trppit_color.dart';
import 'login/login_page_1.dart';

class SplashPage extends StatefulWidget {
  static const PAGE_NAME = '/';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashPage> {
  void _onTap() {
    // Navigator.pushNamed(
    //     context, isLoggedIn ? HomeScreen.PAGE_NAME : LoginPage1.PAGE_NAME);
  }

  @override
  void initState() {
    super.initState();
    checkAndMoveToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                GestureDetector(
                    onTap: _onTap,
                    child: CircleAvatar(
                      radius: 43,
                      backgroundColor: Colors.white,
                    )),
                //child: getSvgWidget(logo_image, 85, 85)),
                const Positioned.fill(
                    child:
                        Align(alignment: Alignment.center, child: Text("LOGO")))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'TRIPPIT',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButton:
          const Text('VERSION 1.0', style: TextStyle(color: version_color)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: accent_color,
    );
  }

  void checkAndMoveToNextScreen() async {
    await BackgroundLocationWrapper.instance.initialize();
    if (Authentication.isLoggedIn()) {
      print("fetchCurrentUserProfile");
      var user = await fetchCurrentUserProfile();
      print("fetchCurrentUserProfile result: $user");
      Authentication.setUser(user);
    } else {
      return;
    }
    Timer(
        const Duration(seconds: 3),
        () => {
              Navigator.pushReplacementNamed(
                  context,
                  Authentication.isLoggedIn()
                      ? MainScreen.PAGE_NAME
                      : LoginPage1.PAGE_NAME)
            });
  }
}
