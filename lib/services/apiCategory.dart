import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiCategoryService {
  String baseUrl = 'http://10.0.2.2:3000/v2/api/category';

  Future<List<dynamic>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/listPublish'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var categories = data['metaData'];
        print(categories);
        return categories; // Trả về data từ API
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return []; // Trả về danh sách rỗng nếu xảy ra lỗi
    }
  }
}
