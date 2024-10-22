import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hutech_cateen/utils/helpers.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailPage extends StatelessWidget {
  final List selectedCarts;
  final int totalPrice;
  final String paymentUrl;

  const OrderDetailPage({
    Key? key,
    required this.selectedCarts,
    required this.totalPrice,
    required this.paymentUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi Tiết Đơn Hàng',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: selectedCarts.length,
                itemBuilder: (context, index) {
                  final item = selectedCarts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              // image: DecorationImage(
                              //   fit: BoxFit.cover,
                              //   image: NetworkImage(item['product_thumb']),
                              // ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['productName'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text('Số lượng: ${item['quantity']}'),
                                SizedBox(height: 5),
                                Text(
                                  'Giá: ${Helpers.formatPrice(item['totalPrice'])}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Tổng: ${Helpers.formatPrice(totalPrice)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _launchPaymentUrl(
                        paymentUrl), // Gọi hàm mở URL thanh toán
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                      backgroundColor: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Tiến Hành Thanh Toán',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchPaymentUrl(String url) async {
    print(url);
    final Uri uri = Uri.parse(url);
    print(uri);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
