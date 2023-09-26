import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:tripzie/api/api_wrapper.dart';
import 'package:tripzie/api/user_data.dart';
import 'package:tripzie/auth/authentication.dart';
import 'package:tripzie/db/users.dart';
import 'package:tripzie/ui/main/map/current_ride_screen.dart';
import 'package:tripzie/ui/main/map/select_places_on_map.dart';
import 'package:tripzie/utils/trppit_color.dart';
import 'package:tripzie/utils/ui_utils.dart';

import '../../../api/ride.dart';
import '../../../utils/trippit_assets.dart';
import '../../../utils/ui/trippit_search_input.dart';
import '../../../widgets/tripzie_button.dart';
import '../../user_avatar.dart';
import '../map/tripit_map_ui.dart';

class NewRideObject {
  Places? source;
  Places? destination;
  DateTime? startDate;
  DateTime? endDate;
  Map<String, UserProfile> selectedUsers = new HashMap();

  String? name;
  bool isSelectedUser(UserProfile user) {
    return selectedUsers.keys.contains(user.userId);
  }

  void toggleUser(UserProfile user) {
    if (isSelectedUser(user)) {
      selectedUsers.remove(user);
    } else {
      selectedUsers[user.userId!] = user;
    }
  }

  void removeUser(k) {
    selectedUsers.remove(k);
  }
}

class CreateNewRideScreen extends StatefulWidget {
  static const PAGE_NAME = "/create_new_screen";
  Ride? ride;
  CreateNewRideScreen(this.ride, {Key? key}) : super(key: key);

  @override
  State<CreateNewRideScreen> createState() => _CreateNewRideScreenState();
}

class _CreateNewRideScreenState extends State<CreateNewRideScreen> {
  NewRideObject newRideObject = NewRideObject();
  bool isFinished = false;
  bool isEdit = true;
  List<UserProfile> originalList = [];
  List<UserProfile> userList = [];
  TextEditingController controller = TextEditingController();
  bool isNameEmpty = false;
  bool isSourceOrDestinationEmpty = false;
  bool isStartDateEndDateEmpty = false;
  bool isSelectedUsersEmpty = false;

