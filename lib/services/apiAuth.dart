import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiAuth {
  final String baseUrl = 'http://localhost:3000/v2/api/user';

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var metaData = data['metaData'];
// In thông tin người dùng ra console
        print('Login successful:');
        print('User ID: ${metaData['user']['_id']}');
        print('Name: ${metaData['user']['name']}');
        print('Email: ${metaData['user']['email']}');
        print('Token: ${metaData['token']}'); // Nếu có token
        print('Other Data: $metaData'); // In toàn bộ dữ liệu metaData nếu cần
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('metaData', jsonEncode(metaData));
        // print(metaData);
        return metaData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
