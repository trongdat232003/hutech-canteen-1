import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class RowTitle extends StatelessWidget {
  final String title;
  const RowTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(
        '${title}',
        style: AppWidget.semiboldTextFieldStyle(),
      ),
      Row(
        children: [
          Text('See All', style: AppWidget.lightTextFieldStyle()),
          SizedBox(width: 6),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: Colors.black45,
          )
        ],
      )
    ]);
  }
}
