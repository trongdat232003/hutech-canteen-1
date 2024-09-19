import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiProduct {
  Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/v2/api/product/all'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var products = data['metaData'];
        print(products);
        return products; // Trả về data từ API
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return []; // Trả về danh sách rỗng nếu xảy ra lỗi
    }
  }
}
