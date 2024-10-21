import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiShoppingCart {
  String baseUrl = 'http://10.0.2.2:3000/v2/api/cart';

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
      print('Error fetching cart: $e');
      return {}; // Trả về danh sách rỗng nếu xảy ra lỗi
    }
  }

  Future<List<dynamic>> getShoppingCarts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('metaData');
      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }
      var metaData = jsonDecode(token);
      var accessToken = metaData['token']['accessToken'];

      final response = await http.get(
        Uri.parse('$baseUrl/getCartByUser'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$accessToken'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var carts = data['metaData']['cart_products'];
        return carts;
      } else {
        throw Exception('Failed to load Cart');
      }
    } catch (e) {
      print('Error fetching shopping cart: $e');
      return [];
    }
  }

  Future<dynamic> updateQuantityProductInCart(productId, newQuantity) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('metaData');
      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }
      var metaData = jsonDecode(token);
      var accessToken = metaData['token']['accessToken'];
      final response = await http.patch(
        Uri.parse('$baseUrl/fillQuantityUpdateProductInCart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$accessToken'
        },
        body: jsonEncode({'productId': productId, 'newQuantity': newQuantity}),
      );

      if (response.statusCode != 200) {
        final errorResponse = jsonDecode(response.body);
        throw Exception(
            errorResponse['message'] ?? 'Failed to update quantity.');
      }
    } catch (e) {
      // print('Error fetching cart: $e');
      throw e;
    }
  }
}
