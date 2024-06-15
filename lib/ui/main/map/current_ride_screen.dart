import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:tripzie/api/api_wrapper.dart';
import 'package:tripzie/auth/authentication.dart';
import 'package:tripzie/socket/socket_wrapper.dart';
import 'package:tripzie/ui/main/map/assistant_helper.dart';
import 'package:tripzie/ui/user_avatar.dart';
import 'package:tripzie/utils/trppit_color.dart';
import 'package:tripzie/utils/ui_utils.dart';

import '../../../api/ride.dart';
import '../../../utils/trippit_assets.dart';
import 'map_screen.dart';

class CurrentRideScreen extends StatefulWidget {
  static const PAGE_NAME = 'current_rides_screen';
  Ride ride;
  CurrentRideScreen(this.ride, {Key? key}) : super(key: key);

  @override
  State<CurrentRideScreen> createState() => _CurrentRideScreenState();
}

class _CurrentRideScreenState extends State<CurrentRideScreen> {
  bool isVolumeSelected = false;
  bool isFinished = false;
  bool isAssistantInProgress = false;
  bool isMicSelected = false;
  AssistantHelper assistantHelper = AssistantHelper();
  Set<String> muteUsers = Set();
  List<dynamic> activeUserId = [];
  @override
  void initState() {
    checkAndInitSocket();
    assistantHelper.initSpeechState(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    SocketWrapper.instance.cleanup();
    SocketWrapper.instance.userInRoom().close();
    assistantHelper.dispose();
    super.dispose();
  }

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
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        color: accent_color,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(
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
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getIcon(Icons.volume_down_rounded, isVolumeSelected, () {
                    setState(() {
                      isVolumeSelected = !isVolumeSelected;
                    });
                  }),
                  _getIcon(Icons.mic_off, !isMicSelected, () {
                    setState(() {
                      isMicSelected = !isMicSelected;
                    });
                  }),
                  _getAssistant(),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.ride.selectedUsers!.length + 1,
                  itemBuilder: (context, index) =>
                      _buildListItems(context, index),
                ),
              ),
            ],
          ),
          if (widget.ride.isCreatedByCurrentUser())
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  width: MediaQuery.of(context).size.width,
                  child: SwipeableButtonView(
                    buttonColor: Colors.transparent,
                    buttontextstyle: TextStyle(color: accent_color),
                    indicatorColor: AlwaysStoppedAnimation(Colors.transparent),
                    buttonText: '      Slide to Complete ride',
                    buttonWidget: Image(
                      image: AssetImage(logo_image),
                      width: 50,
                      height: 50,
                    ),
                    activeColor: Colors.white,
                    isFinished: isFinished,
                    onWaitingProcess: () {
                      setState(() {
                        isFinished = true;
                      });
                    },
                    onFinish: () async {
                      var isCompleteRide =
                          await completeRide(widget.ride.getId());
                      if (isCompleteRide) {
                        Navigator.pop(context, true);
                      }
                      isFinished = false;
                      setState(() {});
                    },
                  ),
                ))
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
        padding: const EdgeInsets.all(10.0),
      ),
    );
  }

  _backgroundWidget() {
    return TripzieMap(widget.ride);
  }

  _getAssistant() {
    return GestureDetector(
      onTap: onAssistantClicked,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: assistantHelper.isListening() ? accent_color_light : null),
        padding: const EdgeInsets.all(10.0),
        child: SvgPicture.asset(ic_google_assistant,
            width: 20,
            height: 20,
            color: assistantHelper.isInit ? null : accent_color_light),
      ),
    );
  }

  onAssistantClicked() async {
    if (assistantHelper.isListening()) {
      return;
    }
    assistantHelper.startListening(eventCallback);
    setState(() {});
  }

  void eventCallback(VoiceEvents event) {
    switch (event) {
      case VoiceEvents.MUTE:
        isMicSelected = true;
        break;
      case VoiceEvents.UNMUTE:
        isMicSelected = false;
        break;
      case VoiceEvents.SPEAKER_MODE_OF:
        isVolumeSelected = false;
        break;
      case VoiceEvents.SPEAKER_MODE_ON:
        isVolumeSelected = true;
        break;
    }
    setState(() {});
  }

  void checkAndInitSocket() {
    print("Check and init socket: ${SocketWrapper.instance.isInit}");
    if (!SocketWrapper.instance.isInit) {
      SocketWrapper.initSocket(widget.ride);
      SocketWrapper.instance.userInRoom().stream.listen((event) {
        print("user joined event: - $event");

        setState(() {
          activeUserId.clear();
          activeUserId.addAll(event);
        });
      });
    }
  }

  _buildListItems(BuildContext context, int index) {
    if (index == 0) {
      return ListTile(
        leading: Container(
          padding: const EdgeInsets.only(left: 7, right: 5, top: 5, bottom: 5),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: accent_color_light,
          ),
          child: const Icon(
            Icons.person_add_alt_1_rounded,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Add User",
          style: TextStyle(color: Colors.white),
        ),
      );
    }
    var userProfile = widget.ride.selectedUsers![index - 1];
    if (userProfile.userId == Authentication.loggedInUser!.userId) {
      return SizedBox();
    }
    Widget tail;
    if (activeUserId.contains(userProfile.userId)) {
      tail = Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: muteUsers.contains(userProfile.userId)
              ? Colors.white
              : Colors.transparent,
        ),
        child: Icon(Icons.mic_off,
            color: (muteUsers.contains(userProfile.userId) &&
                    widget.ride.isCreatedByCurrentUser())
                ? accent_color
                : Colors.white),
      );
    } else {
      tail = Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.cloud_off, color: Colors.white54));
    }
    return ListTile(
      leading: UserAvatar(
        imageUrl: userProfile.imageUri,
        radius: 35,
      ),
      title: Text(
        userProfile.firstName!,
        style: const TextStyle(color: Colors.white),
      ),
      trailing: GestureDetector(
        onTap: () {
          if (widget.ride.isCreatedByCurrentUser()) {
            String text = "";
            if (muteUsers.contains(userProfile.userId)) {
              muteUsers.remove(userProfile.userId);
              text = "Un-mute ${userProfile.firstName}";
            } else {
              text = "Mute ${userProfile.firstName}";
              muteUsers.add(userProfile.userId!);
            }
            showSnackBar(context, text);
            setState(() {});
          }
        },
        child: tail,
      ),
    );
  }
}
