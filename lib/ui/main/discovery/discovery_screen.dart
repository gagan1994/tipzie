import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tripzie/ui/main/discovery/disovery_details_screen.dart';
import 'package:tripzie/utils/trippit_assets.dart';
import 'package:tripzie/utils/trppit_color.dart';
import 'package:tripzie/utils/ui_utils.dart';

import '../bottom_navbar_screen.dart';
import '../profile/profile_screen.dart';
import 'models.dart';

class DiscoveryScreen extends TripzieBottomNavBarScreen {
  static const PAGE_NAME = "/discovery_screen";

  DiscoveryScreen({Key? key}) : super(key: key);

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
      padding: EdgeInsets.only(left: 10, top: 30, right: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    print("open drawer");
                    Navigator.pushNamed(context, ProfileScreen.PAGE_NAME);
                    print("open drawer end");
                  },
                  child: SvgPicture.asset(
                    ic_hamburger_menu,
                    height: 15,
                    width: 15,
                  ),
                ),
                myAppBarIcon(),
              ],
            ),
            const SizedBox(
              height: 10,
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

  Widget myAppBarIcon() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(shape: BoxShape.circle, color: notif_bg_color),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Icon(
              Icons.notifications_none,
              color: notif_selected_bg_color,
              size: 25,
            ),
          ),
          Container(
            width: 20,
            height: 20,
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(top: 3, left: 6),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: notif_selected_bg_color,
                  border: Border.all(color: Colors.white, width: 1)),
            ),
          ),
        ],
      ),
    );
  }
}
