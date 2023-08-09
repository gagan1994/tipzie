import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tripzie/api/api_wrapper.dart';
import 'package:tripzie/api/user_data.dart';
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
  Map<String, String> selectedUsers = new HashMap();

  String? name;
  bool isSelectedUser(UserProfile user) {
    return selectedUsers.keys.contains(user.userId);
  }

  void toggleUser(UserProfile user) {
    if (isSelectedUser(user)) {
      selectedUsers.remove(user.userId);
    } else {
      selectedUsers[user.userId!] = user.firstName!;
    }
  }

  void removeUser(k) {
    selectedUsers.remove(k);
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

  List<UserProfile> originalList = [];
  List<UserProfile> userList = [];

  bool isNameEmpty = false;
  bool isSourceOrDestinationEmpty = false;
  bool isStartDateEndDateEmpty = false;
  bool isSelectedUsersEmpty = false;

  var isInProgress = false;
  @override
  void initState() {
    fetchProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Card(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
                  color: Colors.white,
                  child: Row(
                    children: [
                      const Expanded(
                          child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Create New Ride",
                        ),
                      )),
                      GestureDetector(
                        child: const Icon(
                          Icons.clear,
                          color: accent_color,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
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
                            decoration: BoxDecoration(
                              color: edit_text_bg_color,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              border: (isNameEmpty)
                                  ? Border.all(
                                      width: 0.5,
                                      color: Colors.red,
                                      style: BorderStyle.solid,
                                    )
                                  : null,
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: isNameEmpty
                                    ? "Please enter valid ride name"
                                    : 'Enter Ride Name',
                                labelStyle: TextStyle(
                                    color: isNameEmpty ? Colors.red : null),
                                border: InputBorder.none,
                              ),
                              onChanged: (text) {
                                newRideObject.name = text;
                              },
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          verticalDivider(),
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                border: Border.all(
                                  width: 0.5,
                                  color: isSourceOrDestinationEmpty
                                      ? Colors.red
                                      : Colors.black,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Select Source and Destination",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: isSourceOrDestinationEmpty
                                            ? Colors.red
                                            : null),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select Start and End Date",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: isStartDateEndDateEmpty
                                        ? Colors.red
                                        : null),
                              ),
                              verticalDivider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  datePicker(
                                      "Start Date", newRideObject.startDate,
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
                                  }, true),
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
                          ),
                          const Text(
                            "Select Riders",
                            style: TextStyle(fontSize: 12),
                          ),
                          TrippitSearchInput((textChanged) {
                            setState(() {
                              userList.clear();
                              if (textChanged.isEmpty) {
                                userList.addAll(originalList);
                              } else {
                                for (var item in originalList) {
                                  if (item
                                      .toString()
                                      .toLowerCase()
                                      .contains(textChanged.toLowerCase())) {
                                    userList.add(item);
                                  }
                                }
                              }
                            });
                          }),
                          if (newRideObject.selectedUsers.isNotEmpty)
                            Container(
                              child: getSelectedList(),
                            ),
                          if (userList.length == 0)
                            Container(
                              child: const Text("User list empty"),
                              alignment: Alignment.center,
                            ),
                          if (userList.length != 0)
                            Container(
                              height: 200,
                              child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return Divider();
                                  },
                                  padding: EdgeInsets.zero,
                                  itemCount: userList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          newRideObject
                                              .toggleUser(userList[index]);
                                        });
                                      },
                                      child: Row(
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
                                                  "${userList[index].firstName} ,"
                                                  " ${userList[index].surName}",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              alignment: Alignment.topCenter,
                                              child: Icon(
                                                newRideObject.isSelectedUser(
                                                        userList[index])
                                                    ? Icons.check_box
                                                    : Icons
                                                        .check_box_outline_blank,
                                                size: 15,
                                              ))
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          SizedBox(
                            height: 250,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          showProgress(isInProgress)
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: TripzieButton(
        button_text: "Create Ride",
        onPressed: () async {
          isNameEmpty =
              newRideObject.name == null || newRideObject.name!.isEmpty;
          isSourceOrDestinationEmpty =
              newRideObject.source == null || newRideObject.destination == null;
          isStartDateEndDateEmpty =
              newRideObject.startDate == null || newRideObject.endDate == null;
          isSelectedUsersEmpty = newRideObject.selectedUsers.isEmpty;
          if (isNameEmpty ||
              isSourceOrDestinationEmpty ||
              isStartDateEndDateEmpty) {
            setState(() {});
            showSnackBar(context, "Please Resolve the Errors");
            return;
          }
          setState(() {
            isInProgress = true;
          });
          var res = await createRides(newRideObject);
          setState(() {
            isInProgress = false;
          });
          if (res) {
            showSnackBar(context, "Ride Created Successfully");
            Navigator.pop(context);
          } else {
            showSnackBar(context,
                "Unable to create Rides at this movement Please try again later");
          }
        },
      ),
    );
  }

  datePicker(String placeholder, DateTime? date,
      Function(DateTime selectedStartDate) callback,
      [isEndDate = false]) {
    return GestureDetector(
      onTap: () async {
        var tempInitialDate = DateTime.now();
        var firstDate = DateTime.now();
        if (isEndDate) {
          if (newRideObject.startDate == null) {
            showSnackBar(context, "Please select start date first");
            return;
          }
          tempInitialDate = newRideObject.startDate!;
          firstDate = newRideObject.startDate!;
        }
        var selectedDate = await showDatePicker(
            context: context,
            initialDate: tempInitialDate,
            firstDate: firstDate,
            lastDate: DateTime(2101));
        print("selected Date: $selectedDate");
        if (selectedDate == null) return;
        var time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(
              hour: tempInitialDate.hour, minute: tempInitialDate.minute),
        );
        if (time != null) {
          selectedDate = DateTime(selectedDate.year, selectedDate.month,
              selectedDate.day, time.hour, time.minute);
          callback(selectedDate);
        }
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

  void fetchProfileData() async {
    setState(() {
      isInProgress = true;
    });
    var data = await fetchProfiles();
    setState(() {
      originalList.clear();
      originalList.addAll(data);
      userList.clear();
      userList.addAll(data);
    });
    setState(() {
      isInProgress = false;
    });
    print("data: $data");
  }

  void sortItems() {
    userList.sort((a, b) => a.firstName!.compareTo(b.firstName!));
    for (int i = 0; i < userList.length; i++) {
      var item = userList[i];
      if (newRideObject.isSelectedUser(item)) {
        userList.remove(i);
        userList.insert(0, item);
      }
    }
  }

  getSelectedList() {
    return Wrap(
        children: newRideObject.selectedUsers.keys
            .map((k) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: otp_background_color,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: newRideObject.selectedUsers[k],
                            style: TextStyle(color: accent_color)),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                newRideObject.removeUser(k);
                              });
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: accent_color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
            .toList());
  }
}
