import 'package:hutech_cateen/utils/helpers.dart';
import 'package:hutech_cateen/widget/support_color.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailPage extends StatefulWidget {
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
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.host == 'momoSuccess') {
        Navigator.pushReplacementNamed(context, '/success');
      }
    }, onError: (err) {
      print('Failed to get deep link: $err');
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Chi Tiết Đơn Hàng',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.selectedCarts.length,
                itemBuilder: (context, index) {
                  final item = widget.selectedCarts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.white,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [Colors.blue[200]!, Colors.blue[400]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['productName'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Số lượng: ${item['quantity']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Giá: ${Helpers.formatPrice(item['totalPrice'])}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: ColorWidget.primaryColor(),
                                  ),
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
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng Cộng:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${Helpers.formatPrice(widget.totalPrice)}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ColorWidget.primaryColor(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _launchPaymentUrl(widget.paymentUrl),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: ColorWidget.primaryColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.payment, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Thanh Toán Ngay',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
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
    final Uri uri = Uri.parse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
