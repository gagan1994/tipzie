import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../ui/main/main_screen.dart';
import '../utils/trippit_assets.dart';
import 'authentication.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return _isSigningIn
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        : GestureDetector(
            onTap: () async {
              setState(() {
                _isSigningIn = true;
              });

              User? user =
                  await Authentication.signInWithGoogle(context: context);
              if (user != null) {
                Navigator.pushNamedAndRemoveUntil(context, MainScreen.PAGE_NAME,
                    (Route<dynamic> route) => false);
              }
              setState(() {
                _isSigningIn = false;
              });
              print("user obj: ${user}");
            },
            child: SvgPicture.asset(
              google_logo,
              width: 30,
              height: 30,
            ),
          );
  }
}
