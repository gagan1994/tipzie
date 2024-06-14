import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripzie/api/ride.dart';
import 'package:tripzie/api/user_data.dart';
import 'package:tripzie/auth/authentication.dart';
import 'package:tripzie/db/users.dart';
import 'package:tripzie/socket/models/models.dart';
import 'package:tripzie/socket/socket_wrapper.dart';
import 'package:tripzie/utils/map_utils.dart';
import 'package:tripzie/utils/trppit_color.dart';

import '../../../background_task/background_location.dart';

class TripzieMap extends StatefulWidget {
  Ride ride;
  TripzieMap(this.ride);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TripzieMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set();
  Position? currentLocation;

  void _onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    getUserCurrentLocationUpdateUi();
    BackgroundLocationWrapper.instance.startLiveRide();
    SocketWrapper.instance.getLiveLocationStream().stream.listen((event) {
      addMarkerFromLocation(event);
    });
  }

  @override
  void dispose() {
    BackgroundLocationWrapper.instance.stopLocationService();
    SocketWrapper.instance.getLiveLocationStream().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            mapType: MapType.terrain,
            markers: markers,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
                target: currentLocation == null
                    ? const LatLng(
                        20.42796133580664,
                        80.885749655962,
                      )
                    : LatLng(
                        currentLocation!.latitude, currentLocation!.longitude),
                zoom: 16)),
        Positioned(
          right: 10,
          top: MediaQuery.of(context).viewPadding.top + 10,
          child: FloatingActionButton(
            backgroundColor: accent_color,
            onPressed: () {
              updateCamera();
            },
            child: Icon(Icons.center_focus_strong),
          ),
        )
      ],
    );
  }

  void getUserCurrentLocationUpdateUi() async {
    markers.clear();
    if (widget.ride.source != null) {
      var marker = Marker(
        markerId: MarkerId(widget.ride.source!.name!),
        position: LatLng(widget.ride.source!.lat!, widget.ride.source!.lng!),
        infoWindow: InfoWindow(title: widget.ride!.name!),
      );
      markers.add(marker);
    }
    if (widget.ride.destination != null) {
      var marker = Marker(
        markerId: MarkerId(widget.ride.destination!.name!),
        position: LatLng(
            widget.ride.destination!.lat!, widget.ride.destination!.lng!),
        infoWindow: InfoWindow(title: widget.ride.destination!.name!),
      );
      markers.add(marker);
    }
    updateCurrentLocation(true);
  }

  addMarker(LiveLocationModel model, bool isUpdateCameraPosition) async {
    print("model - > ${model.userId}");
    UserProfile? userData;
    for (var item in widget.ride.selectedUsers!) {
      print(item.userId);
      if (item.userId == model.userId) {
        userData = item;
        break;
      }
    }
    if (userData == null && model.userId == widget.ride.createdBy) {
      userData = allUsers[model.userId];
    }
    addUserMarker(model, userData, isUpdateCameraPosition);
  }

  void updateCurrentLocation(bool isUpdateCameraPosition) async {
    currentLocation = await getUserCurrentLocation();
    var currentMarker = LiveLocationModel.fromData(
        currentLocation!.latitude,
        currentLocation!.longitude,
        currentLocation!.altitude,
        currentLocation!.timestamp!.millisecond.toDouble(),
        Authentication.loggedInUser!);
    addUserMarker(
        currentMarker, Authentication.loggedInUser, isUpdateCameraPosition);
  }

  addMarkerFromLocation(LiveLocationModel model) {
    updateCurrentLocation(false);
    addMarker(model, false);
  }

  void updateCamera() async {
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newLatLngBounds(
      MapUtils.boundsFromLatLngList(markers),
      100.0,
    ));
  }

  void addUserMarker(LiveLocationModel model, UserProfile? userData,
      bool isUpdateCameraPosition) async {
    var image = await MapUtils.getMarkerIcon(userData!.imageUri!, Size(75, 75));

    var marker = Marker(
        markerId: MarkerId(model.userId!),
        position: LatLng(model.latitude!, model.longitude!),
        infoWindow: InfoWindow(title: MapUtils.getInfoWindow(userData!)),
        icon: BitmapDescriptor.fromBytes(image));
    markers.add(marker);

    // adding source and destination markers
    if (isUpdateCameraPosition) {
      updateCamera();
    }
    setState(() {});
  }
}
