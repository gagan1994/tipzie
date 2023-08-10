import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tripzie/api/ride.dart';
import 'package:tripzie/api/user_data.dart';

import '../ui/main/rides/create_new_ride_screen.dart';

Future<http.Response> fetchData(String endpoint) {
  var resp = http.get(Uri.parse(
      'https://9100rosoac.execute-api.us-east-1.amazonaws.com/dev' + endpoint));
  print("$endpoint Resp: $resp");
  return resp;
}

Future<http.Response> uploadData(String endpoint, dynamic object) {
  var body = jsonEncode(object);
  print("uploading $endpoint Body: $body");
  var resp = http.post(
    Uri.parse(
      'https://9100rosoac.execute-api.us-east-1.amazonaws.com/dev' + endpoint,
    ),
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  );
  return resp;
}

Future<List<UserProfile>> fetchProfiles() async {
  var response = await fetchData("/profiles");
  print("response status: ${response.statusCode}");
  if (response.statusCode == 200) {
    List<dynamic> list = json.decode(response.body);
    List<UserProfile> userList = [];
    for (var item in list) {
      userList.add(UserProfile.fromJson(item));
    }
    return userList;
  }
  return [];
}

Future<bool> createRides(NewRideObject object) async {
  var jsonPost = toJson(object);
  var response = await uploadData("/rides", jsonPost);
  print("createRides response ${response.statusCode}");
  if (response.statusCode == 200) {
    return Future.value(true);
  }
  return Future.value(false);
}

Future<List<Ride>> fetchRides() async {
  var response = await fetchData("/rides");
  print("response status: ${response.statusCode}");
  if (response.statusCode == 200) {
    List<dynamic> list = json.decode(response.body);
    List<Ride> rideList = [];
    for (var item in list) {
      rideList.add(Ride.fromJson(item));
    }
    return rideList;
  }
  return [];
}

Map<String, dynamic> toJson(NewRideObject object) {
  return {
    "name": object.name,
    "location": {
      "source": {
        "name": object.source!.name,
        "latitude": object.source!.lat,
        "longitude": object.source!.lng
      },
      "destination": {
        "name": object.destination!.name,
        "latitude": object.destination!.lat,
        "longitude": object.destination!.lng
      }
    },
    "start_time": object.startDate.toString(),
    "end_time": object.endDate.toString(),
    "riders": object.selectedUsers.keys.toList(),
  };
}
