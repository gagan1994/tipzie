import 'package:flutter/material.dart';
import 'package:tripzie/widgets/tripzie_button.dart';

import '../../widgets/trippit_mainlayout.dart';
import 'common_ui.dart';
import 'login_screen.dart';

class LoginPage1 extends StatefulWidget {
  static const PAGE_NAME = "/login_page";

  const LoginPage1({Key? key}) : super(key: key);

  @override
  State<LoginPage1> createState() => _LoginPage1State();
}

class _LoginPage1State extends State<LoginPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TrippitMainLayout(Column(
        children: [
          Expanded(
            child: Container(),
          ),
          TripzieButton(
            button_text: "Get Started",
            onPressed: () {
              Navigator.pushNamed(context, LoginPage.PAGE_NAME);
            },
          ),
          bottom_layout_padding,
        ],
      )),
    );
  }
}
