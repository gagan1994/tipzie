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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      height: 20,
                    ),
                    Row(
                      children: [
                        _getLiveRideTiles("146 Kms"),
                        SizedBox(
                          width: 20,
                        ),
                        _getLiveRideTiles("2/5 Riders"),
                      ],
                    )
                  ],
                ),
              ),
              getNavigationIcons(["Bgl", "Mys"])
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
          color: Colors.white),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: accent_color),
      ),
    );
  }

  getNavigationIcons(List<String> list) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(text: "Sun\n", style: TextStyle(fontSize: 8)),
              TextSpan(
                  text: '25 Jun',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
            ],
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getItems(list),
        )
      ],
    );
  }

  getItems(List<String> list) {
    List<Widget> ret = [];
    for (int i = 0; i < list.length; i++) {
      var borderRadius = null;

      if (i == 0) {
        borderRadius = BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10));
      }
      if (i == list.length - 1) {
        borderRadius = BorderRadius.only(
            bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10));
      }
      var gradirentColor = [
        i % 2 == 0
            ? accent_color.withOpacity(.09)
            : accent_color.withOpacity(0.9),
        i % 2 == 0
            ? accent_color.withOpacity(.9)
            : accent_color.withOpacity(.09),
      ];
      ret.add(Row(
        children: [
          Container(
            height: 20,
            width: 10,
            decoration: BoxDecoration(
              color: accent_color,
              borderRadius: borderRadius,
            ),
            child: Container(
              margin: EdgeInsets.only(left: 4, right: 4, top: 9, bottom: 9),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  )),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Text(list[i]),
        ],
      ));
    }
    return ret;
  }
}
