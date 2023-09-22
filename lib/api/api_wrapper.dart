import 'dart:collection';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tripzie/api/ride.dart';
import 'package:tripzie/api/user_data.dart';
import 'package:tripzie/db/shared_pref_wrapper.dart';
import 'package:tripzie/norification/firebase_notifcation_wrapper.dart';
import 'package:tripzie/utils/ui_utils.dart';

import '../ui/main/rides/create_new_ride_screen.dart';

const BASE_URL = 'http://13.233.26.160:3000';
const LOCAL_DATA = 404;

Future<http.Response> fetchData(String endpoint) async {
  try {
    var uri = Uri.parse(BASE_URL + endpoint);
    print("fetchData $uri");
    var resp = await http.get(uri);
    print("fetchData $endpoint Resp: $resp");
    return resp;
  } on Exception {
    return Future.value(http.Response('exception - $endpoint', LOCAL_DATA));
  }
}

Future<http.Response> postData(String endpoint, dynamic object) async {
  try {
    var body = jsonEncode(object);
    print("postData $endpoint Body: $body");
    var resp = await http.post(
      Uri.parse(
        BASE_URL + endpoint,
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    print('endpoint: $endpoint response: ${resp.statusCode}');
    return resp;
  } catch (e) {
    return Future.value(http.Response(e.toString(), 100));
  }
}

Future<http.Response> patchData(String endpoint, dynamic object) async {
  try {
    var body = jsonEncode(object);
    print("patchData $endpoint Body: $body");
    var resp = await http.patch(
      Uri.parse(
        BASE_URL + endpoint,
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    print('patchData endpoint: $endpoint response: ${resp.statusCode}');
    return resp;
  } catch (e) {
    return Future.value(http.Response(e.toString(), 100));
  }
}

Future<UserProfile?> fetchCurrentUserProfile() async {
  var userId = await SharedPrefWrapper.instance.getUserId();
  var response1 = await fetchProfiles();
  if (response1.containsKey(userId)) {
    return response1[userId];
  }

  var response = await fetchData("/profiles/$userId");
  print("profiles response status: ${response.statusCode}");
  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = json.decode(response.body);
    return UserProfile.fromJson(responseBody);
  }
  return null;
}

Future<HashMap<String, UserProfile>> fetchProfiles() async {
  print("fetchProfiles");

  var response = await fetchData("/profiles");
  print("profiles response status: ${response.statusCode}");
  if (response.statusCode == 200) {
    List<dynamic> list = json.decode(response.body);
    HashMap<String, UserProfile> userList = HashMap();
    for (var item in list) {
      var profile = UserProfile.fromJson(item);

      userList[profile.userId!] = profile;
    }
    return userList;
  } else if (response.statusCode == LOCAL_DATA) {
    List<dynamic> list = temp_profiles;
    HashMap<String, UserProfile> userList = HashMap();
    for (var item in list) {
      var profile = UserProfile.fromJson(item);

      userList[profile.userId!] = profile;
    }
    return userList;
  }
  return HashMap();
}

Future<bool> createRides(NewRideObject object) async {
  var jsonPost = toJson(object);
  var response = await postData("/rides", jsonPost);
  print("createRides response ${response.statusCode}");
  if (response.statusCode == 200) {
    return Future.value(true);
  }
  return Future.value(false);
}

Future<bool> uploadFcm(String token) async {
  var id = SharedPrefWrapper.instance.getJsonData('_id');
  var jsonPost = {'fcm_token': token, 'userid': id};
  var response = await patchData("/fcm_token", jsonPost);
  print("fcm upload response ${response.statusCode}");
  if (response.statusCode == 200) {
    return Future.value(true);
  }
  return Future.value(false);
}

Future<List<Ride>> fetchRides(BuildContext context) async {
  print("fetchRides");
  var response = await fetchData("/rides");
  print("response status: ${response.statusCode}");
  if (response.statusCode == 200) {
    List<dynamic> list = json.decode(response.body);
    List<Ride> rideList = [];
    for (var item in list) {
      rideList.add(Ride.fromJson(item));
    }
    return rideList;
  } else {
    showSnackBar(context, "Unable to load Please Refresh");
  }
  return [];
}

/*
* firstNameController.text,
                lastNameController.text,
                phoneNumberController.text,
                bloodGroupController.text,
                bioController.text*/

Future<bool> updateProfile(String fName, String lName, String phoneNumber,
    String bloodGroup, String bio,
    {isCreate = false}) async {
  try {
    await Future.delayed(Duration(seconds: 1));
    var imageUri = FirebaseAuth.instance.currentUser!.photoURL;
    var email = FirebaseAuth.instance.currentUser!.email;
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    email ??= '';
    if (imageUri == null) {
      imageUri =
          'https://www.vhv.rs/dpng/d/256-2569650_men-profile-icon-png-image-free-download-searchpng.png';
    }
    http.Response? resp = null;
    if (isCreate) {
      resp = await postData('/profiles', {
        'first_name': fName,
        'last_name': lName,
        'phone': phoneNumber,
        'bio': bio,
        'email': email,
        'image_uri': imageUri,
        'firebase_uid': uid,
        'firebase_login_token': idToken
      });
      if (resp.statusCode == 200) {
        var body = jsonDecode(resp.body);
        var userId = body['insertedId'];
        print('user Id received from server: $userId');
        await SharedPrefWrapper.instance.saveUser(userId);
        FirebasePushNotificationWrapper.getInstance().uploadTokenToServer();
      }
      return resp.statusCode == 200;
    } else {
      var userId = await SharedPrefWrapper.instance.getUserId();
      resp = await patchData('/profiles/$userId', {
        'first_name': fName,
        'last_name': lName,
        'phone': phoneNumber,
        'bio': bio,
        'email': email,
        'image_uri': imageUri,
        'firebase_uid': uid,
        'firebase_login_token': idToken
      });
    }
    return resp.statusCode == 200;
  } on Exception {}
  return Future.value(false);
}

Future<List<Ride>> fetchOnGoingRides(BuildContext context) async {
  print("fetchOnGoingRides");
  var response = await fetchData("/current_rides");
  print("response status: ${response.statusCode}");
  if (response.statusCode == 200) {
    List<dynamic> list = json.decode(response.body);
    List<Ride> rideList = [];
    for (var item in list) {
      rideList.add(Ride.fromJson(item));
    }
    return rideList;
  } else if (response.statusCode == LOCAL_DATA) {
    List<dynamic> list = temp_current_rides;
    List<Ride> rideList = [];
    for (var item in list) {
      rideList.add(Ride.fromJson(item));
    }
    return rideList;
  } else {
    showSnackBar(context, "Unable to load Please Refresh");
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

const temp_profiles = [
  {
    "_id": "649e80a17f729edf3809f3f2",
    "FirstName": "punith",
    "SurName": "degavi",
    "phone": 999999999,
    "__v": 0
  },
  {
    "_id": "64aa9ad3a2e83d87e054c0b1",
    "FirstName": "Devraj",
    "SurName": "kuruva",
    "phone": 999999999
  },
  {
    "_id": "64aa9aeda2e83d87e054c0b2",
    "FirstName": "Gagan",
    "SurName": "Patil",
    "phone": 999999999
  },
  {
    "_id": "64aaaae7771d3e66c28a64fd",
    "FirstName": "Gagan",
    "SurName": "Patil",
    "phone": 999999999
  },
  {
    "_id": "64aab59ed8f24cbcfab2e01d",
    "FirstName": "Gagan",
    "SurName": "Patil",
    "phone": 999999999
  },
  {
    "_id": "64aab5d3b583a26cbebea464",
    "FirstName": "Deepak",
    "SurName": "honnali",
    "phone": 777777777
  },
  {
    "_id": "64aabd1002343f44c4f95f7c",
    "FirstName": "Gagan",
    "SurName": "Patil",
    "phone": 88888888
  },
  {
    "_id": "64d79c133dc882f5338e1696",
    "FirstName": "viju",
    "SurName": "degavi",
    "phone": 999999999
  },
  {
    "_id": "64d79c1b3dc882f5338e1697",
    "FirstName": "viju2",
    "SurName": "degavi",
    "phone": "999999999"
  },
  {
    "_id": "64d79d1f3dc882f5338e1698",
    "FirstName": "viju2",
    "SurName": "degavi",
    "phone": "999999999",
    "image": "https://www.gstatic.com/webp/gallery3/1.sm.png"
  }
];

const temp_current_rides = [
  {
    "_id": "64aabdb502343f44c4f95f7d",
    "name": "Male Trip",
    "location": {
      "source": {"name": "shimoga", "latitude": 40.7829, "longitude": -73.9654},
      "destination": {"name": "goa", "latitude": 40.7829, "longitude": -73.9654}
    },
    "start_time": "2023-07-09 12:30:00",
    "end_time": "2023-07-10 12:30:00",
    "riders": ["6173748a73b3c48b78e4e7f1", "6173748a73b3c48b78e4e7f2"]
  },
  {
    "_id": "64aaca73b8920393bbcc20aa",
    "name": "Newyearride3",
    "location": {
      "source": {"name": "shimoga", "latitude": 40.7829, "longitude": -73.9654},
      "destination": {"name": "goa", "latitude": 40.7829, "longitude": -73.9654}
    },
    "start_time": "2023-07-09 12:30:00",
    "end_time": "2023-07-10 12:30:00",
    "riders": ["6173748a73b3c48b78e4e7f1", "6173748a73b3c48b78e4e7f2"]
  },
  {
    "_id": "64d3a4b5cbfb4721e73f65f8",
    "name": "dasara ride",
    "location": {
      "source": {"name": "shimoga", "latitude": 40.7829, "longitude": -73.9654},
      "destination": {"name": "goa", "latitude": 40.7829, "longitude": -73.9654}
    },
    "start_time": "2023-07-09 12:30:00",
    "end_time": "2023-07-10 12:30:00",
    "riders": ["6173748a73b3c48b78e4e7f1", "6173748a73b3c48b78e4e7f2"]
  },
  {
    "_id": "64d79e0a3dc882f5338e1699",
    "name": "Trip_aug_12",
    "location": {
      "source": {
        "name": "Shikaripura",
        "latitude": 40.7829,
        "longitude": -73.9654
      },
      "destination": {
        "name": "Bhadravathi",
        "latitude": 40.7829,
        "longitude": -73.9654
      }
    },
    "start_time": "2023-07-09 12:30:00",
    "end_time": "2023-07-10 12:30:00",
    "riders": ["6173748a73b3c48b78e4e7f1", "6173748a73b3c48b78e4e7f2"],
    "created_userid": "6173748a73b3c48b78e4e7f1"
  }
];
