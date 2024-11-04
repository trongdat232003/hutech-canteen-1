import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class RowTitle extends StatelessWidget {
  final String title;
  const RowTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${title}',
      style: AppWidget.semiboldTextFieldStyle(),
    );
  }
}
