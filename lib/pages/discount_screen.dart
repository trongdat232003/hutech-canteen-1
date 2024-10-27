import 'package:flutter/material.dart';
import 'package:hutech_cateen/Components/empty_screen.dart';
import 'package:hutech_cateen/services/api_discount.dart';
import 'package:hutech_cateen/utils/helpers.dart';
import 'package:hutech_cateen/widget/support_color.dart';
import 'package:hutech_cateen/widget/support_widget.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  final ApiDiscount apiDiscount = ApiDiscount();
  List<dynamic> discounts = [];

  @override
  void initState() {
    super.initState();
    _fetchDiscounts();
  }

  Future<void> _fetchDiscounts() async {
    try {
      var discountApi = await apiDiscount.getDiscounts();
      setState(() {
        discounts = discountApi;
      });
    } catch (e) {
      print('Lỗi tìm nạp discount: $e');
    }
  }

  String calculateRemainingDays(String startDate, String endDate) {
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    final difference = end.difference(DateTime.now()).inDays;
    return difference > 0 ? '$difference ngày' : 'đã hết hạn';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 243, 243),
      appBar: AppBar(
        title: Text(
          'Mã Giảm Giá',
          style: AppWidget.boldTextMediumFieldStyle(),
        ),
        iconTheme: IconThemeData(color: ColorWidget.primaryColor()),
        backgroundColor: Colors.white,
      ),
      body: discounts.isEmpty
          ? EmptyScreen(
              title: 'Chưa có mã giảm giá',
              desc: 'Hiện bạn chưa có mã giảm giá nào',
            )
          : Padding(
              padding: const EdgeInsets.only(
                  top: 20), // Add 20px padding from the top
              child: ListView.builder(
                itemCount: discounts.length,
                itemBuilder: (context, index) {
                  final discount = discounts[index];
                  final discountValue =
                      discount['discount_value_type'] == 'percentage'
                          ? '${discount['discount_value']}%'
                          : '₫${discount['discount_value']}';
                  final remainingDays = calculateRemainingDays(
                    discount['discount_start_date'],
                    discount['discount_end_date'],
                  );

                  return Card(
                    color: Colors.white, // Set the card color to white
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Stack(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: ColorWidget.primaryColor(),
                            child: Text(
                              discount['discount_name'][0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Giảm $discountValue, giảm tối đa ${Helpers.formatPrice(discount['maximum_discount_value'])}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'Đơn tối thiểu: ${Helpers.formatPrice(discount['min_order_value'])}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Mã giảm giá: ${discount['discount_code']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                'Hiệu lực sau: $remainingDays',
                                style: const TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 2),
                            decoration: BoxDecoration(
                              color: ColorWidget.primaryColor(),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(2),
                                bottomRight: Radius.circular(2),
                              ),
                            ),
                            child: Text(
                              'x${discount['max_uses_per_user']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
