import 'dart:collection';

import '../ui/main/map/tripit_map_ui.dart';

class RideItems {
  Places? source;
  Places? destination;
  DateTime? startDate;
  DateTime? endDate;
  Map<String, String> selectedUsers = new HashMap();

  String? name;
}
