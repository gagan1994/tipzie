import 'package:flutter/material.dart';
import 'package:tripzie/utils/map_utils.dart';
import 'package:tripzie/utils/trppit_color.dart';

import '../../../utils/ui_utils.dart';
import 'models.dart';

class CreateNewRideScreen extends StatefulWidget {
  static const PAGE_NAME = "/create_new_screen";
  const CreateNewRideScreen({Key? key}) : super(key: key);

  @override
  State<CreateNewRideScreen> createState() => _CreateNewRideScreenState();
}

class _CreateNewRideScreenState extends State<CreateNewRideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: edit_text_bg_color,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
              color: Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                    child: const Icon(
                      Icons.clear,
                      color: accent_color,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                      child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Create New Ride",
                    ),
                  )),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          decoration: const BoxDecoration(
                            color: edit_text_bg_color,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: edit_text_color,
                              ),
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
                              const Text(
                                "|",
                                style: TextStyle(
                                    fontSize: 24, color: edit_text_color),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    MapUtils.checkPlaces(context, "benglore");
                                  },
                                  child: const Icon(
                                    Icons.location_on_rounded,
                                    color: accent_color,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 20,
                        color: Colors.white,
                      ),
                      rideDetails_2(getRideList()[2]),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        color: Colors.white,
                        child: Container(
                          height: 1,
                          color: divider_color,
                        ),
                      ),
                      rideDetails_2(getRideList()[2]),
                      Container(
                        height: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*
 Expanded(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ways to plan with Trippit",
                      style: TextStyle(color: accent_color, fontSize: 18),
                    ),
                    ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color: Colors.blue,
                            child: Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 50,
                                  child: Image.network(
                                      "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                )
                              ],
                            ),
                          );
                        })
                  ],
                ),
              ),
            )
* */
