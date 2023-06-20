import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:tripzie/ui/main/discovery/models.dart';
import 'package:tripzie/utils/trppit_color.dart';
import 'package:tripzie/utils/ui_utils.dart';

import '../../../utils/trippit_assets.dart';

class DiscoveryDetailsScreen extends StatefulWidget {
  static const PAGE_NAME = "/discovery_details_screen";
  final DiscoveryListItem discoveryItem;
  const DiscoveryDetailsScreen(this.discoveryItem, {Key? key})
      : super(key: key);

  @override
  State<DiscoveryDetailsScreen> createState() => _DiscoveryDetailsScreenState();
}

class _DiscoveryDetailsScreenState extends State<DiscoveryDetailsScreen> {
  List<String> listOfFilter1 = ["Overview", "Promo & Discount", "review"];

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
                  height: MediaQuery.of(context).size.width * .75,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.discoveryItem.imageUri),
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
                          widget.discoveryItem.destinationName,
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
                              widget.discoveryItem.destinationLocation,
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
                              "${widget.discoveryItem.rating}",
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
                      children: [
                        SizedBox(
                          height: 40,
                          child: getFilter_1Widget(
                              listOfFilter1,
                              (index) => {
                                    setState(() {
                                      currentSelectedIndex = index;
                                    })
                                  },
                              currentSelectedIndex),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                            'The results of the world’s top 50 bucket list destinations include some of the most beautiful places on earth. White sandy beaches are still a must-visit for many, ... read more'),
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Availability",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              "MON - SAT • 10:00 - 17:00",
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
                              DateTime.now(),
                              DateTime.now().add(Duration(days: 3)),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: edit_text_bg_color,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 50,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(
                                    color: edit_text_color,
                                    width: .5,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("2"),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: edit_text_color,
                                    )
                                  ],
                                ),
                              ),
                              Text("Adult"),
                              Container(
                                width: 50,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(
                                    color: edit_text_color,
                                    width: .5,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("2"),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: edit_text_color,
                                    )
                                  ],
                                ),
                              ),
                              Text("Children under 2")
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.4),
                        Colors.white.withOpacity(0.7),
                        Colors.white.withOpacity(0.8),
                        Colors.white.withOpacity(1),
                        Colors.white,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: notif_selected_bg_color,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Book Now",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget getDatePickerSingleLine(DateTime start, DateTime end) {
    var noOfDays = end.difference(start).inDays + 6;
    print("Start date $start");
    print("End date $end");
    print("diff: $noOfDays");
    var listStartDate = start.subtract(Duration(days: 2));

    return ListView.builder(
        itemCount: noOfDays,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          DateTime indexDate = listStartDate.add(Duration(days: index));
          print("indexDate: $indexDate");
          var isSelectedDate = isSameDay(start, indexDate);
          if (!isSelectedDate) {
            isSelectedDate = isSameDay(end, indexDate);
            print("isSelectedDate: $isSelectedDate");
          }
          bool isDateInBtw = false;
          if (start.isBefore(indexDate) && end.isAfter(indexDate)) {
            isDateInBtw = true;
          }
          return Container(
            color: isDateInBtw || isSelectedDate
                ? selected_date_color
                : Colors.white,
            child: Container(
              width: 50,
              alignment: Alignment.center,
              height: 30,
              decoration: !isSelectedDate
                  ? BoxDecoration()
                  : BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      color: notif_selected_bg_color,
                    ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${indexDate.day}",
                    style: TextStyle(
                        color: !isSelectedDate ? accent_color : Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${DateFormat('EE').format(indexDate)}",
                    style: TextStyle(
                        color: !isSelectedDate ? accent_color : Colors.white),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: CircleAvatar(
                          radius: 3, backgroundColor: Colors.white))
                ],
              ),
            ),
          );
        });
  }

  bool isSameDay(DateTime d1, DateTime d2) {
    return d1.day == d2.day && d1.month == d2.month && d1.year == d2.year;
  }
}
