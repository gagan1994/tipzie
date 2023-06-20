import 'package:flutter/material.dart';

import '../bottom_navbar_screen.dart';

class WalletScreen extends TripzieBottomNavBarScreen {
  static const PAGE_NAME = "/ride_screen";

  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => WalletScreenState();
}

class WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text("In Progress...!"),
    );
  }
}
