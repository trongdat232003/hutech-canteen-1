import 'package:flutter/material.dart';
import 'package:hutech_cateen/utils/helpers.dart';

import 'package:hutech_cateen/widget/support_color.dart';


class SelectedProductsTable extends StatelessWidget {
  final List<Map<String, dynamic>> selectedCarts;
  final int totalPrice;
  final VoidCallback onNavigate;

  const SelectedProductsTable({
    Key? key,
    required this.selectedCarts,
    required this.totalPrice,
    required this.onNavigate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return selectedCarts.isNotEmpty
        ? Card(

            color: Colors.white,
            elevation: 4,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),

            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sản Phẩm Đã Chọn',

                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorWidget.primaryColor(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: selectedCarts.length,
                    itemBuilder: (context, index) {
                      final item = selectedCarts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item['productName'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              'SL: ${item['quantity']}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              Helpers.formatPrice(item['totalPrice']),
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorWidget.primaryColor(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(thickness: 1, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng Giá:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        Helpers.formatPrice(totalPrice),
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorWidget.primaryColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: onNavigate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorWidget.primaryColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                      ),
                      child: const Text(
                        'Chi Tiết Đơn Hàng',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox(); // Return empty widget if no products are selected
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: selectedCarts.length,
                    itemBuilder: (context, index) {
                      final item = selectedCarts[index];
                      return ListTile(
                        title: Text(item['productName']),
                        subtitle: Text(
                          'Số lượng: ${item['quantity']} - Giá: ${Helpers.formatPrice(item['totalPrice'])}',
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tổng Giá: ${Helpers.formatPrice(totalPrice)}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: onNavigate,
                    child: Text('Đi đến Chi Tiết Đơn Hàng'),
                  ),
                ],
              ),
            ),
          )
        : SizedBox(); // Trả về widget trống nếu không có sản phẩm nào được chọn

  }
}
