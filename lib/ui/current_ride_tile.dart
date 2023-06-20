import 'package:flutter/material.dart';
import 'package:tripzie/ui/user_avatar.dart';

class CurrentRideTile extends StatelessWidget {
  var isAway ;
  CurrentRideTile({Key? key, @required this.isAway}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.all(10), child: UserAvatar()),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name"),
              Text("5min Away | 3kms"),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.topCenter,
            child: Icon(
              Icons.circle,
              color: isAway ? Colors.redAccent : Colors.greenAccent,
            ))
      ],
    );
  }
}
