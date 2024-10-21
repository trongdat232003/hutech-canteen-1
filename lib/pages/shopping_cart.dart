import 'package:flutter/material.dart';
import 'package:hutech_cateen/Components/quantity_control.dart';
import 'package:hutech_cateen/services/api_shopping_cart.dart';
import 'package:hutech_cateen/utils/helpers.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  int selectedQuantity = 1;
  final int maxInventory = 50;
  @override
  List carts = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchShoppingCarts();
  }

  void fetchShoppingCarts() async {
    try {
      ApiShoppingCart apiShoppingCart = ApiShoppingCart();
      List<dynamic> fetchShoppingCarts =
          await apiShoppingCart.getShoppingCarts();
      setState(() {
        carts = fetchShoppingCarts
            .map((cart) => {
                  'productId': cart['productId'],
                  'productName': cart['name'],
                  'quantity': cart['quantity'],
                  'totalPrice': cart['totalPrice']
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching carts: $e');
    }
  }

  void fetchUpdateQuantityProductInCart(
      String productID, int selectedQuantity) async {
    try {
      ApiShoppingCart apiService = ApiShoppingCart();
      await apiService.updateQuantityProductInCart(productID, selectedQuantity);
      fetchShoppingCarts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding to cart: ${e.toString()}')),
      );
    }
  }

  void updateQuantity(String productId, int quantity) {
    setState(() {
      final index = carts.indexWhere((cart) => cart['productId'] == productId);
      if (index != -1) {
        carts[index]['quantity'] = quantity;
      }
    });
    fetchUpdateQuantityProductInCart(productId, quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Cart',
          style: AppWidget.titleAppBar(),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: carts.length,
                    itemBuilder: (context, index) {
                      final item = carts[index];
                      return Container(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Container(
                                width: 70,
                                height: 70,
                                child: Image.asset(
                                  width: 60,
                                  height: 60,
                                  'images/pho.png',
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item['productName']),
                                        SizedBox(height: 8),
                                        Text(Helpers.formatPrice(
                                            item['totalPrice'])),
                                      ]),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.black,
                                        ),
                                      ),
                                      QuantityControl(
                                          quantity: item['quantity'],
                                          onQuantityChanged: (quantity) {
                                            updateQuantity(
                                                item['productId'], quantity);
                                          },
                                          maxInventory: maxInventory)
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
