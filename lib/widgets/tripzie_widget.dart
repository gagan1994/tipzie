import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget getSvgWidget(url, double width, double height) {
  return SvgPicture.asset(url, width: width, height: height);
}
