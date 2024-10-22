import 'package:flutter/material.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class EmptyScreen extends StatelessWidget {
  final String title;
  final String desc;

  const EmptyScreen({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: AppWidget.descripeStrong(),
          ),
          SizedBox(height: 6),
          Text(
            desc,
            style: AppWidget.descripe(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
