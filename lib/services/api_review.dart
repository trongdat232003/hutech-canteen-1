import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiReview {
  String baseUrl = 'http://10.0.2.2:3000/v2/api/review';

  Future<List<dynamic>> getOrderNotReviews() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('metaData');
      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }
      var metaData = jsonDecode(token);
      var accessToken = metaData['token']['accessToken'];

      final response = await http.get(
        Uri.parse('$baseUrl/getOrderProductNotReview'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$accessToken'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var reviews = data['metaData'];
        print(reviews);
        return reviews;
      } else {
        throw Exception('Failed to load Reviews');
      }
    } catch (e) {
      print('Error fetching Reviews: $e');
      return [];
    }
  }

  Future<List<dynamic>> getReviews() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('metaData');
      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }
      var metaData = jsonDecode(token);
      var accessToken = metaData['token']['accessToken'];

      final response = await http.get(
        Uri.parse('$baseUrl/getReviewByUser'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$accessToken'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var reviews = data['metaData'];
        print(reviews);
        return reviews;
      } else {
        throw Exception('Failed to load Reviews');
      }
    } catch (e) {
      print('Error fetching Reviews: $e');
      return [];
    }
  }

  Future<dynamic> getAllReviewOfProduct(productID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('metaData');
    if (token == null) {
      throw Exception('No token found. Please log in again.');
    }
    var metaData = jsonDecode(token);
    var accessToken = metaData['token']['accessToken'];
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/getAllReviewOfProduct/$productID'),
          headers: {
            'content-type': 'application/json',
            'Authorization': '$accessToken'
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var review = data['metaData'];
        return review;
      } else {
        throw Exception('Failed to load Review of Product');
      }
    } catch (e) {
      print('Failed to load Review of Product: $e');
      return {};
    }
  }

  Future<void> createReview(String orderID, String productID, String? img1,
      String? img2, String comment, double rating) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('metaData');

      if (token == null) {
        throw Exception('No token found. Please log in again.');
      }
      var metaData = jsonDecode(token);
      var accessToken = metaData['token']['accessToken'];

      final response = await http.post(Uri.parse('$baseUrl/create'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': '$accessToken'
          },
          body: jsonEncode({
            'review_order_id': orderID,
            'review_product_id': productID,
            'review_rating': rating,
            'review_comment': comment,
            'review_img_1': img1,
            'review_img_2': img2,
          }));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var reviews = data['metaData'];
        print(reviews);
        return reviews;
      } else {
        throw Exception('Failed to create Review');
      }
    } catch (e) {
      print('Error creating Review: $e');
    }
  }
}
