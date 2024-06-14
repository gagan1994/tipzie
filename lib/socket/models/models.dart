import 'package:background_locator_2/location_dto.dart';

import '../../api/user_data.dart';

class LiveLocationModel {
  late String? userId;
  double? latitude;
  double? longitude;
  double? altitude;
  double? time;
  LiveLocationModel.fromData(this.latitude, this.longitude, this.altitude,
      this.time, UserProfile? user) {
    userId = user?.userId;
  }
  LiveLocationModel(LocationDto dto, UserProfile? user) {
    userId = user?.userId;
    latitude = dto.latitude;
    longitude = dto.longitude;
    altitude = dto.altitude;
    time = dto.time;
  }

  LiveLocationModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        altitude = json['altitude'],
        time = json['time'].toDouble();

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'time': time,
      };
}
