import 'package:flutter/material.dart';
import 'package:hutech_cateen/Components/empty_screen.dart';
import 'package:hutech_cateen/pages/Order.dart';
import 'package:hutech_cateen/services/api_review.dart';
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
  List orderNotReviews = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchOrderNotReviews();
  }

  void fetchOrderNotReviews() async {
    try {
      ApiReview apiService = ApiReview();
      List<dynamic> fetchedOrderNotReviews =
          await apiService.getOrderNotReviews();

      setState(() {
        orderNotReviews = fetchedOrderNotReviews
            .map((notReview) => {
                  'notReviewID': notReview['_id'],
                  'productID': notReview['order_product']['productId'],
                  'productImage': notReview['order_product']['product_thumb'],
                  'productQuantity': notReview['order_product']['quantity']
                })
            .toList();
      });
    } catch (e) {
      print('Error fetching reviews: $e');
    }
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
      body: orderNotReviews.length < 0
          ? EmptyScreen(
              title: 'Không có sản phẩm nào để đánh giá',
              desc: 'Bạn đã hoàn tất đánh giá tất cả sản phẩm')
          : TabBarView(
              controller: _tabController,
              children: [
                // Chưa đánh giá
                ListView.builder(
                  itemCount: orderNotReviews.length,
                  itemBuilder: (context, index) {
                    final item = orderNotReviews[index];
                    return ListTile(
                      leading: Image.asset(item['productImage'], width: 50),
                      title: Text('Tên sản phẩm'),
                      subtitle: Text('Còn 12 ngày để đánh giá'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Handle review action here
                        },
                        child: Text('Đánh giá +200'),
                      ),
                    );
                  },
                ),
                // Đã đánh giá
                ListView.builder(
                  itemCount: orderNotReviews.length,
                  itemBuilder: (context, index) {
                    final item = orderNotReviews[index];
                    return ListTile(
                      leading: Image.asset(item['productImage'], width: 50),
                      title: Text('Tên sản phẩm'),
                      subtitle: Text('Còn 12 ngày để đánh giá'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Handle review action here
                        },
                        child: Text('Đánh giá +200'),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
