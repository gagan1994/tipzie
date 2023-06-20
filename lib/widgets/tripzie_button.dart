import 'package:flutter/material.dart';

import '../utils/trppit_color.dart';

class TripzieButton extends StatelessWidget {
  String? button_text;

  var onPressed;

  TripzieButton({Key? key, this.button_text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: MaterialButton(
        color: button_color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        onPressed: onPressed ??
            () {
              print("implement on pressed");
            },
        child: Text(
          button_text ?? "Button text",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
