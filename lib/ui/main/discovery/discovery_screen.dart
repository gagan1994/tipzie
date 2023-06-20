import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tripzie/utils/trippit_assets.dart';
import 'package:tripzie/utils/trppit_color.dart';

import '../bottom_navbar_screen.dart';

class DiscoveryScreen extends TripzieBottomNavBarScreen {
  static const PAGE_NAME = "/discovery_screen";

  const DiscoveryScreen({Key? key}) : super(key: key);

  @override
  State<DiscoveryScreen> createState() => DiscoveryScreenState();
}

class DiscoveryScreenState extends State<DiscoveryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 10, top: 50, right: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  ic_hamburger_menu,
                  color: hambuger_light,
                ),
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(38)),
                      color: notif_bg_color),
                  child: Stack(
                    children: [
                      Positioned(
                        child: Icon(
                          Icons.notifications_none,
                          color: notif_selected_bg_color,
                        ),
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                      ),
                      Positioned(
                        right: 11.5,
                        top: 11.5,
                        child: Container(
                          height: 7,
                          width: 7,
                          decoration: BoxDecoration(
                              color: notif_selected_bg_color,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border:
                                  Border.all(color: notif_bg_color, width: 1)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Discovery",
              style: TextStyle(
                  fontSize: 28,
                  color: accent_color,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 6,
            ),
            const Text(
              "Explore the  best places in world!",
              style: TextStyle(
                  fontSize: 16, color: text_light, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              color: Colors.white,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
                decoration: const BoxDecoration(
                  color: edit_text_bg_color,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15),
                            hintText: "Enter Destination "),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: const BoxDecoration(
                        color: notif_bg_color,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Icon(
                        Icons.search,
                        color: notif_selected_bg_color,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
