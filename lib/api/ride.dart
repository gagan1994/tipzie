import 'package:tripzie/api/user_data.dart';
import 'package:tripzie/db/users.dart';

import '../ui/main/map/tripit_map_ui.dart';

class Ride {
  String? _id;
  Places? source;
  Places? destination;
  DateTime? startDate;
  DateTime? endDate;
  List<UserProfile>? selectedUsers = [];

  String? name;
  Ride.fromJson(Map<String, dynamic> json) {
    _id = json['_id'];
    name = json['name'];
    if (json['location'] == null) {
      print(json);
    } else {
      source = Places.fromJson(json['location']['source']);
      destination = Places.fromJson(json['location']['destination']);
    }
    var start_time = json['start_time'];
    var end_time = json['end_time'];
    startDate = DateTime.tryParse(start_time);
    endDate = DateTime.tryParse(end_time);
    print("Riders: ${json['riders']}");
    selectedUsers = (json['riders'] as List)
        .map((item) => findUserWithId(item as String))
        .toList();
  }

  //"_id": "64aabdb502343f44c4f95f7d",
//         "name": "Male Trip",
//         "location": {
//             "source": {
//                 "name": "shimoga",
//                 "latitude": 40.7829,
//                 "longitude": -73.9654
//             },
//             "destination": {
//                 "name": "goa",
//                 "latitude": 40.7829,
//                 "longitude": -73.9654
//             }
//         },
//         "start_time": "2023-07-09 12:30:00",
//         "end_time": "2023-07-10 12:30:00",
//         "riders": [
//             "6173748a73b3c48b78e4e7f1",
//             "6173748a73b3c48b78e4e7f2"
//         ]
//     },
}
