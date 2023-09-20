import 'package:flutter/material.dart';
import 'package:tripzie/ui/main/bottom_navbar_screen.dart';

import '../../../utils/tab_view.dart';
import '../../../utils/ui_utils.dart';
import 'models.dart';

class RideScreen extends TripzieBottomNavBarScreen {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<RideScreen> {
  @override
  Widget build(BuildContext context) {
    return TrippitTabView((selectedTab) {}, [
      TrippitTabDetails(
        'Current Rides',
        _getRideDetails(),
      ),
      TrippitTabDetails(
        'My rides',
        _getRideDetails(),
      )
    ]);
  }

  Widget _getRideDetails({Widget? bottomWidget: null}) {
    var rideList = getRideList();
    return Stack(
      children: [
        ListView.builder(
            itemCount: rideList.length + 10,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var item = rideList[index % rideList.length];
              return rideDetails(item);
            }),
      ],
    );
  }
}
