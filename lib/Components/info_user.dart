import 'package:flutter/material.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class InfoUser extends StatelessWidget {
  final String userName;
  final String avatarUrl;

  const InfoUser({Key? key, required this.userName, required this.avatarUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chào, ${userName}",
              style: AppWidget.boldTextLargeFieldStyle(),
            ),
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: avatarUrl.isNotEmpty
              ? Image.network(
                  avatarUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Handle image loading error
                    return Image.asset(
                      "images/user.jpg",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    );
                  },
                )
              : Image.asset(
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
