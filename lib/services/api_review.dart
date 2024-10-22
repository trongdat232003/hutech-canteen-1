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
        print(reviews[0]['order_product']['product_thumb']);
        return reviews;
      } else {
        throw Exception('Failed to load Reviews');
      }
    } catch (e) {
      print('Error fetching Reviews: $e');
      return [];
    }
  }
}
