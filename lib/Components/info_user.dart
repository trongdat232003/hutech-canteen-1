import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class InfoUser extends StatefulWidget {
  final String userName;
  const InfoUser({required this.userName});

  @override
  State<InfoUser> createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hey, ${widget.userName}",
                style: AppWidget.boldTextLargeFieldStyle()),
            Text(
              "Good morning!",
              style: AppWidget.lightTextFieldStyle(),
            )
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            "images/user.jpg",
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
