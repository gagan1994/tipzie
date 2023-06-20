import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: CircleAvatar(
        foregroundColor:Colors.transparent,
        backgroundColor: Colors.transparent,
        child: ClipOval(
            child:Image.network(
              "https://newprofilepic2.photo-cdn.net//assets/images/article/profile.jpg",
            )
        ),
      ),
    );
  }

}