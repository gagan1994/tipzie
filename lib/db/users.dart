import 'dart:collection';

import '../api/user_data.dart';

HashMap<String, UserProfile> allUsers = HashMap();

UserProfile findUserWithId(String id) {
  print("userId: $id in $allUsers");
  if (allUsers.containsKey(id)) {
    return allUsers[id]!;
  }
  return UserProfile(
      userId: "1", firstName: "fname", surName: "sName", phone: 1234);
}
