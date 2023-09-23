import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripzie/ui/main/map/tripit_map_ui.dart';
import 'package:tripzie/ui/main/rides/create_new_ride_screen.dart';
import 'package:tripzie/utils/ui_utils.dart';

import '../../../utils/map_utils.dart';
import '../../../widgets/tripzie_button.dart';
import 'TripziePlacesSearchTextFiled.dart';

class MarkMapUI {
  String title = '';
  Places? place;
  MarkMapUI(this.title, {this.place});

  String getText() {
    return title;
  }

  @override
  String toString() {
    return "Title: $title";
  }
}

class TripzieMarkOnMap extends StatefulWidget {
  static const String PAGE_NAME = "/trippit_mark_on_map";
  NewRideObject newride;
  TripzieMarkOnMap(this.newride);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TripzieMarkOnMap> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set();
  Position? currentLocation;
  var source = MarkMapUI("Enter Source");
  var destination = MarkMapUI("Enter Destination");
  late MarkMapUI selectedOption;
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
    source = MarkMapUI("Enter Source", place: widget.newride.source);
    destination =
        MarkMapUI("Enter Destination", place: widget.newride.destination);
    if (source.place != null) {
      selectedOption = destination;
    } else {
      selectedOption = source;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
        ),
        GoogleMap(
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            mapType: MapType.terrain,
            markers: markers,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
                target: currentLocation == null
                    ? const LatLng(
                        12.9716,
                        77.5946,
                      )
                    : LatLng(
                        currentLocation!.latitude, currentLocation!.longitude),
                zoom: 16),
            onCameraIdle: () async {
              var controller = await _controller.future;

              LatLngBounds bounds = await controller.getVisibleRegion();
              final lon =
                  (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
              final lat =
                  (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
              print("selected lat: $lat, long: $lon");

              setState(() {
                selectedOption.place = Places("", lat, lon);
              });
            }),
        Wrap(
          children: [
            Card(
              child: Container(
                alignment: Alignment.center,
                padding:
                    EdgeInsets.only(top: 50, left: 10, right: 10, bottom: 20),
                child: getSourceDestinationUI(
                    selectedOption, source, destination, (selected) async {
                  if (selectedOption == selected) {
                    print("selected loc : ${selected.place}");
                    selected.place!.name = selected.title;
                    var selectedOptionFromPlaces = await Navigator.pushNamed(
                        context, TripziePlacesSearchTextField.PAGE_NAME,
                        arguments: selected) as Places;

                    if (selectedOptionFromPlaces != null &&
                        selectedOptionFromPlaces.name != null) {
                      selectedOption.place = selectedOptionFromPlaces;
                      selectedOption.title = selectedOptionFromPlaces.name!;
                      this.selectedOption = selected;
                      updateMarkers();
                      print(
                          "selected loc from search: ${selectedOptionFromPlaces}");
                    } else {
                      showSnackBar(context, "Cannot update Selected Place");
                    }
                  }
                  setState(() {
                    selectedOption = selected;
                  });
                }),
              ),
            )
          ],
        ),
        Center(
            child: Icon(
          Icons.location_on_rounded,
          size: 30,
        )),
        Container(
          margin: EdgeInsets.only(bottom: 50),
          alignment: Alignment.bottomCenter,
          child: TripzieButton(
            button_text: "Done",
            onPressed: () {
              widget.newride.source = source.place;
              widget.newride.destination = destination.place;
              print("source: ${widget.newride.source!}");
              print("source: ${widget.newride.destination!}");
              // Navigator.pop(context, widget.newride);
            },
          ),
        )
      ],
    );
  }

  /*void getUserCurrentLocationUpdateUi() async {
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
*/
  void updateMarkers() async {
    markers.clear();
    if (source.place != null) {
      var marker = Marker(
        markerId: MarkerId(source.place!.name!),
        position: LatLng(source.place!.lat!, source.place!.lng!),
        infoWindow: InfoWindow(title: source.place!.name!),
      );
      markers.add(marker);
    }
    if (destination.place != null) {
      var marker = Marker(
        markerId: MarkerId(destination.place!.name!),
        position: LatLng(destination.place!.lat!, destination.place!.lng!),
        infoWindow: InfoWindow(title: destination.place!.name!),
      );
      markers.add(marker);
    }
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newLatLngBounds(
      MapUtils.boundsFromLatLngList(markers),
      100.0,
    ));
    setState(() {});
  }
}
