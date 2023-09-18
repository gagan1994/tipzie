import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:tripzie/socket/socket_wrapper.dart';

class TestUi extends StatefulWidget {
  static const PAGE_NAME = "/test_ui";
  Map<String, dynamic> dataFromNotification;
  TestUi(this.dataFromNotification, {Key? key}) : super(key: key);

  @override
  State<TestUi> createState() => _TestUiState();
}

class _TestUiState extends State<TestUi> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    // print("TestUi init: " + widget.dataFromNotification.toString());
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
    SocketWrapper.instance.subscribeTopic("subscribe_ride", (response) {
      print("received data: " + response);
    });
  }

  void unSubscribe() {}

  void sendData() {
    SocketWrapper.instance.sendDataToTopic(
        "chat message", {"data": "hi im gagan", "token": "gagan"});
  }
}
