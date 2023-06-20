import 'package:flutter/material.dart';

import 'current_ride_tile.dart';

class CurrentRideList extends StatelessWidget {
  ScrollController sc;
  CurrentRideList(this.sc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalItem = 20;
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider();
        },
        controller: sc,
        shrinkWrap: true,
        itemCount: totalItem,
        itemBuilder: (context, index) {
          return CurrentRideTile(isAway: index % 2 == 0,);
        },
      ),
    );
  }
}
