import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/trppit_color.dart';
import '../../utils/ui_utils.dart';
import 'map/current_ride_screen.dart';

class LiveRide extends StatefulWidget {
  LiveRide({Key? key}) : super(key: key);

  @override
  State<LiveRide> createState() => _LiveRideState();
}

class _LiveRideState extends State<LiveRide> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _goToCurrentRide();
      },
      child: Card(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Current ride",
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Riding with Punith and 10 others",
                    style: TextStyle(fontSize: 10, color: version_color),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(Icons.navigation),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "BENGALURU",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "MYSURU",
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      _getLiveRideTiles("146 Kms"),
                      SizedBox(
                        width: 20,
                      ),
                      _getLiveRideTiles("2/5 Riders"),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _goToCurrentRide() async {
    var permissionStatus = await Permission.microphone.request();
    if (permissionStatus != PermissionStatus.granted) {
      showSnackBar(context, "Please provide permission");
      return;
    }
    permissionStatus = await Permission.location.request();
    if (permissionStatus != PermissionStatus.granted) {
      showSnackBar(context, "Please provide permission");
      return;
    }
    Navigator.pushNamed(context, CurrentRideScreen.PAGE_NAME);
  }

  _getLiveRideTiles(String text) {
    return Container(
      padding: EdgeInsets.all(7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: accent_color),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: Colors.white),
      ),
    );
  }
}
