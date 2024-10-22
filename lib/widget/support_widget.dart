import 'package:flutter/material.dart';
import 'package:hutech_cateen/widget/support_color.dart';

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
        color: ColorWidget.primaryColor(),
        fontWeight: FontWeight.w500,
        fontSize: 14);
  }

  static TextStyle descripe() {
    return TextStyle(
      color: Colors.grey[500],
      fontSize: 14,
    );
  }

  static TextStyle descripeStrong() {
    return TextStyle(
        color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.bold);
  }

  static TextStyle titleAppBar() {
    return TextStyle(
        color: Colors.grey[800], fontSize: 22, fontWeight: FontWeight.w600);
  }
}
