import 'package:flutter/material.dart';
import 'package:tripzie/ui/main/map/select_places_on_map.dart';
import 'package:tripzie/utils/trppit_color.dart';
import 'package:tripzie/utils/ui_utils.dart';

import '../map/tripit_map_ui.dart';

class NewRideObject {
  Places? source;
  Places? destination;
}

class CreateNewRideScreen extends StatefulWidget {
  static const PAGE_NAME = "/create_new_screen";
  const CreateNewRideScreen({Key? key}) : super(key: key);

  @override
  State<CreateNewRideScreen> createState() => _CreateNewRideScreenState();
}

class _CreateNewRideScreenState extends State<CreateNewRideScreen> {
  NewRideObject newRideObject = NewRideObject();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        color: Colors.white,
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
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalDivider(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        padding: EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: edit_text_bg_color,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Enter Ride Name',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      verticalDivider(),
                      Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            border: Border.all(
                              width: 0.5,
                              color: Colors.black,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select Source and Destination",
                                style: TextStyle(fontSize: 12),
                              ),
                              verticalDivider(),
                              getSourceDestinationUI(
                                null,
                                MarkMapUI("Enter Source",
                                    place: newRideObject.source),
                                MarkMapUI("Enter Source",
                                    place: newRideObject.destination),
                                (selected) async {
                                  await Navigator.pushNamed(
                                      context, TripzieMarkOnMap.PAGE_NAME,
                                      arguments: newRideObject);
                                  setState(() {});
                                },
                                10.00,
                                Colors.transparent,
                              ),
                            ],
                          )),
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
