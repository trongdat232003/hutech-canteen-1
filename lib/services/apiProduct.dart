import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiProduct {
  String baseUrl = 'http://10.0.2.2:3000/v2/api/product';
  Future<List<dynamic>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/all'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var products = data['metaData'];

        return products;
      } else {
        throw Exception('Failed to load Product');
      }
    } catch (e) {
      print('Error fetching Product: $e');
      return [];
    }
  }

  Future<List<dynamic>> getLastProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getLatestProducts'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var products = data['metaData'];

        return products;
      } else {
        throw Exception('Failed to load Product');
      }
    } catch (e) {
      print('Error fetching Product: $e');
      return [];
    }
  }

  Future<List<dynamic>> getProductsSortedByRating() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/getProductsSortedByRating'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var products = data['metaData'];
        return products;
      } else {
        throw Exception('Failed to load Product');
      }
    } catch (e) {
      print('Error fetching Product: $e');
      return [];
    }
  }

  Future<dynamic> getProductByID(productID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('metaData');
    if (token == null) {
      throw Exception('No token found. Please log in again.');
    }
    var metaData = jsonDecode(token);
    var accessToken = metaData['token']['accessToken'];
    try {
      final response = await http.get(Uri.parse('$baseUrl/find/$productID'),
          headers: {
            'content-type': 'application/json',
            'Authorization': '$accessToken'
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var product = data['metaData'];
        return product;
      } else {
        throw Exception('Failed to load Product');
      }
    } catch (e) {
      print('Error fetching Product: $e');
      return {};
    }
  }

  Future<List<dynamic>> getProductsBySubCategoryID(subCategoryID) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subcategory/$subCategoryID'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var products = data['metaData'];

        return products;
      } else {
        throw Exception('Failed to load Product');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  Future<List<dynamic>> searchProducts(String keySearch) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?keySearch=$keySearch'),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var products = data['metaData'];
        return products;
      } else {
        throw Exception('Failed to search products');
      }
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }
}
