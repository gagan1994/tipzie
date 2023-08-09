import 'package:flutter/material.dart';
import 'package:tripzie/ui/main/map/select_places_on_map.dart';

import '../../../utils/trppit_color.dart';

class Places {
  String name;
  double lat;
  double lng;
  Places(this.name, this.lat, this.lng);
}

Widget getSourceDestinationUI(MarkMapUI? selectedOption, MarkMapUI source,
    MarkMapUI destination, Function(MarkMapUI) callback,
    [top = 55.00, shadow = Colors.white]) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      getSelectedMarkers(source, destination, selectedOption),
      SizedBox(
        width: 10,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getSourceEditText(source, callback),
          SizedBox(height: 10),
          getSourceEditText(destination, callback),
        ],
      )
    ],
  );
}

getSourceEditText(MarkMapUI mapUI, Function(MarkMapUI) callback) {
  return GestureDetector(
    onTap: () {
      if (mapUI != null) {
        callback(mapUI);
      }
    },
    child: Container(
      width: 250,
      height: 30,
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: edit_text_bg_color,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Text(
        mapUI.getText(),
        style: TextStyle(fontSize: 8),
      ),
    ),
  );
}

getSelectedMarkers(
    MarkMapUI source, MarkMapUI destination, MarkMapUI? selectedOption) {
  return Column(
    children: [
      Container(
        width: 7,
        height: 7,
        decoration:
            getDecoration(selectedOption == source, selectedOption == null),
      ),
      Container(
        color: selectedOption == null ? Colors.black : Colors.grey,
        width: 1,
        height: 30,
      ),
      Container(
        width: 7,
        height: 7,
        decoration: getDecoration(
            selectedOption == destination, selectedOption == null),
      ),
    ],
  );
}

getDecoration(bool isSelected, bool isShowSelectedAlways) {
  if (isShowSelectedAlways) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.black,
    );
  }
  return (!isSelected)
      ? BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.withOpacity(0.5),
        )
      : BoxDecoration(color: Colors.black);
}
