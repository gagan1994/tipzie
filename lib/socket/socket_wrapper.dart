import 'package:background_locator_2/location_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tripzie/db/shared_pref_wrapper.dart';
import 'package:tripzie/socket/models/models.dart';
import 'package:tripzie/socket/socket_receive.dart';
import 'package:tripzie/socket/socket_send.dart';

class SocketWrapper {
  late SocketSender _sender;
  late SocketReceiver _receiver;
  late IO.Socket socket;
  bool isInit = false;
  static final SocketWrapper instance = SocketWrapper();

  User? user = null;

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

  void setUser(User? user) {
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
      print("SocketWrapper: sendData ${FirebaseAuth.instance.currentUser}");
      user ??= FirebaseAuth.instance.currentUser;
      var ride_id = await SharedPrefWrapper.instance.getOnGoingRide();
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
      String ride_id, Function(LiveLocationModel) callback) {
    SharedPrefWrapper.instance.saveOnGoingRide(ride_id);
    _sender.emit('subscribe_rides', {'ride_id': ride_id});
    _receiver.listen('rides_' + ride_id, (data) async {
      var liveData = LiveLocationModel.fromJson(data);
      callback(liveData);
    });
  }

  void subscribeTopic(String topic, Function(dynamic) callback) {
    _receiver.listen(topic, callback);
  }

  onConnectSocket(data) async {
    print(
        "Socket connected id: ${socket.id} hashCode: ${SocketWrapper.instance.hashCode} $user");
    var ride_id = await SharedPrefWrapper.instance.getOnGoingRide();
    if (ride_id.isNotEmpty) {
      print('socket connected ride_id: ' + ride_id);
      _sender.emit('subscribe_rides', {'ride_id': ride_id});
    }
  }
}
