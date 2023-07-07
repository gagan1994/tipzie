import 'package:flutter/material.dart';
import 'package:tripzie/ui/login/verify_otp_screen.dart';
import 'package:tripzie/utils/trppit_color.dart';
import 'package:tripzie/widgets/tripzie_button.dart';

import '../../auth/authentication.dart';
import '../../auth/google_signIn_button.dart';
import '../../widgets/trippit_mainlayout.dart';

class LoginPage extends StatefulWidget {
  static const PAGE_NAME = "/login_screen";

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final myController = TextEditingController();

  var _isValidPhone = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TrippitMainLayout(
        Column(
          children: [
            Expanded(
              child: Container(),
              flex: 3,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(fontSize: 40),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Register your account',
                    ),
                  ],
                ),
              ),
              flex: 3,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _textField('Enter Phone', myController),
                const SizedBox(
                  height: 15,
                ),
                TripzieButton(
                  button_text: "Send OTP",
                  onPressed: () {
                    _isValidPhone = isValidPhone(myController.text);
                    setState(() {
                      _isValidPhone;
                    });
                    if (!_isValidPhone) {
                      return;
                    }
                    Authentication.signInWithPhone(context, myController.text,
                        (verifyId, token) {
                      var phone = PhoneNumberDetails(
                          myController.text, verifyId, token);
                      print("phone details: ${phone.toString()}");
                      Navigator.pushNamed(context, VerifyOTP.PAGE_NAME,
                          arguments: phone);
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Login with your",
                        style: TextStyle(color: text_light_color),
                      ),
                      Text(
                        " Google account",
                        style: TextStyle(color: text_color),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                GoogleSignInButton(),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Widget _textField(String s, TextEditingController myController) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        keyboardType: TextInputType.phone,
        controller: myController,
        onChanged: (_) {
          if (!_isValidPhone) {
            setState(() {
              _isValidPhone = true;
            });
          }
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          errorText: !_isValidPhone ? 'Please enter valid phone number' : null,
          hintText: s,
        ),
        style: TextStyle(fontSize: 10),
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  bool isValidPhone(String email) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    return RegExp(patttern).hasMatch(email);
  }
}
