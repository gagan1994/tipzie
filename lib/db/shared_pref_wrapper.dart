import 'dart:convert';

import 'package:tripzie/db/vm_wrapper.dart';

class SharedPrefWrapper extends VMWrapper {
  static final SharedPrefWrapper instance = new SharedPrefWrapper();

  void saveBgNotification(Map<String, dynamic> data) async {
    var notification = await getBgNotification();
    data.putIfAbsent('saved_time', () => DateTime.now().toString());
    notification.add(data);
    print('saveing - ${notification}');
    var file = await getSharedJsonFile();
    await file.writeAsString(jsonEncode(notification));
    print('saved to - ${file.path}');
  }

  Future<List<dynamic>> getBgNotification() async {
    var file = await getSharedJsonFile();
    var fileExist = await file.exists();
    if (fileExist) {
      String notification;
      try {
        notification = await file.readAsString();
        return jsonDecode(notification);
      } catch (e) {
        print("Couldn't read file");
      }
    }
    return [];
  }

  void clearNotificationDetails() async {
    print('clearNotificationDetails');
    var file = await getSharedJsonFile();
    file.delete();
  }
}
