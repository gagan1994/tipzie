import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tripzie/socket/socket_wrapper.dart';
import 'package:tripzie/ui/main/bottom_navbar_screen.dart';
import 'package:tripzie/ui/main/home/home_screen.dart';
import 'package:tripzie/ui/main/profile/edit_profile.dart';
import 'package:tripzie/ui/main/wallet/wallet_screen.dart';

import '../../auth/authentication.dart';
import '../../utils/trippit_assets.dart';
import '../../utils/trppit_color.dart';
import '../../utils/ui_utils.dart';
import 'fab_with_icons.dart';
import 'rides/create_new_ride_screen.dart';
import 'rides/ride_screen.dart';

class MainScreen extends StatefulWidget {
  static const PAGE_NAME = "/main_screen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late List<TripzieBottomNavBarScreen> bottom_screens;
  late TabController _controller;
  var current_index = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 3);
    WidgetsBinding.instance?.addObserver(this);
    initAll();
    bottom_screens = [
      HomeScreen(),
      RideScreen(),
      WalletScreen(),
      WalletScreen()
    ];
    _controller.addListener(() {
      setState(() {
        print("Log listener");
      });
    });
    checkIdWeNeedUserUpdate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        color: Colors.white,
        child: Stack(
          children: [
            bottom_screens[current_index],
            Positioned(
              bottom: 60,
              right: 20,
              child: _buildPlay(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: current_index,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: selected_item_color,
            unselectedItemColor: not_selected_item_color,
            onTap: (index) {
              setState(() {
                current_index = index;
              });
            },
            selectedLabelStyle: TextStyle(fontSize: 12),
            unselectedLabelStyle: TextStyle(fontSize: 10),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: _getBottomIcon(0, ic_home),
                  label: "Home",
                  tooltip: "Home"),
              BottomNavigationBarItem(
                  icon: _getBottomIcon(1, ic_rides),
                  label: "Rides",
                  tooltip: "Rides"),
              BottomNavigationBarItem(
                  icon: _getBottomIcon(2, ic_wallet),
                  label: "Wallet",
                  tooltip: "Wallet"),
              BottomNavigationBarItem(
                  icon: _getBottomIcon(3, ic_profile),
                  label: "Social",
                  tooltip: "Social"),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('lifcycleState $state');
    if (state == AppLifecycleState.resumed) {
      checkAndOpenNotification(context);
    }
  }

  _getBottomIcon(int index, String ic_home) {
    return SvgPicture.asset(
      ic_home,
      color: current_index == index
          ? selected_item_color
          : not_selected_item_color,
      height: current_index == index ? 23 : 20,
      width: current_index == index ? 23 : 20,
    );
  }

  Widget _buildFab(BuildContext context) {
    final icons = [Icons.logout_outlined];
    return FabWithIcons(
      icons: icons,
      onIconTapped: (index) {
        switch (index) {
          case 0:
            Authentication.logout(context);
        }
      },
    );
  }

  Widget _buildPlay(BuildContext context) {
    if (current_index == 1) {
      return FloatingActionButton.extended(
        onPressed: () async {
          onFabButtonClick(current_index);
        },
        label: Text(current_index == 0 ? 'Current Rides' : 'Create Rides'),
        backgroundColor: accent_color,
      );
    }
    return SizedBox();
  }

  void initAll() async {
    SocketWrapper.instance.setUser(Authentication.loggedInUser);
  }

  void onFabButtonClick(int current_index) async {
    if (current_index == 1) {
      Navigator.pushNamed(context, CreateNewRideScreen.PAGE_NAME);
    }
  }

  void checkIdWeNeedUserUpdate() async {
    if (Authentication.loggedInUser!.firstName!.isEmpty ||
        Authentication.loggedInUser!.phoneNumber!.isEmpty) {
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushNamed(context, EditProfileScreen.PAGE_NAME);
    }
  }
}
