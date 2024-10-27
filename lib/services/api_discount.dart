import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiDiscount {
  String baseUrl = 'http://10.0.2.2:3000/v2/api/discount';
  Future<List<dynamic>> getDiscounts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getAllDiscounts'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var discounts = data['metaData'];

        return discounts;
      } else {
        throw Exception('Tìm kiếm mã sản phẩm thất bại');
      }
    } catch (e) {
      print('Tìm kiếm mã sản phẩm thất bại: $e');
      return [];
    }
  }
}
