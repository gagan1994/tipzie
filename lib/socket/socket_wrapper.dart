import 'dart:convert';

import 'package:background_locator_2/location_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tripzie/auth/authentication.dart';
import 'package:tripzie/socket/models/models.dart';
import 'package:tripzie/socket/socket_receive.dart';
import 'package:tripzie/socket/socket_send.dart';

class SocketWrapper {
  late SocketSender _sender;
  late SocketReceiver _receiver;
  late IO.Socket socket;

  static final SocketWrapper instance = SocketWrapper();

  User? user = null;

  SocketWrapper() {
    init();
    _sender = SocketSender();
    _receiver = SocketReceiver();
    _sender.setSocket(socket);
    _receiver.setSocket(socket);
  }

  void setUser(User? user) {
    print("updated user to socket $user hashCode: $hashCode");
    this.user = user;
  }

  void init() {
    print("initSocket");
    try {
      socket = IO.io("http://192.168.0.110:3700", <String, dynamic>{
        "transports": ['websocket'],
        "autoConnect": true
      });
      socket.connect();
      socket.onConnect((data) => print(
          "Socket connected id: ${socket.id} hashCode: ${SocketWrapper.instance.hashCode} $user"));
    } catch (e) {
      print("socket error");
      print(e);
    }
  }

  void sendData(LocationDto locationDto) async {
    try {
      print("SocketWrapper: sendData hashCode hashCode");
      if (user == null) {
        await Authentication.initializeFirebase();
        user = FirebaseAuth.instance.currentUser;
      }
      _sendData(
          "position-change", LiveLocationModel(locationDto, user).toJson());
    } catch (e) {
      print(e);
    }
  }

  void _sendData(String event, Map<String, dynamic> data) {
    var sendData = jsonEncode(data);
    _sender.emit(event, sendData);
  }
}
