import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tripzie/api/user_data.dart';

Future<http.Response> fetchData(String endpoint) {
  var resp = http.get(Uri.parse(
      'https://9100rosoac.execute-api.us-east-1.amazonaws.com/dev' + endpoint));
  print("$endpoint Resp: $resp");
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
