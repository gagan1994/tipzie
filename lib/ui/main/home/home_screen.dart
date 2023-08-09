import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tripzie/ui/main/bottom_navbar_screen.dart';
import 'package:tripzie/ui/main/profile/profile_screen.dart';

import '../../../utils/trippit_assets.dart';
import '../../../utils/trppit_color.dart';
import '../../../utils/ui_utils.dart';
import '../rides/models.dart';

class HomeScreen extends TripzieBottomNavBarScreen {
  static const PAGE_NAME = "/home_screen";
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        child: Column(
          children: [
            verticalDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: SvgPicture.asset(
                    ic_hamburger_menu,
                    height: 15,
                    width: 15,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, ProfileScreen.PAGE_NAME);
                  },
                ),
                Text("Home"),
                SizedBox()
              ],
            ),
            verticalDivider(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 128,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: NetworkImage(
                      "https://psd.zone/wp-content/uploads/2020/09/Travel-Agency-Advertisement-Flyer-PSD.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            verticalDivider(),
            Container(
              color: Colors.white,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Plan your trip with Trippit",
                    style: TextStyle(color: accent_color, fontSize: 18),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 218,
                                  height: 128,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                    child: const Text(
                                  "Plan with existing group",
                                  style: TextStyle(
                                      color: accent_color, fontSize: 18),
                                )),
                                Container(
                                    child: const Text(
                                  "Room for trekkers",
                                  style: TextStyle(color: accent_color),
                                )),
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            verticalDivider(),
            Container(
              height: 150,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: suggestion_bg,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Suggestion",
                        style: TextStyle(color: accent_color, fontSize: 18),
                      ),
                      Text(
                        "See All",
                        style: TextStyle(color: accent_color, fontSize: 14),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      rideDetails_3(getRideList()[2]),
                      rideDetails_3(getRideList()[2]),
                      rideDetails_3(getRideList()[2]),
                      rideDetails_3(getRideList()[2]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
