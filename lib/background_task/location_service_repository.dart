import 'dart:async';

import 'package:background_locator_2/location_dto.dart';

class LocationServiceRepository {
  static LocationServiceRepository _instance = LocationServiceRepository._();

  LocationServiceRepository._();

  factory LocationServiceRepository() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';

  int _count = -1;

  Future<void> init(Map<dynamic, dynamic> params) async {
    print("***********Init callback handler");
    if (params.containsKey('countInit')) {
      dynamic tmpCount = params['countInit'];
      if (tmpCount is double) {
        _count = tmpCount.toInt();
      } else if (tmpCount is String) {
        _count = int.parse(tmpCount);
      } else if (tmpCount is int) {
        _count = tmpCount;
      } else {
        _count = -2;
      }
    } else {
      _count = 0;
    }
    print("$_count");
    print("Location:  init");
  }

  Future<void> dispose() async {
    print("***********Dispose callback handler");
    print("$_count");
    print("Location:  dispose");
  }

  Future<void> callback(LocationDto locationDto) async {
    print('$_count location in dart: ${locationDto.toString()}');
    await setLogPosition(_count, locationDto);
    print("Location: callback - $locationDto");
    _count++;
  }

  static Future<void> setLogPosition(int count, LocationDto data) async {
    final date = DateTime.now();
    print(
        '$count : ${formatDateLog(date)} --> ${data} --- isMocked: ${data.isMocked}\n');
  }

  static String formatDateLog(DateTime date) {
    return date.hour.toString() +
        ":" +
        date.minute.toString() +
        ":" +
        date.second.toString();
  }
}
