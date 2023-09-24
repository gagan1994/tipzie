import 'dart:collection';

import '../api/user_data.dart';

HashMap<String, UserProfile> allUsers = HashMap();

UserProfile findUserWithId(String id) {
  if (allUsers.containsKey(id)) {
    return allUsers[id]!;
  }
  return UserProfile(
      userId: "1", firstName: "fname", lastName: "sName", phoneNumber: "1234");
}
