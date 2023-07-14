import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tripzie/ui/main/bottom_navbar_screen.dart';
import 'package:tripzie/utils/trippit_assets.dart';
import 'package:tripzie/utils/trppit_color.dart';

import '../../../auth/authentication.dart';

class ProfileScreen extends TripzieBottomNavBarScreen {
  static const PAGE_NAME = 'profile_screen';
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var list = [
    {'title': 'Edit Profile', 'image': ic_edit_profile},
    {'title': 'Address', 'image': ic_address},
    {'title': 'Wishlist', 'image': ic_wishlist},
    {'title': 'Notification', 'image': ic_notification},
    {'title': 'Payment Settings', 'image': ic_payment_setting},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              height: 50,
              alignment: Alignment.center,
              child: Text("Profile"),
            ),
            const SizedBox(
              width: 30,
            ),
            _getProfileIconCircle(),
            const SizedBox(
              height: 10,
            ),
            Text.rich(
              TextSpan(
                text: '${Authentication.getName()}',
                style: const TextStyle(
                    color: accent_color,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                children: <TextSpan>[
                  TextSpan(
                      text: '\n\n${Authentication.getEmail()}',
                      style: const TextStyle(
                          color: accent_color,
                          fontSize: 13,
                          fontWeight: FontWeight.normal)),
                  TextSpan(
                      text: '\n${Authentication.getPhoneNumber()}',
                      style: const TextStyle(
                          color: accent_color,
                          fontSize: 13,
                          fontWeight: FontWeight.normal))
                ],
              ),
              textAlign: TextAlign.center,
              style: TextStyle(height: 0.6),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  return Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {
                        print("clicked $i");
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            child: SvgPicture.asset(list[i]['image']!),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          Expanded(child: Text(list[i]['title']!)),
                          Padding(
                            child: SvgPicture.asset(ic_riight_arrow),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _getProfileIconCircle() {
    if (Authentication.getUser().photoURL != null &&
        Authentication.getUser().photoURL!.isNotEmpty) {
      return Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: accent_color,
          image: DecorationImage(
            image: NetworkImage(Authentication.getImageUri()),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(60.0)),
          border: Border.all(
            color: accent_color,
            width: 4.0,
          ),
        ),
      );
    } else {
      return Container(
        width: 70.0,
        height: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        child: SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.fill,
            child: Icon(Icons.person),
          ),
        ),
      );
    }
  }
}
