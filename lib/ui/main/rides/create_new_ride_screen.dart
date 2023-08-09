import 'package:flutter/material.dart';
import 'package:tripzie/ui/main/map/select_places_on_map.dart';
import 'package:tripzie/utils/trppit_color.dart';
import 'package:tripzie/utils/ui_utils.dart';

import '../../../utils/ui/trippit_search_input.dart';
import '../../../widgets/tripzie_button.dart';
import '../../user_avatar.dart';
import '../map/tripit_map_ui.dart';

class NewRideObject {
  Places? source;
  Places? destination;
  DateTime? startDate;
  DateTime? endDate;

  bool isSelectedUser(int index) {
    return index % 2 == 0;
  }
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
                      verticalDivider(),
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Start and End Date",
                            style: TextStyle(fontSize: 12),
                          ),
                          verticalDivider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              datePicker("Start Date", newRideObject.startDate,
                                  (selectedDate) {
                                setState(() {
                                  newRideObject.startDate = selectedDate;
                                });
                              }),
                              datePicker("End Date", newRideObject.endDate,
                                  (selectedDate) {
                                setState(() {
                                  newRideObject.endDate = selectedDate;
                                });
                              }),
                            ],
                          ),
                          verticalDivider(),
                          if (newRideObject.startDate != null &&
                              newRideObject.endDate != null)
                            Container(
                              height: 80,
                              margin: EdgeInsets.only(bottom: 10),
                              child: getDatePickerSingleLine(
                                  newRideObject.startDate!,
                                  newRideObject.endDate!),
                            ),
                        ],
                      )),
                      Text(
                        "Select Rders",
                        style: TextStyle(fontSize: 12),
                      ),
                      TrippitSearchInput((textChanged) {
                        setState(() {});
                      }),
                      Container(
                        height: 200,
                        child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                            padding: EdgeInsets.zero,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return Row(
                                children: [
                                  Container(
                                    child: UserAvatar(),
                                    width: 30,
                                    height: 30,
                                  ),
                                  horizontalDivider(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Name $index",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.topCenter,
                                      child: Icon(
                                        newRideObject.isSelectedUser(index)
                                            ? Icons.check_box
                                            : Icons.check_box_outline_blank,
                                        size: 15,
                                      ))
                                ],
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TripzieButton(
        button_text: "Create Ride",
        onPressed: () {},
      ),
    );
  }

  datePicker(
    String placeholder,
    DateTime? date,
    Function(DateTime selectedStartDate) callback,
  ) {
    return GestureDetector(
      onTap: () async {
        var selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now().add(Duration(days: 1)),
            firstDate: DateTime.now().add(Duration(days: 1)),
            lastDate: DateTime(2101));
        print("selected Date: $selectedDate");
        if (selectedDate != null) callback(selectedDate);
      },
      child: Container(
        height: 40,
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.4,
        padding: EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: edit_text_bg_color,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(
          date == null ? placeholder : getDateText(date!),
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  getDateText(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
