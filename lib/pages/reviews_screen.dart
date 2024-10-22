// Các import khác
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hutech_cateen/Components/empty_screen.dart';
import 'package:hutech_cateen/pages/Order.dart';
import 'package:hutech_cateen/pages/review_screen.dart';
import 'package:hutech_cateen/services/api_review.dart';
import 'package:hutech_cateen/widget/support_color.dart';
import 'package:hutech_cateen/widget/support_widget.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List orderNotReviews = [];
  List reviews = [];
  String userName = '';
  String userAvatarUrl = '';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchOrderNotReviews();
    fetchReviews();
    fetchUserData();
  }

  void fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? metaDataString = prefs.getString('metaData');

    if (metaDataString != null) {
      Map<String, dynamic> metaData = jsonDecode(metaDataString);
      setState(() {
        userName = metaData['user']['name'] ?? 'Người dùng';
        userAvatarUrl = metaData['user']['avatar'] ?? 'images/user.jpg';
      });
    }
  }

  void fetchReviews() async {
    try {
      ApiReview apiService = ApiReview();
      List<dynamic> fetchedReviews = await apiService.getReviews();

      setState(() {
        reviews = fetchedReviews.map((review) {
          return {
            'reviewComment': review['review_comment'],
            'reviewImg1': review['review_img_1'],
            'reviewImg2': review['review_img_2'],
            'reviewRating': review['review_rating'],
            'reviewDay': review['review_day'],
            'productID': review['review_product_id'],
            'orderID': review['review_order_id'],
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching reviews: $e');
      // Có thể hiển thị thông báo lỗi cho người dùng ở đây
    }
  }

  void fetchOrderNotReviews() async {
    try {
      ApiReview apiService = ApiReview();
      List<dynamic> fetchedOrderNotReviews =
          await apiService.getOrderNotReviews();

      setState(() {
        orderNotReviews = fetchedOrderNotReviews.map((notReview) {
          return {
            'orderID': notReview['_id'],
            'productID': notReview['order_product'][0]['productId'],
            'productImage': notReview['order_product'][0]['product_thumb'],
            'productQuantity': notReview['order_product'][0]['quantity']
          };
        }).toList();
      });
    } catch (e) {
      print('Error fetching orders not reviewed: $e');
      // Có thể hiển thị thông báo lỗi cho người dùng ở đây
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 243, 243),
      appBar: AppBar(
        title: Text(
          'Đánh giá của tôi',
          style: AppWidget.boldTextMediumFieldStyle(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
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
      body: orderNotReviews.isEmpty
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    item['productImage'],
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Tên sản phẩm', // Có thể thay đổi theo item['productName']
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey[300],
                                thickness: 1,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ReviewScreen(
                                                orderID: item['orderID'],
                                                productID: item['productID'])),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ColorWidget.primaryColor(),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Đánh giá',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Đã đánh giá
                ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 0),
                      child: Card(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: userAvatarUrl.isNotEmpty
                                        ? NetworkImage(userAvatarUrl)
                                        : AssetImage('images/user.png')
                                            as ImageProvider,
                                    radius: 25,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName, // Thay đổi theo review['productName']
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    RatingBarIndicator(
                                      rating: review['reviewRating'].toDouble(),
                                      itemCount: 5,
                                      itemSize: 15.0,
                                      direction: Axis.horizontal,
                                      unratedColor: Colors.grey[300],
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      review['reviewComment'],
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      DateFormat('d-M-yyyy HH:mm').format(
                                          DateTime.parse(review['reviewDay'])),
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
