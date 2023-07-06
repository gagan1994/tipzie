import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripzie/auth/authentication.dart';
import 'package:tripzie/socket/models/models.dart';

class MapUtils {
  static String? getInfoWindow(LiveLocationModel model) {
    if (Authentication.isCurrentUser(model.userId)) {
      return "You";
    }
    return model.userName == null ? model.phoneNumber : model.userName;
  }

  static Future<Uint8List> getMarkerImage(String photoURL) async {
    final File markerImageFile =
        await DefaultCacheManager().getSingleFile(photoURL);
    final Uint8List markerImageBytes = await markerImageFile.readAsBytes();

    ui.Codec codec =
        await ui.instantiateImageCodec(markerImageBytes, targetWidth: 50);
    ui.FrameInfo fi = await codec.getNextFrame();

    final Uint8List markerImage =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();

    return markerImage;
  }

  static LatLngBounds boundsFromLatLngList(Set<Marker> list) {
    double? x0, x1, y0, y1;
    for (Marker latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.position.latitude;
        y0 = y1 = latLng.position.longitude;
      } else {
        if (latLng.position.latitude > x1!) x1 = latLng.position.latitude;
        if (latLng.position.latitude < x0) x0 = latLng.position.latitude;
        if (latLng.position.longitude > y1!) y1 = latLng.position.longitude;
        if (latLng.position.longitude < y0!) y0 = latLng.position.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }
}
