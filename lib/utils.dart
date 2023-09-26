import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

const String app_name = "Tripzie";
// icon: i == 2 ? BitmapDescriptor.fromBytes(markerImageBytes): BitmapDescriptor.defaultMarker,

LatLngBounds boundsFromLatLngList(List<LatLng> list) {
  double x0 = 0, x1 = 0, y0 = 0, y1 = 0;
  for (LatLng latLng in list) {
    if (x0 == 0) {
      x0 = x1 = latLng.latitude;
      y0 = y1 = latLng.longitude;
    } else {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
  }
  return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
}

String dateFormat(DateTime date) {
  if (date.year == DateTime.now().year) {
    final result = DateFormat('E d, MMM').format(date);
    return result;
  } else {
    final result = DateFormat('E d, MMM, y').format(date);
    return result;
  }
}

String dateFormat2(DateTime src, DateTime dest) {
  final src1 = DateFormat('hh:mm a').format(src);
  final destn = DateFormat('hh:mm a').format(dest);
  return '$src1 - $destn';
}
