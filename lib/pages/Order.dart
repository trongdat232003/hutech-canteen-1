import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hutech_cateen/Components/empty_screen.dart';
import 'package:hutech_cateen/pages/order_detail_screen.dart';
import 'package:hutech_cateen/services/apiListOrder.dart';
import 'package:hutech_cateen/utils/helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<dynamic> ongoingOrders = [];
  List<dynamic> historyOrders = [];
  bool isLoading = true;

  final OrderService _orderService = OrderService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        List<dynamic> successOrders =
            await _orderService.fetchSuccessOrders(token);
        List<dynamic> pendingOrders =
            await _orderService.fetchPendingOrders(token);
        List<dynamic> completedOrders =
            await _orderService.fetchCompletedOrders(token);
        List<dynamic> cancelledOrders =
            await _orderService.fetchCancelledOrders(token);

        setState(() {
          ongoingOrders = [...successOrders, ...pendingOrders];
          historyOrders = [...completedOrders, ...cancelledOrders];
          isLoading = false;
        });
      } catch (e) {
        print("Error fetching orders: $e");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Đơn đặt hàng',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.orange,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Đang chờ'),
            Tab(text: 'Đã hoàn thành'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Color.fromARGB(255, 245, 243, 243), // Thêm màu nền ở đây
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Ongoing Orders
                  buildOrderList(ongoingOrders, true),
                  // History Orders
                  buildOrderList(historyOrders, false),
                ],
              ),
            ),
    );
  }

  Widget buildOrderList(List<dynamic> orders, bool isOngoing) {
    if (orders.isEmpty) {
      return const Center(
          child: EmptyScreen(title: "Không có sản phẩm nào", desc: "Trống"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        var order = orders[index];
        return OrderCard(
          imageUrl: order['order_product'][0]['product_thumb'],
          price: '${order['order_checkout']['final_price']}',
          status: order['order_status'],
          items: '${order['order_product'].length} sản phẩm',
          orderDate: order['order_checkout']['timeOrder'],
          itemId: order['order_trackingNumber'],
          orderId: order['_id'],
          isOngoing: isOngoing,
        );
      },
    );
  }
}

class OrderCard extends StatelessWidget {
  final String imageUrl;
  final String price;
  final String status;
  final String items;
  final String orderDate;
  final String itemId;
  final String orderId;
  final bool isOngoing;

  const OrderCard({
    required this.imageUrl,
    required this.price,
    required this.status,
    required this.items,
    required this.orderDate,
    required this.itemId,
    required this.orderId,
    this.isOngoing = false,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (status == 'completed') {
      statusColor = Colors.green;
    } else if (status == 'cancelled') {
      statusColor = Colors.red;
    } else if (status == 'pending') {
      statusColor = Colors.orange;
    } else if (status == 'success') {
      statusColor = Colors.green; // New color for success
    } else {
      statusColor = Colors.grey;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(orderId: orderId),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    // child: Image.network(
                    //   imageUrl,
                    //   width: 80,
                    //   height: 80,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Removed restaurant name
                        Text(
                          Helpers.formatPrice(int.parse(price)),
                          style: TextStyle(
                            color: Colors.orange[700],
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          items,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Đặt vào ngày $orderDate',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        // Displaying order status
                        Text(
                          'Trạng thái: $status',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mã đơn hàng: $itemId',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
