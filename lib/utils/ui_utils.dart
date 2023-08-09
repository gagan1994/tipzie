import 'package:easy_loader/easy_loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tripzie/utils/trippit_assets.dart';
import 'package:tripzie/utils/trppit_color.dart';

import '../ui/main/rides/models.dart';

String? getFontStyle() {
  return GoogleFonts.montserratAlternates().fontFamily;
}

Widget showProgress(bool isInProgress) {
  if (isInProgress) {
    return const EasyLoader(
      image: AssetImage(logo_image),
      iconSize: 50,
    );
  }
  return SizedBox();
}

verticalDivider([Color color = Colors.transparent]) {
  return Container(
    height: 10,
    color: color,
  );
}

horizontalDivider() {
  return SizedBox(
    width: 10,
  );
}

SnackBar customSnackBar({required String content}) {
  return SnackBar(
    backgroundColor: Colors.black,
    content: Text(
      content,
      style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
    ),
  );
}

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.white, letterSpacing: 0.5),
      )));
}

Widget rideDetails(RideListItem item) {
  return ListTile(
    leading: CircleAvatar(
      backgroundImage: NetworkImage(item.imageUri.isEmpty
          ? "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
          : item.imageUri),
    ),
    title: Text(
      item.name,
      overflow: TextOverflow.ellipsis,
    ),
    trailing: Container(
      height: 50,
      width: 100,
      alignment: Alignment.centerRight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (item.isAvailable)
            const Text(
              "Active",
              style: TextStyle(fontSize: 10),
            ),
          if (item.isAvailable)
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 2),
                child: CircleAvatar(radius: 5, backgroundColor: Colors.green)),
          if (!item.isAvailable)
            Text(
              timeAgo(item.lastSeen),
              style: const TextStyle(fontSize: 10),
            ),
        ],
      ),
    ),
  );
}

Widget rideDetails_2(RideListItem item) {
  return Container(
    color: Colors.white,
    child: ListTile(
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(item.imageUri.isEmpty
            ? "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"
            : item.imageUri),
      ),
      title: buildItem(text: item.name, text2: item.despription),
      trailing: Icon(
        Icons.arrow_forward_ios_outlined,
        color: accent_color,
      ),
    ),
  );
}

Widget rideDetails_3(RideListItem item) {
  return Column(
    children: [
      Container(
        height: 50,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            image: NetworkImage(item.imageUri),
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Text(item.name),
    ],
  );
}

Text buildItem({
  required String text,
  required String text2,
}) {
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: text,
          style: TextStyle(
            color: accent_color,
            fontSize: 18.0,
          ),
        ),
        TextSpan(
          text: "\n" + text2,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12.0,
          ),
        ),
      ],
    ),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.start,
  );
}

Widget getFilter_1Widget(List<String> listOfFilter1,
    Function(int) selectedIndexCall, currentSelectedIndex) {
  return ListView.builder(
    itemCount: listOfFilter1.length,
    scrollDirection: Axis.horizontal,
    itemBuilder: (BuildContext context, int index) {
      return GestureDetector(
        onTap: () {
          selectedIndexCall(index);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: index == currentSelectedIndex
                  ? notif_selected_bg_color
                  : divider_color),
          child: Text(
            "${listOfFilter1[index]}",
            style: TextStyle(
                color: currentSelectedIndex == index
                    ? Colors.white
                    : not_selected_item_color),
          ),
        ),
      );
    },
  );
}

Widget getDatePickerSingleLine(
  DateTime start,
  DateTime end, [
  double fontsize = 8.0,
]) {
  var noOfDays = end.difference(start).inDays + 6;
  var listStartDate = start.subtract(Duration(days: 2));

  return ListView.builder(
      itemCount: noOfDays,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        DateTime indexDate = listStartDate.add(Duration(days: index));
        var isSelectedDate = isSameDay(start, indexDate);
        if (!isSelectedDate) {
          isSelectedDate = isSameDay(end, indexDate);
        }
        bool isDateInBtw = false;
        if (start.isBefore(indexDate) && end.isAfter(indexDate)) {
          isDateInBtw = true;
        }
        return Container(
          color: isDateInBtw || isSelectedDate
              ? selected_date_color
              : Colors.white,
          child: Container(
            width: 45,
            alignment: Alignment.center,
            height: 30,
            decoration: !isSelectedDate
                ? BoxDecoration()
                : BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: notif_selected_bg_color,
                  ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${indexDate.day}",
                  style: TextStyle(
                      color: !isSelectedDate ? accent_color : Colors.white,
                      fontSize: fontsize),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "${DateFormat('EE').format(indexDate)}",
                  style: TextStyle(
                      color: !isSelectedDate ? accent_color : Colors.white,
                      fontSize: fontsize),
                ),
                SizedBox(
                  height: 5,
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: CircleAvatar(
                      radius: 2,
                      backgroundColor: Colors.white,
                    ))
              ],
            ),
          ),
        );
      });
}

bool isSameDay(DateTime d1, DateTime d2) {
  return d1.day == d2.day && d1.month == d2.month && d1.year == d2.year;
}
