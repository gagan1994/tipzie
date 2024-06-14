import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tripzie/api/api_wrapper.dart';
import 'package:tripzie/socket/socket_wrapper.dart';

import '../auth/authentication.dart';
import '../db/shared_pref_wrapper.dart';
import '../socket/models/models.dart';

class TestUi extends StatefulWidget {
  static const PAGE_NAME = "/test_ui";
  Map<String, dynamic> dataFromNotification;
  TestUi(this.dataFromNotification, {Key? key}) : super(key: key);

  @override
  State<TestUi> createState() => _TestUiState();
}

class _TestUiState extends State<TestUi> {
  var ride_id = '';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    SharedPrefWrapper.instance.clearNotificationDetails();
    print("TestUi init: " + widget.dataFromNotification.toString());
    if (widget.dataFromNotification.containsKey('ride_id')) {
      ride_id = widget.dataFromNotification['ride_id'];
      print("Ride id: $ride_id");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: registerFirebase,
              child: Text('registerFirebase'),
            ),
            ElevatedButton(
              onPressed: () async {
                var ride = await fetchRideById(ride_id);
                SocketWrapper.initSocket(ride!);
              },
              child: Text('Init socket'),
            ),
            ElevatedButton(
              onPressed: sendSubscribeRides,
              child: Text('Send ride capture'),
            ),
            ElevatedButton(
              onPressed: subscribe,
              child: Text('subscribe topic'),
            ),
            ElevatedButton(
              onPressed: unSubscribe,
              child: Text('un-subscribe topic'),
            ),
            ElevatedButton(
              onPressed: sendData,
              child: Text('Send Data'),
            )
          ],
        ),
      ),
    );
  }

  void registerFirebase() {
    _firebaseMessaging
        .getToken()
        .then((token) => print("token begin\n$token\ntoken end"));
  }

  void subscribe() {
    // SocketWrapper.instance.subscribeTopic("rides_${ride_id}", (response) {
    //   var locationData = LiveLocationModel.fromJson(response);
    //   print("received data: ${locationData.latitude}");
    // });
  }

  void sendSubscribeRides() {
    SocketWrapper.instance
        .sendDataToTopic("subscribe_rides", {"ride_id": ride_id});
  }

  void unSubscribe() {}

  void sendData() {
    var currentMarker = LiveLocationModel.fromData(
      12.9716,
      77.5946,
      40.4376,
      DateTime.now().millisecond.toDouble(),
      Authentication.loggedInUser,
    );
    SocketWrapper.instance
        .sendDataToTopic("rides_$ride_id", currentMarker.toJson());
  }
}
