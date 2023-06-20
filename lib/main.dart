import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tripzie/ui/login/login_page_1.dart';
import 'package:tripzie/ui/login/login_screen.dart';
import 'package:tripzie/ui/login/verify_otp_screen.dart';
import 'package:tripzie/ui/main/rides/create_new_ride_screen.dart';
import 'package:tripzie/utils/ui_utils.dart';

import 'ui/main/main_screen.dart';
import 'ui/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SplashPage.PAGE_NAME,
      theme: ThemeData(
        fontFamily: getFontStyle(),
      ),
      onGenerateRoute: (settings) {
        print("Changing page request: ${settings.name}");
        switch (settings.name) {
          case SplashPage.PAGE_NAME:
            return fadeTransition(SplashPage());
          case MainScreen.PAGE_NAME:
            return rightToLeftTransition(MainScreen());
          case LoginPage.PAGE_NAME:
            return rightToLeftTransition(LoginPage());
          case LoginPage1.PAGE_NAME:
            return fadeTransition(LoginPage1());
          case VerifyOTP.PAGE_NAME:
            final phone = settings.arguments as PhoneNumberDetails;
            return rightToLeftTransition(VerifyOTP(phone));
          case CreateNewRideScreen.PAGE_NAME:
            return rightToLeftTransition(CreateNewRideScreen());
        }
      },
    );
  }

  PageTransition fadeTransition(StatefulWidget widget) {
    return PageTransition(
      child: widget,
      type: PageTransitionType.fade,
    );
  }

  PageTransition rightToLeftTransition(StatefulWidget widget) {
    return PageTransition(
      child: widget,
      type: PageTransitionType.rightToLeft,
    );
  }
}
