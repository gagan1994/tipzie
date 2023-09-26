import 'dart:async';

import 'package:background_locator_2/location_dto.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tripzie/socket/models/models.dart';
import 'package:tripzie/socket/socket_receive.dart';
import 'package:tripzie/socket/socket_send.dart';

import '../api/user_data.dart';

class SocketWrapper {
  late SocketSender _sender;
  late SocketReceiver _receiver;
  late IO.Socket socket;
  bool isInit = false;
  static final SocketWrapper instance = SocketWrapper();

  UserProfile? user = null;
  String ride_id = "";

  SocketWrapper() {}
  static void initSocket() {
    print("isInit: ${instance.isInit}");
    if (instance.isInit) {
      return;
    }
    instance.init();
    instance._sender = SocketSender();
    instance._receiver = SocketReceiver();
    instance._sender.setSocket(instance.socket);
    instance._receiver.setSocket(instance.socket);
    instance.isInit = true;
  }

  void setUser(UserProfile? user) {
    print("updated user to socket $user hashCode: $hashCode");
    this.user = user;
  }

  void init() {
    print("initSocket");
    try {
      socket = IO.io("http://192.168.1.2:3000", <String, dynamic>{
        "transports": ['websocket'],
        "autoConnect": true
      });
      socket.connect();
      socket.onConnect(onConnectSocket);
    } catch (e) {
      print("socket error");
      print(e);
    }
  }

  void sendData(LocationDto locationDto) async {
    try {
      print("SocketWrapper: sendData ${user} ride_id: $ride_id");
      _sendData(
          'rides_' + ride_id, LiveLocationModel(locationDto, user).toJson());
    } catch (e) {
      print(e);
    }
  }

  void sendDataToTopic(String topic, dynamic message) {
    _sendData(topic, message);
  }

  void _sendData(String event, Map<String, dynamic> data) {
    _sender.emit(event, data);
  }

  void startListeningForLocationUpdates(
      String ride_id, StreamController<LiveLocationModel> callback) {
    print("Saving OnGoingRide $ride_id");
    this.ride_id = ride_id;
    _sender.emit('subscribe_rides', {'ride_id': ride_id});
    _receiver.listen('rides_' + ride_id, (data) async {
      print("received from rides location $data");
      var liveData = LiveLocationModel.fromJson(data);
      if (!callback.isClosed) {
        callback.add(liveData);
      }
    });
  }

  void subscribeTopic(String topic, Function(dynamic) callback) {
    _receiver.listen(topic, callback);
  }

  onConnectSocket(data) async {
    print(
        "Socket connected id: ${socket.id} hashCode: ${SocketWrapper.instance.hashCode} $user");
    print('socket connected ride_id: ' + ride_id);
    if (ride_id.isNotEmpty) {
      _sender.emit('subscribe_rides', {'ride_id': ride_id});
    }
  }
}
