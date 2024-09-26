import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiShoppingCart {
  String baseUrl = 'http://localhost:3000/v2/api/cart';

  Future<dynamic> addToCart(productId, quantity) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('metaData');
      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }
      var metaData = jsonDecode(token);
      var accessToken = metaData['token']['accessToken'];

      final response = await http.post(
        Uri.parse('$baseUrl/addToCart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$accessToken'
        },
        body: jsonEncode({'productId': productId, 'quantity': quantity}),
      );
    } catch (e) {
      print('Error fetching categories: $e');
      return {}; // Trả về danh sách rỗng nếu xảy ra lỗi
    }
  }
}
