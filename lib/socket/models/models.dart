import 'package:background_locator_2/location_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LiveLocationModel {
  late String? userId;
  String? userName;
  String? phoneNumber;
  String? email;

  double? latitude;
  double? longitude;
  double? altitude;
  double? time;
  LiveLocationModel(LocationDto dto, User? user) {
    userId = user?.uid;
    userName = user?.displayName;
    phoneNumber = user?.phoneNumber;
    email = user?.email;
    latitude = dto.latitude;
    longitude = dto.longitude;
    altitude = dto.altitude;
    time = dto.time;
  }

  LiveLocationModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        userName = json['userName'],
        phoneNumber = json['phoneNumber'],
        email = json['email'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        altitude = json['altitude'],
        time = json['time'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'phoneNumber': phoneNumber,
        'email': email,
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'time': time,
      };
}
