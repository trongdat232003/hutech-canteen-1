import 'package:hutech_cateen/Components/quantity_control.dart';
import 'package:hutech_cateen/pages/shopping_cart.dart';
import 'package:hutech_cateen/services/api_favorite.dart';
import 'package:hutech_cateen/services/api_shopping_cart.dart';
import 'package:hutech_cateen/utils/helpers.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:hutech_cateen/services/apiProduct.dart';
import 'package:hutech_cateen/widget/support_color.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class ProductDetail extends StatefulWidget {
  final String productID;
  const ProductDetail({required this.productID});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  var product;
  var selectedQuantity = 1;
  final int maxInventory = 50;
  bool isFavorite = false;
  @override
  void initState() {
    // TODO: implement initState
    fetchProductByID(widget.productID);
  }

  void fetchProductByID(String productID) async {
    try {
      ApiProduct apiService = ApiProduct();
      var fetchedProduct = await apiService.getProductByID(productID);

      if (fetchedProduct == null) {
        throw Exception('Product not found');
      }

      setState(() {
        product = fetchedProduct;
        isFavorite = fetchedProduct['favorites'];
      });
    } catch (e) {
      print('Error fetching subCategories: $e');
    }
  }

  void toggleFavorite() async {
    try {
      await ApiFavorite().toggleFavorite(widget.productID);
      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  void fetchAddToCart(String productID, int selectedQuantity) async {
    try {
      ApiShoppingCart apiService = ApiShoppingCart();
      await apiService.addToCart(productID, selectedQuantity);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ShoppingCart()),
      );
    } catch (e) {
      print('Error fetching subCategories: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding to cart: $e')),
      );
    }
  }

  void updateQuantity(int quantity) {
    setState(() {
      selectedQuantity = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return product != null
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.grey[800]),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    "Details",
                    style: AppWidget.titleAppBar(),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? ColorWidget.primaryColor()
                            : ColorWidget.primaryColor(),
                      ),
                      onPressed: toggleFavorite,
                    ),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20,
                      right: 25,
                      left: 25,
                      bottom: 80), // Thay đổi padding dưới để tránh che khuất
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorWidget.primaryColor(),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Image.asset(
                          'images/pho.png', // Thay thế bằng hình ảnh của bạn
                          height: 180,
                          width: 180,
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product!['product']['product_name'],
                            style: AppWidget.boldTextLargeFieldStyle(),
                          ),
                          Row(
                            children: [
                              Text(
                                  product!['product']['product_ratingAverage']
                                      .toString(),
                                  style: AppWidget.boldTextSmallFieldStyle()),
                              SizedBox(width: 4),
                              Icon(Icons.star, color: Colors.orange, size: 20),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        product!['product']['product_description'],
                        style: AppWidget.descripe(),
                      ),
                      SizedBox(height: 10),
                      Row(children: [
                        Text(
                          "SIZE:",
                          style: AppWidget.boldTextMediumFieldStyle(),
                        ),
                        SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                              color: ColorWidget.inputColor(),
                              borderRadius: BorderRadius.circular(30)),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            product!['product']['serving_size'],
                            style: AppWidget.descripeStrong(),
                          ),
                        ),
                      ]),
                      SizedBox(height: 10),
                      Text(
                        "Cách sử dụng :",
                        style: AppWidget.boldTextMediumFieldStyle(),
                      ),
                      SizedBox(height: 8),
                      Text(
                        product!['product']['product_usage'],
                        style: AppWidget.descripe(),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Nguyên Liệu :",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(product!['product']['ingredients'],
                          style: AppWidget.descripe()),
                      Spacer(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorWidget.inputColor(),
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30))),
                    padding: EdgeInsets.only(
                        right: 24,
                        left: 24,
                        bottom: 40,
                        top: 30), // Padding cho nội dung bên trong
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Helpers.formatPrice(
                                  product!['product']['product_price']),
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            QuantityControl(
                                quantity: selectedQuantity,
                                maxInventory: maxInventory,
                                onQuantityChanged: updateQuantity),
                          ],
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              fetchAddToCart(
                                  widget.productID, selectedQuantity);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorWidget.primaryColor(),
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "ADD TO CART",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            body: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.black,
                size: 100,
              ),
            ),
          );
  }
}
