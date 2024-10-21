import 'package:flutter/material.dart';
import 'package:hutech_cateen/pages/Order.dart';
import 'package:hutech_cateen/widget/support_color.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Đánh giá của tôi',
          style: AppWidget.boldTextMediumFieldStyle(),
        ),
        backgroundColor: Colors.white,

        elevation: 0, // Remove shadow
        iconTheme: IconThemeData(color: ColorWidget.primaryColor()),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: ColorWidget.primaryColor(),
              unselectedLabelColor: Colors.black87,
              indicatorColor: ColorWidget.primaryColor(),
              labelStyle: const TextStyle(fontWeight: FontWeight.w400),
              tabs: const [
                Tab(text: 'Chưa đánh giá'),
                Tab(text: 'Đã Đánh giá'),
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
