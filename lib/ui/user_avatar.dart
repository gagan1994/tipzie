import 'package:flutter/material.dart';

import '../utils/trppit_color.dart';

class UserAvatar extends StatelessWidget {
  String? imageUrl =
      "https://newprofilepic2.photo-cdn.net//assets/images/article/profile.jpg";
  UserAvatar({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: Container(
        width: 30.0,
        height: 30.0,
        decoration: BoxDecoration(
          color: accent_color,
          image: DecorationImage(
            image: NetworkImage((imageUrl == null
                ? "https://newprofilepic2.photo-cdn.net//assets/images/article/profile.jpg"
                : imageUrl!)),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(60.0)),
        ),
      ),
    );
  }
}
