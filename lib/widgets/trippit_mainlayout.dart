import 'package:flutter/material.dart';

class TrippitMainLayout extends StatelessWidget {
  var child;
  TrippitMainLayout(this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: this.child,
    );
  }
}
