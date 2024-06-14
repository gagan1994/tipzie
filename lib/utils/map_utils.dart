import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image/image.dart';
import 'package:tripzie/auth/authentication.dart';
import 'package:tripzie/ui/main/map/tripzie_places_search.dart';

import '../api/user_data.dart';

class MapUtils {
  static String? getInfoWindow(UserProfile model) {
    if (Authentication.isCurrentUser(model.userId)) {
      return "You";
    }
    return model.firstName == null ? model.phoneNumber : model.firstName;
  }

  static const kGoogleApiKey = "AIzaSyATbnH2M_82lBfpUtxJNq-ngQxqkpCXCpI";

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

  static Future<Uint8List> getMarkerIcon(String imagePath, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final double shadowWidth = 2.0;

    final Paint borderPaint = Paint()..color = Colors.transparent;
    final double borderWidth = 2.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add image
    ui.Image image = await getImageFromPath(imagePath, canvas, size);

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, 100),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);
    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
              shadowWidth, shadowWidth, size.width - (shadowWidth * 2), 200),
          topLeft: Radius.circular(size.width),
          topRight: Radius.circular(size.width),
        ),
        borderPaint);
    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage =
        await pictureRecorder.endRecording().toImage(size.width.toInt(), 100);

    // Convert image to bytes
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();
    return uint8List;
  }

  static Future<ui.Image> getImageFromPath(
      String imagePath, Canvas canvas, Size size) async {
    File imageFile = await DefaultCacheManager().getSingleFile(imagePath);

    Uint8List imageBytes = imageFile.readAsBytesSync();
    var color = extractPixelsColors(imageBytes);

    final Paint shadowPaint = Paint()..color = color;
    final Offset triangleOffset = Offset(size.width / 2, size.height);
    var path = Path();

    path.moveTo(triangleOffset.dx, triangleOffset.dy + 20);
    path.lineTo(triangleOffset.dx + 33, triangleOffset.dy - 33);
    path.lineTo(triangleOffset.dx - 33, triangleOffset.dy - 33);
    path.close();

    canvas.drawPath(path, shadowPaint);

    final Completer<ui.Image> completer = new Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  static Path _drawRoundPolygon(
      List<Point> ps, double distance, Canvas canvas, paint) {
    var path = Path();
    ps.add(ps[0]);
    ps.add(ps[1]);
    var p0 = LineInterCircle.intersectionPoint(ps[1], ps[0], distance);
    path.moveTo(p0.x.toDouble(), p0.y.toDouble());
    for (int i = 0; i < ps.length - 2; i++) {
      var p1 = ps[i];
      var p2 = ps[i + 1];
      var p3 = ps[i + 2];
      var interP1 = LineInterCircle.intersectionPoint(p1, p2, distance);
      var interP2 = LineInterCircle.intersectionPoint(p3, p2, distance);
      path.lineTo(interP1.x.toDouble(), interP1.y.toDouble());
      path.arcToPoint(
        Offset(interP2.x.toDouble(), interP2.y.toDouble()),
        radius: Radius.circular(distance * 6),
      );
    }
    return path;
  }

  static void _drawWithPoint(canvas, paint, list, {hasShadow = false}) {
    list = _resizePoint(list);
    var path = _drawRoundPolygon(list, 4.0, canvas, paint);
    if (hasShadow) {
      canvas.drawShadow(path, Colors.black26, 10.0, true);
    }
    canvas.drawPath(path, paint);
  }

  static List<Point> _resizePoint(List<Point> list) {
    List<Point> l = [];
    for (var p in list) {
      l.add(Point((p.x), p.y));
    }
    return l;
  }

  static ui.Color extractPixelsColors(Uint8List? bytes) {
    List<Color> colors = [];

    imageLib.Image? image = imageLib.decodeImage(bytes!);

    List<Pixel?> pixels = [];
    var noOfPixelsPerAxis = 10;
    int? width = image?.width;
    int? height = image?.height;

    int xChunk = width! ~/ (10 + 1);
    int yChunk = height! ~/ (10 + 1);

    for (int j = 1; j < noOfPixelsPerAxis + 1; j++) {
      for (int i = 1; i < noOfPixelsPerAxis + 1; i++) {
        var pixel = image?.getPixel(xChunk * i, yChunk * j);
        pixels.add(pixel);
        colors.add(pixel!.clone());
      }
    }
    return getAverageColor(colors);
  }

  static ui.Color getAverageColor(List<Color> colors) {
    int r = 0, g = 0, b = 0;

    for (int i = 0; i < colors.length; i++) {
      r += colors[i].r.toInt();
      g += colors[i].g.toInt();
      b += colors[i].b.toInt();
    }

    r = (r ~/ colors.length);
    g = (g ~/ colors.length);
    b = (b ~/ colors.length);

    return ui.Color.fromRGBO(r, g, b, 1);
  }

  static void checkPlaces(BuildContext context, String s) async {
    Navigator.pushNamed(context, TripziePlacesSearch.PAGE_NAME);
  }
}

