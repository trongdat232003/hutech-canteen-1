import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Remove shadow
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.orange,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Ongoing'),
                Tab(text: 'History'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Ongoing Orders
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              OrderCard(
                imageUrl: 'https://picfiles.alphacoders.com/322/322198.jpg',
                restaurantName: 'Pizza Hut',
                price: '\$35.25',
                status: 'Track Order',
                items: '03 Items',
                orderDate: '29 JAN, 12:30',
                itemId: '#162432',
                isOngoing: true,
              ),
              OrderCard(
                imageUrl: 'https://picfiles.alphacoders.com/322/322198.jpg',
                restaurantName: 'McDonald',
                price: '\$40.15',
                status: 'Track Order',
                items: '02 Items',
                orderDate: '30 JAN, 12:30',
                itemId: '#242432',
                isOngoing: true,
              ),
              OrderCard(
                imageUrl: 'https://picfiles.alphacoders.com/322/322198.jpg',
                restaurantName: 'Starbucks',
                price: '\$10.20',
                status: 'Track Order',
                items: '01 Item',
                orderDate: '30 JAN, 12:30',
                itemId: '#240112',
                isOngoing: true,
              ),
            ],
          ),
          // History Orders
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              OrderCard(
                imageUrl: 'https://picfiles.alphacoders.com/322/322198.jpg',
                restaurantName: 'Pizza Hut',
                price: '\$35.25',
                status: 'Completed',
                items: '03 Items',
                orderDate: '29 JAN, 12:30',
                itemId: '#162432',
              ),
              OrderCard(
                imageUrl: 'https://picfiles.alphacoders.com/322/322198.jpg',
                restaurantName: 'McDonald',
                price: '\$40.15',
                status: 'Completed',
                items: '02 Items',
                orderDate: '30 JAN, 12:30',
                itemId: '#242432',
              ),
              OrderCard(
                imageUrl: 'https://picfiles.alphacoders.com/322/322198.jpg',
                restaurantName: 'Starbucks',
                price: '\$10.20',
                status: 'Cancelled',
                items: '01 Item',
                orderDate: '30 JAN, 12:30',
                itemId: '#240112',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final String imageUrl;
  final String restaurantName;
  final String price;
  final String status;
  final String items;
  final String orderDate;
  final String itemId;
  final bool isOngoing;

  const OrderCard({
    required this.imageUrl,
    required this.restaurantName,
    required this.price,
    required this.status,
    required this.items,
    required this.orderDate,
    required this.itemId,
    this.isOngoing = false,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (status == 'Completed') {
      statusColor = Colors.green;
    } else if (status == 'Cancelled') {
      statusColor = Colors.red;
    } else {
      statusColor = Colors.orange;
    }

    return Card(
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
                  child: Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurantName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        price,
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
                        'Ordered on $orderDate',
                        style: TextStyle(
                          color: Colors.grey[600],
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
                  'Order ID: $itemId',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isOngoing
                        ? status
                        : (status == 'Completed' ? 'Rate' : 'Re-Order'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
