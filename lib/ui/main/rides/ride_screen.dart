import 'package:flutter/material.dart';
import 'package:tripzie/ui/main/bottom_navbar_screen.dart';
import 'package:tripzie/widgets/tripzie_button.dart';

import '../../../utils/tab_view.dart';
import '../../../utils/ui_utils.dart';
import 'create_new_ride_screen.dart';
import 'models.dart';

class RideScreen extends TripzieBottomNavBarScreen {
  RideScreen();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<RideScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            height: 50,
            alignment: Alignment.center,
            child: const Text("Rides"),
          ),
          Expanded(
            child: TrippitTabView((selectedTab) {}, [
              TrippitTabDetails(
                'Current Rides',
                _getRideDetails(
                    bottomWidget: Positioned(
                  bottom: 60,
                  child: TripzieButton(
                    button_text: "Create New Ride",
                    onPressed: _createNewRide,
                  ),
                )),
              ),
              TrippitTabDetails(
                'My rides',
                _getRideDetails(),
              )
            ]),
          )
        ],
      ),
    );
  }

  void _createNewRide() async {
    print("pushNamed CreateNewRideScreen.PAGE_NAME");
    Navigator.pushNamed(context, CreateNewRideScreen.PAGE_NAME);
  }

  Widget _getRideDetails({Widget? bottomWidget: null}) {
    var rideList = getRideList();
    return Stack(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: rideList.length + 10,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                var item = rideList[index % rideList.length];
                return rideDetails(item);
              }),
        ),
        if (bottomWidget != null) bottomWidget,
      ],
    );
  }
}
