import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripzie/auth/authentication.dart';
import 'package:tripzie/socket/models/models.dart';
import 'package:tripzie/socket/socket_wrapper.dart';
import 'package:tripzie/utils/map_utils.dart';
import 'package:tripzie/utils/trppit_color.dart';

class TripzieMap extends StatefulWidget {
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
    SocketWrapper.instance.startListeningForLocationUpdates(addMarker);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
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
                : LatLng(currentLocation!.latitude, currentLocation!.longitude),
            zoom: 16));
  }

  Widget _currentUserMarker(LiveLocationModel model) {
    //'https://newprofilepic2.photo-cdn.net//assets/images/article/profile.jpg'
    return Container(
      width: 30,
      height: 30,
      child: ClipPolygon(
        sides: 6,
        borderRadius: 5.0, // Default 0.0 degrees
        boxShadows: [
          PolygonBoxShadow(color: Colors.black, elevation: 1.0),
          PolygonBoxShadow(color: Colors.grey, elevation: 5.0)
        ],
        child: (model.photoURL != null)
            ? Image.network(model.photoURL!)
            : Container(
                color: accent_color,
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                )),
      ),
    );
  }

  void getUserCurrentLocationUpdateUi() async {
    currentLocation = await getUserCurrentLocation();
    var currentMarker = LiveLocationModel.fromData(
        currentLocation!.latitude,
        currentLocation!.longitude,
        currentLocation!.altitude,
        currentLocation!.timestamp!.millisecond.toDouble(),
        Authentication.getUser());
    markers.clear();
    addMarker(currentMarker);
  }

  addMarker(LiveLocationModel model) async {
    var image = await MapUtils.getMarkerIcon(model.photoURL!, Size(75, 75));
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(model.latitude!, model.longitude!),
      zoom: 16,
    );
    final GoogleMapController controller = await _controller.future;
    var marker = Marker(
        markerId: MarkerId(model.userId!),
        position: LatLng(model.latitude!, model.longitude!),
        infoWindow: InfoWindow(title: MapUtils.getInfoWindow(model)),
        icon: BitmapDescriptor.fromBytes(image));
    markers.add(marker);
    if (Authentication.isCurrentUser(model.userId)) {
      controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
      controller.showMarkerInfoWindow(marker.markerId);
    } else {
      controller.moveCamera(CameraUpdate.newLatLngBounds(
        MapUtils.boundsFromLatLngList(markers),
        100.0,
      ));
    }
    setState(() {});
  }
}
