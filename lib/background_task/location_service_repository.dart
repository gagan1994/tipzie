import 'dart:async';

import 'package:background_locator_2/location_dto.dart';
import 'package:tripzie/socket/socket_wrapper.dart';

import '../main.dart';

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
    SocketWrapper.instance.sendData(locationDto);
  }
}
