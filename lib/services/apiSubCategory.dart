import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiSubCategoryService {
  Future<List<dynamic>> getSubCategoriesByCategoryID(categoryID) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:3000/v2/api/category/getSubCategories/$categoryID'),
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
