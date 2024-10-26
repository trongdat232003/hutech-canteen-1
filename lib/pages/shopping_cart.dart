import 'package:flutter/material.dart';
import 'package:hutech_cateen/Components/quantity_control.dart';
import 'package:hutech_cateen/pages/OrderDetail.dart';
import 'package:hutech_cateen/pages/SelectedProductsTable.dart';
import 'package:hutech_cateen/services/apiOrder.dart';
import 'package:hutech_cateen/services/api_shopping_cart.dart';
import 'package:hutech_cateen/utils/helpers.dart';
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
  List<String> selectedProductIds = []; // Lưu ID sản phẩm đã chọn
  int totalPrice = 0; // Lưu tổng giá của sản phẩm đã chọn

  @override
  void initState() {
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
                  'totalPrice':
                      cart['totalPrice'].toInt(), // Chuyển đổi thành int
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

        // Cập nhật danh sách ID sản phẩm đã chọn
        if (isSelected) {
          selectedProductIds.add(productId);
        } else {
          selectedProductIds.remove(productId);
        }
      }

      // Tính lại totalPrice
      totalPrice = carts
              .where((cart) => cart['isSelected'])
              .map((cart) {
                return cart['totalPrice'];
              })
              .toList()
              .isNotEmpty
          ? carts.where((cart) => cart['isSelected']).map((cart) {
              return cart['totalPrice'];
            }).reduce((a, b) => a + b)
          : 0; // Trả về 0 nếu không có sản phẩm nào được chọn
    });
  }

  void updateQuantity(String productId, int quantity) {
    setState(() {
      final index = carts.indexWhere((cart) => cart['productId'] == productId);
      if (index != -1) {
        // Cập nhật số lượng sản phẩm
        carts[index]['quantity'] = quantity;
      }

      // Tính lại totalPrice
      totalPrice = carts
              .where((cart) => cart['isSelected'])
              .map((cart) {
                return cart['totalPrice'];
              })
              .toList()
              .isNotEmpty
          ? carts.where((cart) => cart['isSelected']).map((cart) {
              return cart['totalPrice'];
            }).reduce((a, b) => a + b)
          : 0; // Trả về 0 nếu không có sản phẩm nào được chọn
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
        SnackBar(content: Text('Error updating quantity: ${e.toString()}')),
      );
    }
  }

  void navigateToOrderDetail() async {
    // Tạo một danh sách ID sản phẩm đã chọn
    List<String> selectedProductIdsForCheckout = selectedProductIds.toList();

    // Gọi API để tạo đơn hàng và lấy payment URL
    ApiOrder apiOrder = ApiOrder();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('accessToken');

    // Kiểm tra xem token có phải là null không
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to log in again.')),
      );
      return; // Nếu token là null, dừng lại không thực hiện tiếp
    }

    try {
      String paymentUrl = await apiOrder.checkOutByUser(
        selectedProductIdsForCheckout,
        totalPrice,
        token, // token ở đây chắc chắn không phải là null
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderDetailPage(
            selectedCarts: carts
                .where((cart) => selectedProductIds.contains(cart['productId']))
                .toList(),
            totalPrice: totalPrice,
            paymentUrl: paymentUrl, // Gửi paymentUrl từ API
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching payment URL: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Giỏ Hàng',
          style: AppWidget.titleAppBar(),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
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
                                  Text(Helpers.formatPrice(item['totalPrice'])),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Checkbox(
                                    value: item['isSelected'],
                                    onChanged: (bool? value) {
                                      updateSelection(
                                        item['productId'],
                                        value ?? false,
                                        item['totalPrice'],
                                      );
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
            // Hiển thị bảng sản phẩm đã chọn chỉ khi có sản phẩm được chọn
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
                onNavigate: navigateToOrderDetail,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
