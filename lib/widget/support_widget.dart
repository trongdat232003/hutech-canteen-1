import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextLargeFieldStyle() {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24);
  }

  static TextStyle boldTextSmallFieldStyle() {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16);
  }

  static TextStyle boldTextMediumFieldStyle() {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18);
  }

  static TextStyle lightTextFieldStyle() {
    return TextStyle(
        color: Colors.black45, fontWeight: FontWeight.w500, fontSize: 18);
  }

  static TextStyle semiboldTextFieldStyle() {
    return TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20);
  }

  static TextStyle semiboldSmallTextFieldStyle() {
    return TextStyle(
        color: Color.fromARGB(255, 245, 177, 76),
        fontWeight: FontWeight.w500,
        fontSize: 14);
  }
}
