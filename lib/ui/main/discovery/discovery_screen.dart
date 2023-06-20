import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tripzie/ui/main/discovery/disovery_details_screen.dart';
import 'package:tripzie/utils/trippit_assets.dart';
import 'package:tripzie/utils/trppit_color.dart';
import 'package:tripzie/utils/ui_utils.dart';

import '../bottom_navbar_screen.dart';
import 'models.dart';

class DiscoveryScreen extends TripzieBottomNavBarScreen {
  static const PAGE_NAME = "/discovery_screen";

  const DiscoveryScreen({Key? key}) : super(key: key);

  @override
  State<DiscoveryScreen> createState() => DiscoveryScreenState();
}

class DiscoveryScreenState extends State<DiscoveryScreen> {
  int selectedIndex = -1;
  List<String> litOfFilter1 = [
    "All",
    "India",
    "UAE",
    "America",
    "Europe",
    "Other"
  ];
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
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: Container(
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
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              child: getFilter_1Widget(
                  litOfFilter1,
                  (index) => {
                        setState(() {
                          selectedIndex = index;
                        })
                      },
                  selectedIndex),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: getDiscoveryItems().length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  var item = getDiscoveryItems()[index];
                  return GestureDetector(
                    onTap: () {
                      onItemClicked(item);
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            image: DecorationImage(
                                image: NetworkImage(item.imageUri),
                                fit: BoxFit.cover),
                          ),
                          height: 200,
                          width: 158,
                        ),
                        Positioned(
                          bottom: 15,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.destinationName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(ic_location_orange),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    item.destinationLocation,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          left: 15,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Recommended Places",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            ListView.builder(
                itemCount: getDiscoveryItems().length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var item = getDiscoveryItems()[index];
                  return GestureDetector(
                    onTap: () {
                      onItemClicked(item);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            height: 71,
                            width: 71,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: NetworkImage(item.imageUri),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(ic_location_blue),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    item.destinationLocation,
                                    style: const TextStyle(
                                      color: notif_selected_bg_color,
                                      fontSize: 8,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                item.destinationName,
                                style: TextStyle(
                                    fontSize: 19, color: accent_color),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(ic_rating),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "${item.rating}",
                                    style: const TextStyle(
                                        fontSize: 8, color: text_light_2),
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  void onItemClicked(DiscoveryListItem item) {
    Navigator.pushNamed(context, DiscoveryDetailsScreen.PAGE_NAME,
        arguments: item);
  }
}
