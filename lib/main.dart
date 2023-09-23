import 'dart:async';

import 'package:background_locator_2/location_dto.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tripzie/ui/login/login_page_1.dart';
import 'package:tripzie/ui/login/login_screen.dart';
import 'package:tripzie/ui/login/verify_otp_screen.dart';
import 'package:tripzie/ui/main/discovery/disovery_details_screen.dart';
import 'package:tripzie/ui/main/map/TripziePlacesSearchTextFiled.dart';
import 'package:tripzie/ui/main/map/select_places_on_map.dart';
import 'package:tripzie/ui/main/map/tripzie_places_search.dart';
import 'package:tripzie/ui/main/profile/edit_profile.dart';
import 'package:tripzie/ui/main/profile/profile_screen.dart';
import 'package:tripzie/ui/main/rides/create_new_ride_screen.dart';
import 'package:tripzie/ui/main/rides/ride_details.dart';
import 'package:tripzie/ui/test_ui.dart';
import 'package:tripzie/utils/ui_utils.dart';

import 'api/ride.dart';
import 'auth/authentication.dart';
import 'background_task/location_service_repository.dart';
import 'ui/main/discovery/models.dart';
import 'ui/main/main_screen.dart';
import 'ui/main/map/current_ride_screen.dart';
import 'ui/splash_screen.dart';

@pragma('vm:entry-point')
class LocationCallbackHandler {
  @pragma('vm:entry-point')
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();
    await myLocationCallbackRepository.init(params);
  }

  @pragma('vm:entry-point')
  static Future<void> disposeCallback() async {
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();
    await myLocationCallbackRepository.dispose();
  }

  @pragma('vm:entry-point')
  static Future<void> callback(LocationDto locationDto) async {
    LocationServiceRepository myLocationCallbackRepository =
        LocationServiceRepository();
    await myLocationCallbackRepository.callback(locationDto);
  }

  @pragma('vm:entry-point')
  static Future<void> notificationCallback() async {
    print('***notificationCallback');
  }
}

void main() {
  runApp(MyApp());
  Authentication.initializeFirebase();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: SplashPage.PAGE_NAME,
      theme: ThemeData(
        fontFamily: getFontStyle(),
      ),
      navigatorKey: navigatorKey,
      onGenerateRoute: (settings) {
        print("Changing page request: ${settings.name}");
        switch (settings.name) {
          case SplashPage.PAGE_NAME:
            return fadeTransition(SplashPage());
          case MainScreen.PAGE_NAME:
            return rightToLeftTransition(MainScreen());
          case LoginPage.PAGE_NAME:
            return rightToLeftTransition(LoginPage());
          case LoginPage1.PAGE_NAME:
            return fadeTransition(LoginPage1());
          case VerifyOTP.PAGE_NAME:
            final phone = settings.arguments as PhoneNumberDetails;
            return rightToLeftTransition(VerifyOTP(phone));
          case CreateNewRideScreen.PAGE_NAME:
            return rightToLeftTransition(CreateNewRideScreen());
          case DiscoveryDetailsScreen.PAGE_NAME:
            final discoveryItem = settings.arguments as DiscoveryListItem;
            return bottomToTop(DiscoveryDetailsScreen(discoveryItem));
          case RideDetailsScreen.PAGE_NAME:
            final rideItem = settings.arguments as Ride;
            return bottomToTop(RideDetailsScreen(rideItem));
          case CurrentRideScreen.PAGE_NAME:
            final currentRide = settings.arguments as Ride;
            return bottomToTop(CurrentRideScreen(currentRide));
          case ProfileScreen.PAGE_NAME:
            return transition(ProfileScreen(), PageTransitionType.leftToRight);
          case TripziePlacesSearch.PAGE_NAME:
            MarkMapUI selectedOption = settings.arguments as MarkMapUI;
            return transition(
                TripziePlacesSearch(selectedOption), PageTransitionType.fade);
          case TripziePlacesSearchTextField.PAGE_NAME:
            MarkMapUI selectedOption = settings.arguments as MarkMapUI;
            return transition(TripziePlacesSearchTextField(selectedOption),
                PageTransitionType.fade);
          case EditProfileScreen.PAGE_NAME:
            return transition(EditProfileScreen(), PageTransitionType.fade);
          case TripzieMarkOnMap.PAGE_NAME:
            final newride = settings.arguments as NewRideObject;
            return transition(
                TripzieMarkOnMap(newride), PageTransitionType.fade);
          case TestUi.PAGE_NAME:
            Map<String, dynamic> newRide = Map<String, dynamic>();
            try {
              if (settings.arguments != null) {
                newRide = settings.arguments as Map<String, dynamic>;
              }
            } on Exception catch (error) {
              print(error);
            }
            return transition(TestUi(newRide), PageTransitionType.fade);
        }
      },
    );
  }

  PageTransition fadeTransition(StatefulWidget widget) {
    return PageTransition(
      child: widget,
      type: PageTransitionType.fade,
    );
  }

  PageTransition rightToLeftTransition(StatefulWidget widget) {
    return PageTransition(
      child: widget,
      type: PageTransitionType.rightToLeft,
    );
  }

  PageTransition transition(StatefulWidget widget, PageTransitionType type) {
    return PageTransition(
      child: widget,
      type: type,
    );
  }

  PageTransition bottomToTop(StatefulWidget widget) {
    return PageTransition(
      child: widget,
      type: PageTransitionType.bottomToTop,
    );
  }
}
