import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tripzie/api/api_wrapper.dart';
import 'package:tripzie/api/ride.dart';
import 'package:tripzie/ui/main/bottom_navbar_screen.dart';
import 'package:tripzie/ui/main/rides/ride_details.dart';
import 'package:tripzie/ui/test_ui.dart';
import 'package:tripzie/utils.dart';

import '../../../db/users.dart';
import '../../../utils/trippit_assets.dart';
import '../../../utils/trppit_color.dart';
import '../../../utils/ui_utils.dart';
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
  List<Ride> currentRides = [];

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
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      verticalDivider(),
                      if (currentRides.isNotEmpty)
                        ListView.builder(
                            padding: EdgeInsets.only(top: 1),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              var item =
                                  currentRides[index % currentRides.length];
                              return LiveRide(item);
                            }),
                      verticalDivider(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, TestUi.PAGE_NAME);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 128,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://psd.zone/wp-content/uploads/2020/09/Travel-Agency-Advertisement-Flyer-PSD.jpg"),
                              fit: BoxFit.cover,
                            ),
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
                            const Text(
                              "Plan your trip with Trippit",
                              style:
                                  TextStyle(color: accent_color, fontSize: 18),
                            ),
                            verticalDivider(),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: allRides.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var ride = allRides[index];

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            RideDetailsScreen.PAGE_NAME,
                                            arguments: ride);
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 218,
                                              height: 128,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Container(
                                                child: Text(
                                              '${ride.name}',
                                              style: const TextStyle(
                                                  color: accent_color,
                                                  fontSize: 18),
                                            )),
                                            Container(
                                                child: Text(
                                              "${dateFormat(ride.startDate!)}",
                                              style: TextStyle(
                                                  color: accent_color),
                                            )),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                      verticalDivider(),
                      if (allRides.isNotEmpty)
                        Container(
                          height: 150,
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
                                  const Text(
                                    "Suggestion",
                                    style: TextStyle(
                                        color: accent_color, fontSize: 18),
                                  ),
                                  if (allRides.length > 4)
                                    const Text(
                                      "See All",
                                      style: TextStyle(
                                          color: accent_color, fontSize: 14),
                                    )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  if (allRides.length > 1)
                                    rideDetails_3(allRides[0]),
                                  if (allRides.length > 2)
                                    rideDetails_3(allRides[1]),
                                  if (allRides.length > 3)
                                    rideDetails_3(allRides[2]),
                                  if (allRides.length > 4)
                                    rideDetails_3(allRides[3]),
                                ],
                              ),
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
    allRides = await fetchRides(context);
    allRides.sort((a, b) {
      return b.startDate!.compareTo(a.startDate!);
    });
    currentRides.sort((a, b) {
      return b.startDate!.compareTo(a.startDate!);
    });
    currentRides = await fetchOnGoingRides(context);

    setState(() {
      isInProgress = false;
    });
  }

  fetchUsersAndStore() async {
    allUsers = await fetchProfiles();
  }

  loadData() async {
    print("load data home screen");
    await fetchUsersAndStore();
    await fetchRideAndUpdateUi();
  }
}
