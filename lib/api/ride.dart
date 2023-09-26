import 'package:tripzie/api/user_data.dart';
import 'package:tripzie/auth/authentication.dart';
import 'package:tripzie/db/users.dart';

import '../ui/main/map/tripit_map_ui.dart';

enum RideStatus { IDLE, ACTIVE, COMPLETED }

class Ride {
  String _id = '';
  String name = '';
  Places? source;
  Places? destination;
  DateTime? startDate;
  DateTime? endDate;
  String? imageUri;
  RideStatus? rideStatus;
  String? createdBy;
  bool isAvailable = false;
  DateTime endTime = DateTime.now();
  List<UserProfile>? selectedUsers = [];

  String getId() {
    return _id;
  }

  bool isCreatedByCurrentUser() {
    return createdBy == Authentication.loggedInUser!.userId!;
  }

  bool isEditable() {
    return rideStatus == RideStatus.COMPLETED || !isCreatedByCurrentUser();
  }

  bool isCompleted() {
    return rideStatus == RideStatus.COMPLETED;
  }

  Ride.fromJson(Map<String, dynamic> json) {
    _id = json['_id'];
    name = json['name'];
    createdBy = json['created_userid'];
    var status = json['status'];
    if (status == 'idle') {
      rideStatus = RideStatus.IDLE;
    }
    if (status == 'active') {
      rideStatus = RideStatus.ACTIVE;
    }
    if (status == 'completed') {
      rideStatus = RideStatus.COMPLETED;
    }
    if (json['location'] == null) {
      print(json);
    } else {
      source = Places.fromJson(json['location']['source']);
      destination = Places.fromJson(json['location']['destination']);
    }
    var start_time = json['start_time'];
    var end_time = json['end_time'];
    try {
      startDate = DateTime.tryParse(start_time);
      endDate = DateTime.tryParse(end_time);
      selectedUsers = (json['riders'] as List)
          .map((item) => findUserWithId(item as String))
          .toList();
    } catch (e) {
      startDate = DateTime.now();
      endDate = DateTime.now();
      selectedUsers = [];
    }
  }

  bool rideActive() {
    return rideStatus == RideStatus.ACTIVE;
  }
}
