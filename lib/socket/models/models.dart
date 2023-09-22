import 'package:background_locator_2/location_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../api/user_data.dart';

class LiveLocationModel {
  late String? userId;
  String? userName;
  String? phoneNumber;
  String? email;
  String? photoURL;

  double? latitude;
  double? longitude;
  double? altitude;
  double? time;
  LiveLocationModel.fromData(
      this.latitude, this.longitude, this.altitude, this.time, User? user) {
    userId = user?.uid;
    userName = user?.displayName;
    phoneNumber = user?.phoneNumber;
    email = user?.email;
    photoURL = user?.photoURL;
  }
  LiveLocationModel(LocationDto dto, UserProfile? user) {
    userId = user?.firebaseUid;
    userName = user?.firstName;
    phoneNumber = user?.phoneNumber;
    email = user?.email;
    latitude = dto.latitude;
    longitude = dto.longitude;
    altitude = dto.altitude;
    time = dto.time;
    photoURL = user?.imageUri;
  }

  LiveLocationModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        userName = json['userName'],
        phoneNumber = json['phoneNumber'],
        email = json['email'],
        photoURL = json['photoURL'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        altitude = json['altitude'],
        time = json['time'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'phoneNumber': phoneNumber,
        'email': email,
        'photoURL': photoURL,
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'time': time,
      };
}
