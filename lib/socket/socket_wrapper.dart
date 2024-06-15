import 'dart:async';

import 'package:background_locator_2/location_dto.dart';
import 'package:tripzie/api/ride.dart';
import 'package:tripzie/socket/models/models.dart';
import 'package:tripzie/socket/models/webrtc/webrtc_helper.dart';

import '../auth/authentication.dart';

class SocketWrapper {
  bool isInit = false;
  static final SocketWrapper instance = SocketWrapper();

  SocketWrapper() {}
  static void initSocket(Ride ride) {
    print("isInit: ${instance.isInit}");
    instance.init(ride);
    instance.isInit = true;
  }

  void init(Ride ride) {
    print("initSocket");
    try {
      WebRtcHelper.getInstance()
          .init(ride, () => {print("socket init success")});
    } catch (e) {
      print("socket error");
      print(e);
    }
  }

  void sendData(LocationDto locationDto) async {
    try {
      _sendData(LiveLocationModel(locationDto, Authentication.loggedInUser));
    } catch (e) {
      print(e);
    }
  }

  void sendDataToTopic(String topic, dynamic message) {
    // _sendData(topic, message);
  }

  void _sendData(LiveLocationModel data) {
    WebRtcHelper.getInstance().sendLocationDetails(data);
  }

  StreamController<LiveLocationModel> getLiveLocationStream() {
    return WebRtcHelper.getInstance().getLiveLocationStream();
  }

  StreamController<List<dynamic>> userInRoom() {
    return WebRtcHelper.getInstance().getUsersInRoom();
  }

  StreamController<String> getUsersLeft() {
    return WebRtcHelper.getInstance().getUsersLeft();
  }

  void cleanup() {
    WebRtcHelper.getInstance().dispose();
    isInit = false;
  }
}
