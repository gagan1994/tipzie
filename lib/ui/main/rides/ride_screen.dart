import 'package:flutter/material.dart';
import 'package:tripzie/api/api_wrapper.dart';
import 'package:tripzie/ui/main/bottom_navbar_screen.dart';
import 'package:tripzie/utils/trppit_color.dart';

import '../../../api/ride.dart';
import '../../../auth/authentication.dart';
import '../../../utils/tab_view.dart';
import '../../../utils/ui_utils.dart';
import 'create_new_ride_screen.dart';

class RideScreen extends TripzieBottomNavBarScreen {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<RideScreen> {
  List<Ride> currentRides = [];
  List<Ride> myRidesRides = [];

  @override
  void initState() {
    fetchRidesAndUpdateUi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TrippitTabView((selectedTab) {}, [
        TrippitTabDetails(
          'Current Rides',
          currentRides.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  child: Text("Oops No Rides to show please Create new ride"))
              : _getRideDetails(currentRides),
        ),
        TrippitTabDetails(
          'My rides',
          myRidesRides.isEmpty
              ? Container(
                  alignment: Alignment.center,
                  child: Text("Oops No Rides to show please Create new ride"))
              : _getRideDetails(currentRides),
        )
      ]),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton.extended(
          label: const Text('Create Rides'), // <-- Text
          backgroundColor: accent_color,
          onPressed: () async {
            print("current user: ${Authentication.loggedInUser}");
            await Navigator.pushNamed(context, CreateNewRideScreen.PAGE_NAME);
          },
        ),
      ),
    );
  }

  Widget _getRideDetails(List<Ride> rideList) {
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

  void fetchRidesAndUpdateUi() {
    var rides = fetchRides();
  }
}
