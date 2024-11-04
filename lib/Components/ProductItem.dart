import 'package:flutter/material.dart';
import 'package:hutech_cateen/pages/ProductDetail.dart';
import 'package:hutech_cateen/pages/shopping_cart.dart';
import 'package:hutech_cateen/services/api_shopping_cart.dart';
import 'package:hutech_cateen/utils/helpers.dart';
import 'package:hutech_cateen/widget/support_color.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class ProductItem extends StatelessWidget {
  final String title;
  final String productID;
  final String productThumb;
  final String productPrice;

  const ProductItem({
    required this.title,
    required this.productID,
    required this.productThumb,
    required this.productPrice,
    Key? key,
  }) : super(key: key);

  void addToCart(BuildContext context) async {
    try {
      ApiShoppingCart apiShoppingCart = ApiShoppingCart();
      await apiShoppingCart.addToCart(productID, 1);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ShoppingCart()),
      );
    } catch (e) {
      // Show error message if adding to cart fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add to cart: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 8,
            blurRadius: 18,
            offset: const Offset(10, 10),
          ),
        ],
      ),
      child: TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetail(productID: productID),
          ),
        ),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -60,
              child: Image.network(
                productThumb,
                height: 90,
                width: 90,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 25),
                Container(
                  width: 140,
                  child: Text(
                    title,
                    style: AppWidget.boldTextSmallFieldStyle(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        Helpers.formatPrice(int.parse(productPrice)),
                        style: AppWidget.semiboldSmallTextFieldStyle(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => addToCart(context),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(24, 24),
                        shape: const CircleBorder(),
                        backgroundColor: ColorWidget.primaryColor(),
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
