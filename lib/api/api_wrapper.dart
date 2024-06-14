import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:tripzie/api/ride.dart';
import 'package:tripzie/api/user_data.dart';
import 'package:tripzie/auth/authentication.dart';
import 'package:tripzie/db/shared_pref_wrapper.dart';
import 'package:tripzie/norification/firebase_notifcation_wrapper.dart';
import 'package:tripzie/utils/ui_utils.dart';

import '../filrebase/firebase_storage.dart';
import '../ui/main/rides/create_new_ride_screen.dart';

const BASE_URL = 'http://192.168.1.5:3000';
const BASE_URL_SOCKET = 'ws://192.168.1.5:3000';
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
  var response = await fetchData("/profiles/$userId");
  print("profiles response status: ${response.statusCode}");
  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = json.decode(response.body);
    Authentication.loggedInUser = UserProfile.fromJson(responseBody);
    return Authentication.loggedInUser;
  }
  return null;
}

Future<UserProfile?> getUserDetails(User user) async {
  if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
    var userFromPhone = await fetchData("/profiles/phone/${user.phoneNumber}");
    if (userFromPhone.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(userFromPhone.body));
    }
  }
  if (user.email != null && user.email!.isNotEmpty) {
    var userFromEmail = await fetchData("/email/${user.email}");
    if (userFromEmail.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(userFromEmail.body));
    }
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
  }
  return HashMap();
}

Future<bool> createRides(NewRideObject object) async {
  var jsonPost = toJson(object);
  jsonPost['created_userid'] = Authentication.loggedInUser!.userId;
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

Future<List<Ride>> fetchRides() async {
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
    showSnackBar(
        navigatorKey.currentState!.context, "Unable to load Please Refresh");
  }
  return [];
}

Future<bool> startRide(String rideId) async {
  print("startRide");
  var json = {"ride_id": rideId};
  var response = await postData("/start_ride", json);
  print("response status: ${response.statusCode}");
  if (response.statusCode == 200) {
    return true;
  } else {
    showSnackBar(
        navigatorKey.currentState!.context, "Unable to load Please Refresh");
    return false;
  }
}

Future<bool> completeRide(String rideId) async {
  print("fetchRideById");
  var json = {"ride_id": rideId};
  var response = await postData("/complete_ride", json);
  print("response status: ${response.statusCode}");
  if (response.statusCode == 200) {
    return true;
  } else {
    showSnackBarApiError(navigatorKey.currentState!.context);
    return false;
  }
  return true;
}

Future<Ride?> fetchRideById(String rideId) async {
  print("fetchRideById");
  var response = await fetchData("/rides/$rideId");
  print("response status: ${response.statusCode}");
  if (response.statusCode == 200) {
    var list = json.decode(response.body);
    return Ride.fromJson(list);
  } else {
    showSnackBar(
        navigatorKey.currentState!.context, "Unable to load Please Refresh");
  }
  return null;
}

Future<bool> loginOrCreateUser(User user) async {
  var existingUser = await getUserDetails(user);
  var uid = user.uid;
  var idToken = await user.getIdToken();
  if (existingUser == null) {
    var fName = user.displayName ?? "";
    var lName = "";
    var phoneNumber = user.phoneNumber ?? "";
    var bio = "";
    var bloodGroup = "";
    var email = user.email ?? "";
    var imageUri = user.photoURL ?? "";

    var token =
        await FirebasePushNotificationWrapper.getInstance().getFcmToken();
    var resp = await postData('/profiles', {
      'first_name': fName,
      'last_name': lName,
      'phone': phoneNumber,
      'bio': bio,
      'blood_group': bloodGroup,
      'email': email,
      'image_uri': imageUri,
      'firebase_uid': uid,
      'firebase_login_token': idToken,
      "fcmToken": token
    });
    if (resp.statusCode == 200) {
      var body = jsonDecode(resp.body);
      var userId = body['user_id'];
      print('user Id received from server: $body');
      await SharedPrefWrapper.instance.saveUser(userId);
      var user = await fetchCurrentUserProfile();
      Authentication.loggedInUser = user;
      return user != null;
    }
    return false;
  } else {
    await SharedPrefWrapper.instance.saveUser(existingUser.userId!);
    return await updateExistingUser(existingUser);
  }
}

Future<bool> updateExistingUser(UserProfile existingUser) async {
  return await updateProfile(
      existingUser.firstName ?? "",
      existingUser.lastName ?? "",
      existingUser.phoneNumber ?? "",
      existingUser.bloodGroup ?? "",
      existingUser.bio ?? "",
      email: existingUser.email ?? "",
      imageUri: existingUser.imageUri ?? "");
}

Future<bool> updateProfile(
  String fName,
  String lName,
  String phoneNumber,
  String bloodGroup,
  String bio, {
  uploadFile = "",
  imageUri = "",
  email,
}) async {
  try {
    await Future.delayed(Duration(seconds: 1));
    print("Image uri1: $imageUri");
    if (imageUri.toString().isEmpty) {
      imageUri = (Authentication.loggedInUser!.imageUri == null ||
              Authentication.loggedInUser!.imageUri!.isEmpty)
          ? FirebaseAuth.instance.currentUser!.photoURL
          : "";
    }
    print("Image uri2: $imageUri");

    if (email == null && email.toString().isEmpty) {
      email = FirebaseAuth.instance.currentUser!.email;
    }
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    email ??= '';
    try {
      if (uploadFile != null && uploadFile.toString().isNotEmpty) {
        print("Image uri3: $imageUri");
        imageUri = await firebaseProfileUpload(File(uploadFile));
      }
    } on Exception {}
    if (imageUri == null || imageUri.isEmpty) {
      print("Image uri4: $imageUri");
      imageUri =
          'https://www.vhv.rs/dpng/d/256-2569650_men-profile-icon-png-image-free-download-searchpng.png';
    }
    http.Response? resp = null;
    var token =
        await FirebasePushNotificationWrapper.getInstance().getFcmToken();
    var userId = await SharedPrefWrapper.instance.getUserId();
    resp = await patchData('/profiles/$userId', {
      'first_name': fName,
      'last_name': lName,
      'phone': phoneNumber,
      'bio': bio,
      'blood_group': bloodGroup,
      'email': email,
      'image_uri': imageUri,
      'firebase_uid': uid,
      'firebase_login_token': idToken,
      'fcmToken': token
    });
    print("resp:  ${resp.statusCode}");
    var user = await fetchCurrentUserProfile();
    Authentication.loggedInUser = user;
    return true;
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
