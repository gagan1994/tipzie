import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tripzie/api/api_wrapper.dart';
import 'package:tripzie/api/ride.dart';
import 'package:tripzie/auth/authentication.dart';
import 'package:tripzie/ui/main/bottom_navbar_screen.dart';
import 'package:tripzie/ui/main/rides/create_new_ride_screen.dart';
import 'package:tripzie/utils.dart';

import '../../../db/users.dart';
import '../../../utils/trippit_assets.dart';
import '../../../utils/trppit_color.dart';
import '../../../utils/ui_utils.dart';
import '../../user_avatar.dart';
import '../live_ride.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends TripzieBottomNavBarScreen {
  static const PAGE_NAME = "/home_screen";
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isInProgress = false;

  List<Ride> allRides = [];
  List<Ride> myRides = [];
  List<Ride> suggestionRides = [];
  List<Ride> completedRides = [];
  List<Ride> onGoingRides = [];
  double left = 0;
  double leftSuggestion = 0;
  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accent_color_light_bg,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 50),
            child: RefreshIndicator(
              backgroundColor: accent_color,
              color: Colors.white,
              triggerMode: RefreshIndicatorTriggerMode.onEdge,
              onRefresh: () async {
                print("refresh");
                await loadData();
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  color: accent_color_light_bg,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      verticalDivider(),
                      if (onGoingRides.isNotEmpty)
                        ListView.builder(
                            padding: EdgeInsets.only(top: 1),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              var item =
                                  onGoingRides[index % onGoingRides.length];
                              return LiveRide(item, (isRefresh) {
                                if (isRefresh) {
                                  print("is refresh $isRefresh");
                                  loadData();
                                }
                              });
                            }),
                      verticalDivider(),
                      if (myRides.length != 0)
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "My Trips",
                                style: TextStyle(
                                    color: accent_color, fontSize: 18),
                              ),
                              verticalDivider(),
                              Container(
                                  height: 100,
                                  child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: myRides.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var ride = myRides[index];
                                        left = -10;
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                CreateNewRideScreen.PAGE_NAME,
                                                arguments: ride);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Card(
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                height: 150,
                                                margin: EdgeInsets.all(10),
                                                child: Stack(
                                                  children: [
                                                    Positioned(
                                                      left: 0,
                                                      top: 0,
                                                      child: Text(
                                                        ride.name,
                                                        style: const TextStyle(
                                                            color: accent_color,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 0,
                                                      top: 0,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Text(
                                                          dateFormat(
                                                              ride.startDate!),
                                                          style: const TextStyle(
                                                              color:
                                                                  accent_color,
                                                              fontSize: 8),
                                                        ),
                                                      ),
                                                    ),
                                                    for (var item
                                                        in ride.selectedUsers!)
                                                      Positioned(
                                                        bottom: 0,
                                                        left: left += 10,
                                                        child: UserAvatar(
                                                          imageUrl:
                                                              item.imageUri,
                                                          radius: 25,
                                                        ),
                                                      ),
                                                    Positioned(
                                                      child:
                                                          checkAndAddRightEndButton(
                                                              ride),
                                                      bottom: 0,
                                                      right: 0,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }))
                            ],
                          ),
                        ),
                      if (myRides.length != 0) verticalDivider(),
                      if (myRides.length == 0)
                        if (suggestionRides.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: const BoxDecoration(
                                color: suggestion_bg,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Suggestion",
                                      style: TextStyle(
                                          color: accent_color, fontSize: 18),
                                    ),
                                    if (suggestionRides.length > 4)
                                      const Text(
                                        "See All",
                                        style: TextStyle(
                                            color: accent_color, fontSize: 14),
                                      )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    alignment: Alignment.centerLeft,
                                    height: 200,
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: suggestionRides.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var ride = suggestionRides[index];
                                          leftSuggestion = 10;
                                          return getSuggestionRide(ride);
                                        })),
                              ],
                            ),
                          ),
                      verticalDivider(),
                      if (completedRides.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: const BoxDecoration(
                              color: suggestion_bg,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Completed rides",
                                    style: TextStyle(
                                        color: accent_color, fontSize: 18),
                                  ),
                                  if (completedRides.length > 4)
                                    const Text(
                                      "See All",
                                      style: TextStyle(
                                          color: accent_color, fontSize: 14),
                                    )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  height: 200,
                                  child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: completedRides.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var ride = completedRides[index];
                                        leftSuggestion = 10;
                                        return getSuggestionRide(ride);
                                      })),
                            ],
                          ),
                        ),
                      SizedBox(
                        height: 250,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          titleBar(context, 'Home',
              rightItem: GestureDetector(
                child: SvgPicture.asset(
                  ic_hamburger_menu,
                  height: 15,
                  width: 15,
                ),
                onTap: () {
                  Navigator.pushNamed(context, ProfileScreen.PAGE_NAME);
                },
              ),
              top: 1.0)
        ],
      ),
    );
  }

  Future<void> fetchRideAndUpdateUi() async {
    setState(() {
      isInProgress = true;
    });
    allRides.clear();
    suggestionRides.clear();
    onGoingRides.clear();
    completedRides.clear();
    myRides.clear();

    allRides = await fetchRides();
    allRides.sort((a, b) {
      return b.startDate!.compareTo(a.startDate!);
    });
    for (var item in allRides) {
      if (item.rideActive()) {
        onGoingRides.add(item);
        continue;
      }
      if (item.createdBy == Authentication.loggedInUser!.userId) {
        myRides.add(item);
      } else {
        bool isMyRide = false;
        for (var user in item.selectedUsers!) {
          print(
              "user id: ${user.userId} current userId: ${Authentication.loggedInUser!.userId} ${item.name}");
          if (user.userId == Authentication.loggedInUser!.userId) {
            isMyRide = true;
          }
        }
        if (isMyRide) {
          myRides.add(item);
        } else {
          if (item.isCompleted()) {
            completedRides.add(item);
          } else {
            suggestionRides.add(item);
          }
        }
      }
    }
    setState(() {
      isInProgress = false;
    });
  }

  fetchUsersAndStore() async {
    allUsers = await fetchProfiles();
  }

  loadData() async {
    print("load data home screen");
    await fetchCurrentUserProfile();
    await fetchUsersAndStore();
    await fetchRideAndUpdateUi();
  }

  checkAndAddRightEndButton(Ride ride) {
    if (ride.isCreatedByCurrentUser()) {
      if (ride.isCompleted()) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: Colors.blue.shade100,
          ),
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
          child: Text(
            "Completed",
            style: TextStyle(color: accent_color, fontSize: 8),
          ),
        );
      }
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: accent_color,
        ),
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Start",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            Icon(
              Icons.navigate_next_outlined,
              color: Colors.white,
              size: 12,
            ),
          ],
        ),
      );
    }
    return Container(
      alignment: Alignment.bottomRight,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: accent_color,
      ),
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "See Details",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget getSuggestionRide(Ride ride) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, CreateNewRideScreen.PAGE_NAME,
            arguments: ride);
      },
      child: Container(
        width: 160,
        padding: EdgeInsets.only(left: 2.5, right: 2.5),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 0,
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                verticalDivider(),
                Text(ride.name),
                verticalDivider(),
                Container(
                  height: 30,
                  width: 100,
                  child: Stack(
                    children: [
                      for (var item in ride.selectedUsers!)
                        Positioned(
                          left: leftSuggestion += 10,
                          child: UserAvatar(
                            imageUrl: item.imageUri,
                            radius: 25,
                          ),
                        ),
                    ],
                  ),
                ),
                verticalDivider(),
                Text(
                  "From ${ride.source!.name} To ${ride.destination!.name} \nOn ${dateFormat(ride.startDate!)}",
                  style: TextStyle(fontSize: 10),
                ),
                verticalDivider(),
                Spacer(),
                Container(
                  alignment: Alignment.bottomRight,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: accent_color,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        ride.isCompleted() ? "See Details" : "Join",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                verticalDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
