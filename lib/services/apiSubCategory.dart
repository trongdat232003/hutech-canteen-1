import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiSubCategoryService {
  String baseUrl = 'http://localhost:3000/v2/api/category';
  Future<List<dynamic>> getSubCategoriesByCategoryID(categoryID) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getSubCategories/$categoryID'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var subCategories = data['metaData'];

        return subCategories;
      } else {
        throw Exception('Failed to load subCategories');
      }
    } catch (e) {
      print('Error fetching subCategories: $e');
      return []; // Trả về danh sách rỗng nếu xảy ra lỗi
    }
  }
}
