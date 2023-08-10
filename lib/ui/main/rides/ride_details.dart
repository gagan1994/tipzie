import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tripzie/api/ride.dart';
import 'package:tripzie/utils/trppit_color.dart';
import 'package:tripzie/utils/ui_utils.dart';

import '../../../utils.dart';
import '../../../utils/trippit_assets.dart';
import '../../user_avatar.dart';

class RideDetailsScreen extends StatefulWidget {
  static const PAGE_NAME = "/ride_details_screen";
  final Ride rideItem;
  const RideDetailsScreen(this.rideItem, {Key? key}) : super(key: key);

  @override
  State<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends State<RideDetailsScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0)).then((_) {
      showBottomSheet();
    });
    super.initState();
  }

  var currentSelectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          print("back build");
          Navigator.pop(context);
          return false;
        },
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              "https://www.timeoutdubai.com/cloud/timeoutdubai/2022/11/15/time-out-market-nye-2.png"),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                    bottom: 50,
                    left: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.rideItem.name!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              ic_location_blue,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'details',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            SvgPicture.asset(
                              ic_rating,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "5",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            print("back showModalBottomSheet");
            Navigator.pop(context);
            Navigator.pop(context);
            return false;
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                    ),
                    color: Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height * .6,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                            'The results of the world’s top 50 bucket list destinations include some of the most beautiful places on earth. White sandy beaches are still a must-visit for many, ... read more'),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Time",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              '${dateFormat2(widget.rideItem.startDate!, widget.rideItem.endDate!)}',
                              style: TextStyle(color: notif_selected_bg_color),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 100,
                          child: getDatePickerSingleLine(
                              widget.rideItem.startDate!,
                              widget.rideItem.endDate!),
                        ),
                        if (widget.rideItem.selectedUsers!.isNotEmpty)
                          Text("Riders"),
                        verticalDivider(),
                        Expanded(
                            child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.zero,
                                itemCount:
                                    widget.rideItem.selectedUsers!.length,
                                itemBuilder: (context, index) {
                                  var user =
                                      widget.rideItem.selectedUsers![index];

                                  return GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Column(
                                        children: [
                                          Container(
                                            child: UserAvatar(),
                                            width: 30,
                                            height: 30,
                                          ),
                                          horizontalDivider(),
                                          Text(
                                            "${user.firstName}",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