class Line {
  ///y = kx + c
  static double normalLine(x, {k = 0, c = 0}) {
    return k * x + c;
  }

  ///Calculate the param K in y = kx +c
  static double paramK(Point p1, Point p2) {
    if (p1.x == p2.x) return 0;
    return (p2.y - p1.y) / (p2.x - p1.x);
  }

  ///Calculate the param C in y = kx +c
  static double paramC(Point p1, Point p2) {
    return p1.y - paramK(p1, p2) * p1.x;
  }
}

/// start point p1, end point p2,p2 is center of the circle,r is its radius.
class LineInterCircle {
  /// start point p1, end point p2,p2 is center of the circle,r is its radius.
  /// param a: y = kx +c intersect with circle,which has the center with point2 and radius R .
  /// when derive to x2+ ax +b = 0 equation. the param a is here.
  static double paramA(Point p1, Point p2) {
    return (2 * Line.paramK(p1, p2) * Line.paramC(p1, p2) -
            2 * Line.paramK(p1, p2) * p2.y -
            2 * p2.x) /
        (Line.paramK(p1, p2) * Line.paramK(p1, p2) + 1);
  }

  /// start point p1, end point p2,p2 is center of the circle,r is its radius.
  /// param b: y = kx +c intersect with circle,which has the center with point2 and radius R .
  /// when derive to x2+ ax +b = 0 equation. the param b is here.
  static double paramB(Point p1, Point p2, double r) {
    return (p2.x * p2.x -
            r * r +
            (Line.paramC(p1, p2) - p2.y) * (Line.paramC(p1, p2) - p2.y)) /
        (Line.paramK(p1, p2) * Line.paramK(p1, p2) + 1);
  }

  ///the circle has the intersection or not
  static bool isIntersection(Point p1, Point p2, double r) {
    var delta = sqrt(paramA(p1, p2) * paramA(p1, p2) - 4 * paramB(p1, p2, r));
    return delta >= 0.0;
  }

  ///the x coordinate whether or not is between two point we give.
  static bool _betweenPoint(x, Point p1, Point p2) {
    if (p1.x > p2.x) {
      return x > p2.x && x < p1.x;
    } else {
      return x > p1.x && x < p2.x;
    }
  }

  static Point _equalX(Point p1, Point p2, double r) {
    if (p1.y > p2.y) {
      return Point(p2.x, p2.y + r);
    } else if (p1.y < p2.y) {
      return Point(p2.x, p2.y - r);
    } else {
      return p2;
    }
  }

  static Point _equalY(Point p1, Point p2, double r) {
    if (p1.x > p2.x) {
      return Point(p2.x + r, p2.y);
    } else if (p1.x < p2.x) {
      return Point(p2.x - r, p2.y);
    } else {
      return p2;
    }
  }

  ///intersection point
  static Point intersectionPoint(Point p1, Point p2, double r) {
    if (p1.x == p2.x) return _equalX(p1, p2, r);
    if (p1.y == p2.y) return _equalY(p1, p2, r);
    var delta = sqrt(paramA(p1, p2) * paramA(p1, p2) - 4 * paramB(p1, p2, r));
    if (delta < 0.0) {
      //when no intersection, i will return the center of the circ  le.
      return p2;
    }
    var a_2 = -paramA(p1, p2) / 2.0;
    var x1 = a_2 + delta / 2;
    if (_betweenPoint(x1, p1, p2)) {
      var y1 = Line.paramK(p1, p2) * x1 + Line.paramC(p1, p2);
      return Point(x1, y1);
    }
    var x2 = a_2 - delta / 2;
    var y2 = Line.paramK(p1, p2) * x2 + Line.paramC(p1, p2);
    return Point(x2, y2);
  }
}
