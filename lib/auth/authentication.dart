import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tripzie/api/user_data.dart';
import 'package:tripzie/socket/socket_wrapper.dart';
import 'package:tripzie/ui/login/login_screen.dart';

import '../norification/firebase_notifcation_wrapper.dart';
import '../utils/ui_utils.dart';

class Authentication {
  static UserProfile? loggedInUser = null;

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      showSnackBar(context, 'Error signing out. Try again.');
    }
  }

  static Future<FirebaseApp> initializeFirebase() async {
    print("FirebaseAuth init");
    FirebaseApp firebaseApp = await Firebase.initializeApp().whenComplete(() {
      print("FirebaseAuth completed");
    });
    FirebasePushNotificationWrapper.init();
    return firebaseApp;
  }

  static User getUser() {
    return FirebaseAuth.instance.currentUser!;
  }

  static Future<User?> signInWithPhone(
      BuildContext context,
      String phoneNumber,
      Function(
        String verificationId,
        int? forceResendingToken,
      ) callback) async {
    phoneNumber = "+91" + phoneNumber;
    print("Phone number for login: " + phoneNumber);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        showSnackBar(context, "Log in successful");
      },
      verificationFailed: (FirebaseAuthException e) {
        handleFirebaseException(context, e);
      },
      codeSent: callback,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static Future<User?> verifyOTP(
      BuildContext context, String verificationId, String smsCode) async {
    print("verify OTP: token: $verificationId code: $smsCode");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    try {
      var userCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCred.user;
    } on FirebaseAuthException catch (e) {
      handleFirebaseException(context, e);
      print(e);
    } catch (e) {
      showSnackBar(context, "error can't verify OTP");
    }
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      user = await tripzieSignInWithCredential(context, credential);
    }

    return user;
  }

  static Future<User?> tripzieSignInWithCredential(
      BuildContext context, AuthCredential credential) async {
    User? user;
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      handleFirebaseException(context, e);
    } catch (e) {
      showSnackBar(context, 'Error occurred using Google Sign In. Try again.');
    }
    return user;
  }

  static void handleFirebaseException(
      BuildContext context, FirebaseAuthException e) {
    if (e.code == 'account-exists-with-different-credential') {
      showSnackBar(
          context, 'The account already exists with a different credential.');
    } else if (e.code == 'invalid-credential') {
      showSnackBar(
          context, 'Error occurred while accessing credentials. Try again.');
    } else if (e.code == 'invalid-verification-code') {
      showSnackBar(context, "Code you have entered is invalid");
    }
  }

  static bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  static void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    SocketWrapper.instance.setUser(null);
    Navigator.pushNamedAndRemoveUntil(
        context, LoginPage.PAGE_NAME, (Route<dynamic> route) => false);
  }

  static String getName() {
    return (FirebaseAuth.instance.currentUser!.displayName == null)
        ? FirebaseAuth.instance.currentUser!.phoneNumber!
        : FirebaseAuth.instance.currentUser!.displayName!;
  }

  static String getEmail() {
    return (FirebaseAuth.instance.currentUser!.email != null)
        ? FirebaseAuth.instance.currentUser!.email!
        : "Not - Found";
  }

  static String getPhoneNumber() {
    return (FirebaseAuth.instance.currentUser!.phoneNumber != null)
        ? FirebaseAuth.instance.currentUser!.phoneNumber!
        : "Not - Found";
  }

  static bool isCurrentUser(String? userId) {
    if (userId == null) return false;
    return (userId == getUser().uid);
  }

  static String getImageUri() {
    return 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2';
  }

  static void setUser(UserProfile? user) {
    loggedInUser = user;
  }
}
