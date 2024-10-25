import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiFavorite {
  String baseUrl = 'http://10.0.2.2:3000/v2/api/favorite';
  Future<dynamic> toggleFavorite(productID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('metaData');
    if (token == null) {
      throw Exception('No token found. Please log in again.');
    }
    var metaData = jsonDecode(token);
    var accessToken = metaData['token']['accessToken'];
    try {
      await http.patch(Uri.parse('$baseUrl/toggleFavorite/$productID'),
          headers: {
            'content-type': 'application/json',
            'Authorization': '$accessToken'
          });
    } catch (e) {
      print('Error fetching Product: $e');
      return {};
    }
  }

  Future<List<dynamic>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('metaData');
    if (token == null) {
      throw Exception('No token found. Please log in again.');
    }
    var metaData = jsonDecode(token);
    var accessToken = metaData['token']['accessToken'];
    try {
      final response = await http.get(Uri.parse('$baseUrl/getFavorites'),
          headers: {
            'content-type': 'application/json',
            'Authorization': '$accessToken'
          });

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var favorites = data['metaData'];

        return favorites;
      } else {
        throw Exception('Failed to load Product');
      }
    } catch (e) {
      print('Error fetching Product: $e');
      return [];
    }
  }
}
