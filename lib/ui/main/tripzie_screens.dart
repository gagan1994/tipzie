import 'package:flutter/material.dart';

class TrpzieScreens<T> extends StatefulWidget {
  const TrpzieScreens({Key? key}) : super(key: key);

  @override
  State<TrpzieScreens> createState() => TrpzieScreensState();
}

class TrpzieScreensState extends State<TrpzieScreens> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text("In Progress"),
    );
  }
}
