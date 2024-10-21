import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiAuth {
  final String baseUrl = 'http://10.0.2.2:3000/v2/api/user';

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

        // Log user info to the console
        print('Login successful:');
        print('User ID: ${metaData['user']['_id']}');
        print('Name: ${metaData['user']['name']}');
        print('Email: ${metaData['user']['email']}');
        print('Token: ${metaData['token']['accessToken']}'); // Print token
        print('Avatar URL: ${metaData['user']['avatar']}');
        print('Other Data: $metaData');

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'token', metaData['token']['accessToken']); // Store token
        prefs.setString('metaData', jsonEncode(metaData));
        prefs.setString('accessToken', metaData['token']['accessToken']);
        prefs.setString('refreshToken', metaData['token']['refreshToken']);
        return metaData;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    return accessToken != null; // Trả về true nếu accessToken tồn tại
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

  Future<bool> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgotPassword'),
        body: jsonEncode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> resetPassword(
      String email, String resetCode, String newPassword) async {
    final url = Uri.parse('$baseUrl/resetPassword');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'resetCode': resetCode,
        'newPassword': newPassword,
      }),
    );

    return response.statusCode == 200;
  }

  Future<String?> refreshAccessToken(String refreshToken) async {
    var response = await http.post(
      Uri.parse('$baseUrl/refresh'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['token']['accessToken'];
    } else {
      print('Failed to refresh token: ${response.body}');
      return null;
    }
  }

  bool isValidToken(String? token) {
    if (token == null) {
      return false;
    }
    return true;
  }

  Future<bool> editProfile(String name, File? imageFile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? metaDataString = prefs.getString('metaData');

    if (metaDataString == null) {
      print('No user data found in SharedPreferences.');
      return false;
    }

    Map<String, dynamic> metaData;
    try {
      metaData = jsonDecode(metaDataString);
    } catch (e) {
      print('Cannot parse metaData: $e');
      return false;
    }

    String? accessToken = metaData['token']['accessToken'];
    String? refreshToken = metaData['token']['refreshToken'];

    // Kiểm tra token có hợp lệ không
    if (accessToken == null) {
      print('Access token is null.');
      return false;
    }

    try {
      var request =
          http.MultipartRequest('PATCH', Uri.parse('$baseUrl/updatePr'));
      request.fields['name'] = name; // Thêm tên vào request

      // Nếu có hình ảnh thì thêm hình vào request
      if (imageFile != null) {
        print('Image path: ${imageFile.path}'); // In đường dẫn hình ảnh
        request.files
            .add(await http.MultipartFile.fromPath('avatar', imageFile.path));
      }

      // Thêm header với token
      request.headers['Authorization'] =
          '$accessToken'; // Đảm bảo thêm 'Bearer'

      // Gửi yêu cầu và đọc phản hồi
      var response = await request.send();
      final responseString = await http.Response.fromStream(response);

      // Kiểm tra trạng thái phản hồi
      if (response.statusCode == 200) {
        print('Profile updated successfully: ${responseString.body}');
        return true;
      } else {
        print(
            'Failed to update profile: ${response.statusCode} - ${responseString.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
