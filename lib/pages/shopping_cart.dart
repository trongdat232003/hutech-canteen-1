import 'package:flutter/material.dart';
import 'package:hutech_cateen/Components/quantity_control.dart';
import 'package:hutech_cateen/pages/OrderDetail.dart';
import 'package:hutech_cateen/pages/SelectedProductsTable.dart';
import 'package:hutech_cateen/services/apiOrder.dart';
import 'package:hutech_cateen/services/api_discount.dart';
import 'package:hutech_cateen/services/api_shopping_cart.dart';
import 'package:hutech_cateen/utils/helpers.dart';
import 'package:hutech_cateen/widget/support_color.dart';
import 'package:hutech_cateen/widget/support_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  final int maxInventory = 50;
  List carts = [];
  List<String> selectedProductIds = [];
  int totalPrice = 0;
  String discount = '';
  final TextEditingController _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchShoppingCarts();
  }

  void validateDiscountCode(String code) async {
    ApiDiscount apiDiscount = ApiDiscount();
    List<dynamic> discounts = await apiDiscount.getDiscounts();

    final discountExists =
        discounts.any((discount) => discount['discount_code'] == code);

    if (discountExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mã giảm giá hợp lệ!')),
      );
      setState(() {
        discount = code; // Cập nhật biến discount
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mã giảm giá không tồn tại!')),
      );
    }
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
                  'totalPrice': cart['totalPrice'].toInt(),
                  'isSelected': false,
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching carts: $e');
    }
  }

  void updateSelection(String productId, bool isSelected, int productPrice) {
    setState(() {
      final index = carts.indexWhere((cart) => cart['productId'] == productId);
      if (index != -1) {
        carts[index]['isSelected'] = isSelected;

        if (isSelected) {
          selectedProductIds.add(productId);
        } else {
          selectedProductIds.remove(productId);
        }
      }

      totalPrice = carts
              .where((cart) => cart['isSelected'])
              .map((cart) => cart['totalPrice'])
              .toList()
              .isNotEmpty
          ? carts
              .where((cart) => cart['isSelected'])
              .map((cart) => cart['totalPrice'])
              .reduce((a, b) => a + b)
          : 0;
    });
  }

  void updateQuantity(String productId, int quantity) {
    setState(() {
      final index = carts.indexWhere((cart) => cart['productId'] == productId);
      if (index != -1) {
        carts[index]['quantity'] = quantity;
      }

      totalPrice = carts
              .where((cart) => cart['isSelected'])
              .map((cart) => cart['totalPrice'])
              .toList()
              .isNotEmpty
          ? carts
              .where((cart) => cart['isSelected'])
              .map((cart) => cart['totalPrice'])
              .reduce((a, b) => a + b)
          : 0;
    });

    fetchUpdateQuantityProductInCart(productId, quantity);
  }

  void fetchUpdateQuantityProductInCart(
      String productID, int selectedQuantity) async {
    try {
      ApiShoppingCart apiService = ApiShoppingCart();
      await apiService.updateQuantityProductInCart(productID, selectedQuantity);
      fetchShoppingCarts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating quantity: ${e.toString()}')));
    }
  }

  void navigateToOrderDetail() async {
    List<String> selectedProductIdsForCheckout = selectedProductIds.toList();

    ApiOrder apiOrder = ApiOrder();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    if (token == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('You need to log in again.')));
      return;
    }

    try {
      // Thực thi hàm checkOutByUser
      Map<String, dynamic> orderDetail = await apiOrder.checkOutByUser(
          selectedProductIdsForCheckout, token, discount);

      final selectedCarts = carts
          .where((cart) => selectedProductIds.contains(cart['productId']))
          .toList();
      final totalAmount = orderDetail['order']['order_checkout']['totalAmount'];
      final totalDiscount =
          orderDetail['order']['order_checkout']['totalDiscount'];
      final productImage =
          orderDetail['order']['order_product'][0]['product_thumb'];
      final productPrice = orderDetail['order']['order_product'][0]['price'];
      final finalPrice = orderDetail['order']['order_checkout']['final_price'];
      final paymentUrl = orderDetail['paymentUrl'];
      final discountCode = orderDetail['order']['order_discount_code'];

      // Gọi hàm điều hướng đến trang OrderDetailPage với các tham số đã tạo
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailPage(
            selectedCarts: selectedCarts,
            totalPrice: totalAmount,
            totalDiscount: totalDiscount,
            productImage: productImage,
            productPrice: productPrice,
            finalPrice: finalPrice,
            paymentUrl: paymentUrl,
            discount: discountCode,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching payment URL: $e')));
    }
  }

  void updateDiscount(String value) {
    setState(() {
      discount = value; // Cập nhật biến discount
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Giỏ Hàng', style: AppWidget.titleAppBar()),
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _discountController,
                      decoration: InputDecoration(
                        labelText: 'Nhập mã giảm giá',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      validateDiscountCode(_discountController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          ColorWidget.primaryColor(), // Set primary color
                    ),
                    child:
                        Text('Áp dụng', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              SizedBox(height: 10),
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
                                'images/pho.png',
                                width: 60,
                                height: 60,
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item['productName']),
                                    SizedBox(height: 8),
                                    Text(Helpers.formatPrice(
                                        item['totalPrice'])),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Checkbox(
                                      value: item['isSelected'],
                                      onChanged: (bool? value) {
                                        updateSelection(item['productId'],
                                            value ?? false, item['totalPrice']);
                                      },
                                    ),
                                    QuantityControl(
                                      quantity: item['quantity'],
                                      onQuantityChanged: (quantity) {
                                        updateQuantity(
                                            item['productId'], quantity);
                                      },
                                      maxInventory: maxInventory,
                                    ),
                                  ],
                                ),
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
                  },
                ),
              ),
              if (carts.any((cart) => cart['isSelected'])) ...[
                SelectedProductsTable(
                  selectedCarts:
                      carts.where((cart) => cart['isSelected']).map((cart) {
                    return {
                      'productId': cart['productId'],
                      'productName': cart['productName'],
                      'quantity': cart['quantity'],
                      'totalPrice': cart['totalPrice'],
                    };
                  }).toList(),
                  totalPrice: totalPrice,
                  discount: discount,
                  onNavigate: navigateToOrderDetail,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
