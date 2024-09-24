import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiProduct {
  Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/v2/api/product/all'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var products = data['metaData'];

        return products; // Trả về data từ API
      } else {
        throw Exception('Failed to load Product');
      }
    } catch (e) {
      print('Error fetching Product: $e');
      return []; // Trả về danh sách rỗng nếu xảy ra lỗi
    }
  }

  Future<Map<String, dynamic>> getProductByID(productID) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/v2/api/product/find/$productID'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var product = data['metaData']['product'];
        print(product);
        return product; // Trả về data từ API
      } else {
        throw Exception('Failed to load Product');
      }
    } catch (e) {
      print('Error fetching Product: $e');
      return {};
      // Trả về danh sách rỗng nếu xảy ra lỗi
    }
  }

  Future<List<dynamic>> getProductsBySubCategoryID(subCategoryID) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:3000/v2/api/product/subcategory/$subCategoryID'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var products = data['metaData'];

        return products; // Trả về data từ API
      } else {
        throw Exception('Failed to load Product');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return []; // Trả về danh sách rỗng nếu xảy ra lỗi
    }
  }
}
