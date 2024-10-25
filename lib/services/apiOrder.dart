import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiOrder {
  Future<String> checkOutByUser(
      List<String> productIds, int totalPrice, String token) async {
    print(productIds);
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/v2/api/order/checkOutByUser'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token', // Gửi token để xác thực
      },
      body: jsonEncode({
        'product_ids': productIds,
        'payment_method': 'online_payment',
        // Bạn có thể thêm discount_code nếu cần
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['metaData']['paymentUrl']; // Lấy paymentUrl từ phản hồi
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }
}
