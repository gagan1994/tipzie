import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripzie/db/vm_wrapper.dart';

class SharedPrefWrapper extends VMWrapper {
  static final SharedPrefWrapper instance = new SharedPrefWrapper();

  void saveOnGoingRide(String ride_id) {
    saveData('on_going_rides', ride_id);
  }

  Future<String> getOnGoingRide() async {
    var jsonData = await getJsonData('on_going_rides');
    if (jsonData != null) {
      return jsonData as String;
    }
    return '';
  }

  saveBgNotification(Map<String, dynamic> data) async {
    await saveData('notification_details', data);
  }

  Future<Map<String, dynamic>> getBgNotification() async {
    var jsonData = await getJsonData('notification_details');
    if (jsonData != null) {
      return jsonData;
    }
    return {};
  }

  void clearNotificationDetails() async {
    print('clearNotificationDetails');
    saveData('notification_details', null);
  }

  getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString('_id');
  }

  saveUser(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('_id', userId);
  }

  deleteUser() async {
    await saveData(
      '_id',
      '',
    );
  }
}
