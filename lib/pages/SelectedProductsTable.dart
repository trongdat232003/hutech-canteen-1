import 'package:flutter/material.dart';
import 'package:hutech_cateen/utils/helpers.dart';

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
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sản Phẩm Đã Chọn',
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
