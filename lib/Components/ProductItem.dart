import 'package:flutter/material.dart';
import 'package:hutech_cateen/pages/ProductDetail.dart';
import 'package:hutech_cateen/widget/support_color.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class ProductItem extends StatelessWidget {
  String image;
  String title;
  String productID;
  ProductItem(
      {required this.image, required this.title, required this.productID});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Màu của bóng đổ
            spreadRadius: 8, // Bán kính lan tỏa của bóng
            blurRadius: 18, // Bán kính mờ của bóng

            offset: Offset(10, 10), // Độ lệch của bóng (trục x, trục y)
          ),
        ],
      ),
      child: TextButton(
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetail(productID: productID)))
        },
        style: ButtonStyle(
          overlayColor:
              MaterialStateProperty.all(Colors.transparent), // No ripple effect
          // Remove padding around TextButton
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -60,
              right: 10,
              child: Image.asset(
                image,
                height: 110,
                width: 110,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Text(
                  title,
                  style: AppWidget.boldTextMediumFieldStyle(),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '70 VNĐ',
                      style: AppWidget.semiboldSmallTextFieldStyle(),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(24, 24),
                        shape: CircleBorder(),
                        backgroundColor:
                            ColorWidget.primaryColor(), // <-- Button color
                        foregroundColor: Colors.red, // <-- Splash color
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
