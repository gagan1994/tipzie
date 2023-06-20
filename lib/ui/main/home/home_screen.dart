import 'package:flutter/material.dart';
import 'package:tripzie/ui/main/bottom_navbar_screen.dart';

import '../../map_screen.dart';

class HomeScreen extends TripzieBottomNavBarScreen {
  static const PAGE_NAME = "/home_screen";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Center(
            child: TripzieMap(),
          ),
        ),
      ],
    );
  }
}
/*
 FloatingActionButton.small(
            backgroundColor: Colors.white,
            onPressed: () {},
            child: SvgPicture.asset(
              ic_hamburger_menu,
              height: 15,
              width: 15,
            ),
          )
* */
