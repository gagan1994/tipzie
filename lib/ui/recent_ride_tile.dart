import 'package:flutter/cupertino.dart';

import 'user_avatar.dart';

class RecentRideTile extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                UserAvatar(),
                Text("Banglore - GOA(500km) in 8hrs")
              ]
          ),
          SizedBox(
              height: 100,
              width: double.infinity,
              child: Image.network("https://i0.wp.com/travelogueofkuntala.com/wp-content/uploads/2020/08/Driving-Route.png?resize=624%2C395&ssl=1"
                ,fit: BoxFit.fill,
              ))
      ],
      ),
    );
  }

}