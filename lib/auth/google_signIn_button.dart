import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tripzie/api/api_wrapper.dart';
import 'package:tripzie/api/user_data.dart';
import 'package:tripzie/ui/user_avatar.dart';
import 'package:tripzie/utils/ui_utils.dart';

import '../db/shared_pref_wrapper.dart';
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
                loginAction(context, user);
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

void loginAction(BuildContext context, User user) async {
  if (false) {
    var usersHash = await fetchProfiles();
    List<UserProfile> values = [];
    values.addAll(usersHash.values);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async =>
                true, // <-- Prevents dialog dismiss on press of back button.
            child: AlertDialog(
              title: Text('Select user to login'),
              content: Container(
                height: 300.0, // Change as per your requirement
                width: 300.0, // Change as per your requirement
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: values.length,
                  itemBuilder: (BuildContext context, int index) {
                    var user = values[index];

                    return ListTile(
                      onTap: () async {
                        Authentication.loggedInUser = user;
                        showSnackBar(
                            context, "logging in with ${user.firstName}");
                        await SharedPrefWrapper.instance.saveUser(user.userId!);
                        await updateExistingUser(user);
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            MainScreen.PAGE_NAME,
                            (Route<dynamic> route) => false);
                      },
                      title: Text(user.firstName ?? ""),
                      leading: UserAvatar(
                        imageUrl: user.imageUri ?? "",
                        radius: 25,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        });
    return;
  }
  var isSuccess = await loginOrCreateUser(user);
  if (isSuccess) {
    showSnackBarApiSuccess(context);
    Navigator.pushNamedAndRemoveUntil(
        context, MainScreen.PAGE_NAME, (Route<dynamic> route) => false);
  } else {
    showSnackBarApiError(context);
  }
}
