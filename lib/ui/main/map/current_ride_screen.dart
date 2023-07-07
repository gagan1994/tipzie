import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tripzie/utils/trppit_color.dart';

import '../../../utils/trippit_assets.dart';
import 'map_screen.dart';

class CurrentRideScreen extends StatefulWidget {
  static const PAGE_NAME = 'current_rides_screen';
  CurrentRideScreen({Key? key}) : super(key: key);

  @override
  State<CurrentRideScreen> createState() => _CurrentRideScreenState();
}

class _CurrentRideScreenState extends State<CurrentRideScreen> {
  bool isVolumeDown = false;
  bool isAssistantInProgress = false;
  bool isMicOff = false;
  bool isSpeaking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        color: Colors.transparent,
        panel: _previewWidget(),
        body: _backgroundWidget(),
      ),
    );
  }

  _previewWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        color: accent_color,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Container(
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: accent_color_light,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getIcon(Icons.volume_down_rounded, isVolumeDown, () {
                setState(() {
                  isVolumeDown = !isVolumeDown;
                });
              }),
              _getIcon(Icons.mic_off, isMicOff, () {
                setState(() {
                  isMicOff = !isMicOff;
                });
              }),
              _getAssistant(),
            ],
          )
        ],
      ),
    );
  }

  _getIcon(IconData iconData, bool isSelected, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Icon(
          iconData,
          size: 30.0,
          color: isSelected ? accent_color : Colors.white,
        ),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.white : accent_color),
        padding: EdgeInsets.all(10.0),
      ),
    );
  }

  _backgroundWidget() {
    return TripzieMap();
  }

  _getAssistant() {
    return GestureDetector(
      onTap: onAssistantClicked,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSpeaking ? accent_color_light : Colors.transparent),
        padding: EdgeInsets.all(10.0),
        child: SvgPicture.asset(
          ic_google_assistant,
          width: 20,
          height: 20,
        ),
      ),
    );
  }

  onAssistantClicked() {
    if (isSpeaking) {
      return;
    }
    setState(() {
      isSpeaking = true;
    });
  }
}
