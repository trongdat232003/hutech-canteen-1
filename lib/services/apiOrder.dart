import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiOrder {
  String baseUrl = 'http://10.0.2.2:3000/v2/api/order';
  Future<Map<String, dynamic>> checkOutByUser(
    List<String> productIds,
    String token,
    String discount,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/checkOutByUser'),
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

  Future<dynamic> getOrderById(orderId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/orderDetails/$orderId'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var order = data['metaData'];
        print(order);
        return order;
      } else {
        throw Exception('Failed to load Order');
      }
    } catch (e) {
      print('Error fetching Order: $e');
      return {};
    }
  }
}
