import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripzie/ui/main/map/select_places_on_map.dart';
import 'package:tripzie/ui/main/map/tripit_map_ui.dart';

import '../../../widgets/tripzie_button.dart';

class TripziePlacesSearchTextField extends StatefulWidget {
  static const PAGE_NAME = "/places_search_text_field";
  MarkMapUI selectedPlace;
  TripziePlacesSearchTextField(this.selectedPlace, {Key? key})
      : super(key: key);

  @override
  State<TripziePlacesSearchTextField> createState() =>
      _TripziePlacesSearchTextFieldState();
}

class _TripziePlacesSearchTextFieldState
    extends State<TripziePlacesSearchTextField> {
  TextEditingController controller = TextEditingController();
  List<SearchInfo> suggestions = [];
  bool isShowList = false;

  Position? currentLocation;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set();
  Places? selectedPlace;
  @override
  void initState() {
    print("widget.selectedPlace.place: ${widget.selectedPlace.place}");
    if (widget.selectedPlace.place == null) {
      getUserCurrentLocationUpdateUi();
    } else {
      selectedPlace = widget.selectedPlace.place!;
    }
    updateMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                          12.9716,
                          77.5946,
                        )
                      : LatLng(currentLocation!.latitude,
                          currentLocation!.longitude),
                  zoom: 16),
              onCameraIdle: () async {
                var controller = await _controller.future;

                LatLngBounds bounds = await controller.getVisibleRegion();
                final lon =
                    (bounds.northeast.longitude + bounds.southwest.longitude) /
                        2;
                final lat =
                    (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
                print("selected lat: $lat, long: $lon");

                setState(() {
                  selectedPlace = Places(selectedPlace!.name, lat, lon);
                });
              }),
          Container(
            color: Colors.white,
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            child: Autocomplete<SearchInfo>(
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                var hinText = "Search Places";
                if (selectedPlace != null &&
                    selectedPlace!.name != null &&
                    selectedPlace!.name!.isNotEmpty) {
                  hinText = selectedPlace!.name!;
                }
                return Container(
                  height: 40,
                  padding: EdgeInsets.only(left: 20),
                  color: Colors.white,
                  child: TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    style: TextStyle(fontSize: 10),
                    decoration: InputDecoration(
                      hintText: hinText,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                  ),
                );
              },
              displayStringForOption: (SearchInfo option) =>
                  option.address!.name!,
              optionsBuilder: (TextEditingValue textEditingValue) async {
                if (textEditingValue.text == '') {
                  return const Iterable<SearchInfo>.empty();
                }
                return await addressSuggestion(textEditingValue.text);
              },
              onSelected: (SearchInfo selection) async {
                selectedPlace = Places(selection.address!.name!,
                    selection.point!.latitude, selection.point!.longitude);
                updateMarkers();
              },
            ),
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
                widget.selectedPlace.place = selectedPlace;
                Navigator.pop(context, selectedPlace);
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    suggestions = [];
    super.dispose();
  }

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

  void getUserCurrentLocationUpdateUi() async {
    currentLocation = await getUserCurrentLocation();
    selectedPlace = Places(
        "Your Location", currentLocation!.latitude, currentLocation!.longitude);
    updateMarkers();
  }

  updateMarkers() async {
    final GoogleMapController controller = await _controller.future;
    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(selectedPlace!.lat!, selectedPlace!.lng!),
      zoom: 16,
    );
    controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {});
  }
}
