import 'package:flutter/material.dart';
import 'package:hutech_cateen/pages/CategoriesDetail.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class CategoryItem extends StatelessWidget {
  final String image;
  final String title;
  final String categoryID;
  CategoryItem(
      {required this.image, required this.title, required this.categoryID});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      height: 60,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Shadow color
            spreadRadius: 1,
            blurRadius: 16,
            offset: Offset(8, 8),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoriesDetail(categoryID: categoryID)),
          );
        },
        style: ButtonStyle(
          overlayColor:
              MaterialStateProperty.all(Colors.transparent), // No ripple effect
          // Remove padding around TextButton
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 253, 236, 192), // Shadow color
                    spreadRadius: 0.1,
                    blurRadius: 10,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor:
                    Colors.transparent, // Transparent CircleAvatar background
                child: Image.asset(
                  image,
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: AppWidget.boldTextSmallFieldStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
