import 'dart:async';

import 'package:background_locator_2/location_dto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tripzie/socket/socket_wrapper.dart';

class LocationServiceRepository {
  static LocationServiceRepository _instance = LocationServiceRepository._();

  LocationServiceRepository._();

  factory LocationServiceRepository() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';

  Future<void> init(Map<dynamic, dynamic> params) async {
    print("***********Init callback handler***********");
  }

  Future<void> dispose() async {
    print("***********Dispose callback handler***********");
  }

  Future<void> callback(LocationDto locationDto) async {
    print("***********Location callback***********");
    print('socket init: ${SocketWrapper.instance.isInit}');
    if (!SocketWrapper.instance.isInit) {
      SocketWrapper.initSocket();
    }
    await Firebase.initializeApp();
    SocketWrapper.instance.sendData(locationDto);
  }
}