  var isInProgress = false;
  int tripDistance = 0;
  @override
  void initState() {
    fetchProfileData();
    if (widget.ride != null) {
      isEdit = false;
      newRideObject.startDate = widget.ride!.startDate;
      newRideObject.destination = widget.ride!.destination;
      newRideObject.source = widget.ride!.source;
      controller.text = newRideObject.name = widget.ride!.name;
      newRideObject.endDate = widget.ride!.endDate;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Stack(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).viewPadding.top + 40,
                        right: 10,
                        left: 10),
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
                            enabled: isEdit,
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: isNameEmpty
                                  ? "Please enter valid ride name"
                                  : (widget.ride != null &&
                                          widget.ride!.isEditable())
                                      ? ''
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
                                  MarkMapUI(
                                      (newRideObject.source != null &&
                                              newRideObject.source!.name !=
                                                  null &&
                                              newRideObject
                                                  .source!.name!.isNotEmpty)
                                          ? newRideObject.source!.name!
                                          : "Enter Source",
                                      place: newRideObject.source),
                                  MarkMapUI(
                                      (newRideObject.destination != null &&
                                              newRideObject.destination!.name !=
                                                  null &&
                                              newRideObject.destination!.name!
                                                  .isNotEmpty)
                                          ? newRideObject.destination!.name!
                                          : "Enter Destination",
                                      place: newRideObject.destination),
                                  (selected) async {
                                    print("onClick ui");
                                    if (widget.ride != null &&
                                        widget.ride!.isEditable()) {
                                      return;
                                    }
                                    if (newRideObject.source != null) {
                                      print(
                                          "source: ${newRideObject.source!.name!}");
                                    }
                                    if (newRideObject.destination != null) {
                                      print(
                                          "Destination: ${newRideObject.destination!.name!}");
                                    }
                                    var temprideObject =
                                        await Navigator.pushNamed(context,
                                                TripzieMarkOnMap.PAGE_NAME,
                                                arguments: newRideObject)
                                            as NewRideObject?;
                                    if (temprideObject != null) {
                                      tripDistance = 0;
                                      tripDistance = await distance2point(
                                            GeoPoint(
                                              longitude:
                                                  newRideObject.source!.lng!,
                                              latitude:
                                                  newRideObject.source!.lat!,
                                            ),
                                            GeoPoint(
                                              longitude: newRideObject
                                                  .destination!.lng!,
                                              latitude: newRideObject
                                                  .destination!.lat!,
                                            ),
                                          ) ~/
                                          1000;

                                      setState(() {});
                                    }
                                  },
                                  10.00,
                                  Colors.transparent,
                                ),
                                verticalDivider(),
                                if (tripDistance > 0)
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Total distance $tripDistance Kms",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  )
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        if (widget.ride == null || !widget.ride!.isEditable())
                          const Text(
                            "Select Riders",
                            style: TextStyle(fontSize: 12),
                          ),
                        if (widget.ride == null || !widget.ride!.isEditable())
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
                        if (newRideObject.selectedUsers.isNotEmpty &&
                            (widget.ride == null || !widget.ride!.isEditable()))
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: getSelectedList(),
                          ),
                        if (userList.isEmpty && originalList.isNotEmpty)
                          Container(
                              alignment: Alignment.center,
                              child: const Text("No user found for search")),
                        if (userList.isEmpty && originalList.isEmpty)
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("User list empty refresh to update"),
                                GestureDetector(
                                    onTap: fetchProfileData,
                                    child: Icon(Icons.refresh))
                              ],
                            ),
                            alignment: Alignment.center,
                          ),
                        if (userList.isNotEmpty)
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },
                                padding: EdgeInsets.zero,
                                itemCount: userList.length,
                                itemBuilder: (context, index) {
                                  if (userList[index].userId ==
                                      Authentication.loggedInUser!.userId) {
                                    return SizedBox();
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      if (widget.ride != null &&
                                          !widget.ride!.isEditable()) {
                                        return;
                                      }
                                      setState(() {
                                        newRideObject
                                            .toggleUser(userList[index]);
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          child: UserAvatar(
                                              imageUrl:
                                                  userList[index].imageUri),
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
                                                "${userList[index].firstName}",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (widget.ride == null ||
                                            !widget.ride!.isEditable())
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
                        const SizedBox(
                          height: 250,
                        )
                      ],
                    ),
                  ),
                ),
                titleBar(context, !isEdit ? "Ride Details" : "Create New Ride",
                    rightItem: SizedBox())
              ],
            ),
          ),
          showProgress(isInProgress)
        ],
      ),
      floatingActionButtonLocation:
          (widget.ride != null && widget.ride!.isEditable())
              ? FloatingActionButtonLocation.endFloat
              : FloatingActionButtonLocation.centerFloat,
      floatingActionButton: getFabButton(),
    );
  }

  datePicker(String placeholder, DateTime? date,
      Function(DateTime selectedStartDate) callback,
      [isEndDate = false]) {
    return GestureDetector(
      onTap: () async {
        if (widget.ride != null && widget.ride!.isEditable()) {
          return;
        }
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
    if (allUsers.values.isEmpty) {
      allUsers = await fetchProfiles();
    }
    var data = allUsers.values;
    setState(() {
      originalList.clear();
      originalList.addAll(data);
      userList.clear();
      if (widget.ride != null) {
        for (var item in widget.ride!.selectedUsers!) {
          newRideObject.selectedUsers[item.userId!] = item;
        }
      }
      if (widget.ride != null && widget.ride!.isEditable()) {
        userList.addAll(widget.ride!.selectedUsers!);
      } else {
        userList.addAll(data);
      }
    });
    print("data: $data");
    setState(() {
      isInProgress = false;
    });
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
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2));
      },
      child: Wrap(
          children: newRideObject.selectedUsers.keys
              .map((k) => GestureDetector(
                    onTap: () {
                      if (widget.ride != null && widget.ride!.isEditable()) {
                        return;
                      }
                      setState(() {
                        newRideObject.removeUser(k);
                      });
                    },
                    child: Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
                      color: otp_background_color,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: UserAvatar(
                                  imageUrl:
                                      newRideObject.selectedUsers[k]!.imageUri,
                                  radius: 18,
                                ),
                              ),
                              TextSpan(
                                  text: newRideObject
                                      .selectedUsers[k]!.firstName!,
                                  style: TextStyle(
                                      color: accent_color, fontSize: 16)),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: GestureDetector(
                                  onTap: () {
                                    if (widget.ride != null &&
                                        widget.ride!.isEditable()) {
                                      return;
                                    }
                                    setState(() {
                                      newRideObject.removeUser(k);
                                    });
                                  },
                                  child: const Icon(
                                    Icons.close_rounded,
                                    size: 15,
                                    color: accent_color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList()),
    );
  }

  getFabButton() {
    print("isInProgress: $isInProgress");
    if (!isInProgress) {
      if (widget.ride != null && widget.ride!.isCompleted()) {
        return getRideCompletedUi();
      }
      if ((widget.ride == null || !widget.ride!.isEditable())) {
        if (isEdit) {
          return TripzieButton(
            button_text: "Create Ride",
            onPressed: () async {
              isNameEmpty =
                  newRideObject.name == null || newRideObject.name!.isEmpty;
              isSourceOrDestinationEmpty = newRideObject.source == null ||
                  newRideObject.destination == null;
              isStartDateEndDateEmpty = newRideObject.startDate == null ||
                  newRideObject.endDate == null;
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
                showSnackBarApiSuccess(context,
                    message: "Ride Created Successfully");
                Navigator.pop(context);
              } else {
                showSnackBarApiError(context,
                    message:
                        "Unable to create Rides at this movement Please try again later");
              }
            },
          );
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 50),
          width: MediaQuery.of(context).size.width,
          child: SwipeableButtonView(
            buttonColor: Colors.transparent,
            indicatorColor: AlwaysStoppedAnimation(Colors.transparent),
            buttonText: 'Slide to start ride',
            buttonWidget: Container(
              child: Image(
                image: AssetImage(logo_image),
                width: 30,
                height: 30,
              ),
            ),
            activeColor: accent_color,
            isFinished: isFinished,
            onWaitingProcess: () {
              setState(() {
                isFinished = true;
              });
            },
            onFinish: () async {
              print("start ride api");

              var isSuccess = await startRide(widget.ride!.getId());
              if (isSuccess) {
                showSnackBarApiSuccess(context,
                    message: "Ride Started successfully");

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

                Navigator.popAndPushNamed(context, CurrentRideScreen.PAGE_NAME,
                    arguments: widget.ride);
              } else {
                setState(() {
                  isFinished = false;
                });
              }
            },
          ),
        );
      }
    }
    return null;
    /*
    * (!isInProgress &&
        (widget.ride == null || !widget.ride!.isCompleted()))
        ? (isEdit)
        ? TripzieButton(
      button_text: "Create Ride",
      onPressed: () async {
        isNameEmpty = newRideObject.name == null ||
            newRideObject.name!.isEmpty;
        isSourceOrDestinationEmpty = newRideObject.source == null ||
            newRideObject.destination == null;
        isStartDateEndDateEmpty = newRideObject.startDate == null ||
            newRideObject.endDate == null;
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
          showSnackBarApiSuccess(context,
              message: "Ride Created Successfully");
          // Navigator.pop(context);
        } else {
          showSnackBarApiError(context,
              message:
              "Unable to create Rides at this movement Please try again later");
        }
      },
    )
        : Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      width: MediaQuery.of(context).size.width,
      child: SwipeableButtonView(
        buttonColor: Colors.transparent,
        indicatorColor: AlwaysStoppedAnimation(Colors.transparent),
        buttonText: 'Slide to start ride',
        buttonWidget: Container(
          child: Image(
            image: AssetImage(logo_image),
            width: 30,
            height: 30,
          ),
        ),
        activeColor: accent_color,
        isFinished: isFinished,
        onWaitingProcess: () {
          setState(() {
            isFinished = true;
          });
        },
        onFinish: () async {
          print("start ride api");

          var isSuccess = await startRide(widget.ride!.getId());
          if (isSuccess) {
            showSnackBarApiSuccess(context,
                message: "Ride Started successfully");

            var permissionStatus =
            await Permission.microphone.request();
            if (permissionStatus != PermissionStatus.granted) {
              showSnackBar(context, "Please provide permission");
              return;
            }
            permissionStatus = await Permission.location.request();
            if (permissionStatus != PermissionStatus.granted) {
              showSnackBar(context, "Please provide permission");
              return;
            }

            Navigator.popAndPushNamed(
                context, CurrentRideScreen.PAGE_NAME,
                arguments: widget.ride);
          } else {
            setState(() {
              isFinished = false;
            });
          }
        },
      ),
    )
        : null*/
  }

  getRideCompletedUi() {
    return SizedBox(
      height: 30,
      child: FittedBox(
        child: FloatingActionButton.extended(
          label: Text('Completed'), // <-- Text
          backgroundColor: Colors.green,
          icon: Icon(
            // <-- Icon
            Icons.check_circle,
            size: 20.0,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
