import 'package:flutter/material.dart';

class CurrentRideScreen extends StatefulWidget {
  static const PAGE_NAME = 'current_rides_screen';
  const CurrentRideScreen({Key? key}) : super(key: key);

  @override
  State<CurrentRideScreen> createState() => _CurrentRideScreenState();
}

class _CurrentRideScreenState extends State<CurrentRideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
      ),
    );
  }
}
