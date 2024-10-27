import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiOrder {
  Future<Map<String, dynamic>> checkOutByUser(
    List<String> productIds,
    String token,
    String discount,
  ) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/v2/api/order/checkOutByUser'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token', // Gửi token để xác thực
      },
      body: jsonEncode({
        'product_ids': productIds,
        'discount_code': discount,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return data['metaData']; // Lấy paymentUrl từ phản hồi
    } else {
      throw Exception('Failed to create order: ${response.body}');
    }
  }
}
