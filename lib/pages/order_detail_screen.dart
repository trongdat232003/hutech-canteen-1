import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import để sử dụng DateFormat
import 'package:hutech_cateen/services/apiOrder.dart';
import 'package:hutech_cateen/utils/helpers.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  bool isLoading = true;
  var orderData;

  @override
  void initState() {
    super.initState();
    fetchOrderDetail();
  }

  Future<void> fetchOrderDetail() async {
    ApiOrder apiService = ApiOrder();
    var fetchOrder = await apiService.getOrderById(widget.orderId);

    setState(() {
      orderData = fetchOrder;
      isLoading = false;
    });
  }

  DateTime parseCustomDate(String dateStr) {
    // Tách giờ và ngày từ chuỗi
    final parts = dateStr.split(' ');
    final time = parts[0];
    final date = parts[1];

    // Chuyển đổi sang định dạng "yyyy-MM-dd HH:mm:ss"
    final formattedDateStr = '${date.split('/').reversed.join('-')} $time';
    return DateTime.parse(formattedDateStr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 243, 243),
      appBar: AppBar(
        title: const Text(
          'Chi tiết đơn hàng',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Thêm SingleChildScrollView ở đây
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Thông tin đơn hàng
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông tin đơn hàng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Thời gian đặt',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  DateFormat('d-M-yyyy HH:mm:ss').format(
                                    parseCustomDate(orderData['order_checkout']
                                        ['timeOrder']),
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            const VerticalDivider(
                              // Thêm đường viền dọc
                              width:
                                  20, // Khoảng cách bên trái và bên phải của đường viền
                              thickness: 1, // Độ dày của đường viền
                              color: Colors.grey, // Màu của đường viền
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Thời gian ước tính',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  DateFormat('d-M-yyyy HH:mm:ss').format(
                                    parseCustomDate(orderData['order_checkout']
                                        ['deliveryTime']),
                                  ),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
                        Text(
                          'Trạng thái: ${orderData!['order_status']}',
                          style: TextStyle(
                            fontSize: 16,
                            color: orderData!['order_status'] == 'pending'
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ),
                        const Divider(),
                        Text(
                          'Mã đơn hàng: ${orderData!['order_trackingNumber']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Danh sách sản phẩm đã chọn
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sản phẩm đã chọn',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (int i = 0;
                            i < orderData!['order_product'].length;
                            i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              children: [
                                Image.network(
                                  orderData['order_product'][i]
                                      ['product_thumb'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        orderData['order_product'][i]
                                            ['productId']['product_name'],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${Helpers.formatPrice(orderData['order_product'][i]['price'])} ',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                    '${'x' + orderData['order_product'][i]['quantity'].toString()}',
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tổng cộng
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Tổng cộng',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Thành tiền',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    '${Helpers.formatPrice(orderData!['order_checkout']['totalAmount'])} ',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Giảm giá',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    '${Helpers.formatPrice(orderData!['order_checkout']['totalDiscount'])} ',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Số tiền thanh toán
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Số tiền thanh toán',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${Helpers.formatPrice(orderData!['order_checkout']['final_price'])} ',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Phương thức thanh toán
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Phương thức thanh toán',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                orderData['order_payment']['payment_status'] !=
                                        'success'
                                    ? 'Chưa thanh toán'
                                    : 'Đã thanh toán bằng MOMO',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
      ),
    );
  }
}
