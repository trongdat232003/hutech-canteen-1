import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderService {
  final String baseUrl = 'http://10.0.2.2:3000/v2/api/order';

  // Function to get pending orders
  Future<List<dynamic>> fetchPendingOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/listOrderPendingOfUser'),
      headers: {
        'Authorization': '$token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['metaData'];
    } else {
      throw Exception('Failed to load pending orders');
    }
  }

  // Function to get completed orders
  Future<List<dynamic>> fetchCompletedOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/listOrderCompletedOfUser'),
      headers: {
        'Authorization': '$token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['metaData'];
    } else {
      throw Exception('Failed to load completed orders');
    }
  }

  // Function to get cancelled orders
  Future<List<dynamic>> fetchCancelledOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/listOrderCancelledOfUser'),
      headers: {
        'Authorization': '$token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['metaData'];
    } else {
      throw Exception('Failed to load cancelled orders');
    }
  }

  // Function to get successful orders
  Future<List<dynamic>> fetchSuccessOrders(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/listOrderSuccessOfUser'),
      headers: {
        'Authorization': '$token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['metaData'];
    } else {
      throw Exception('Failed to load successful orders');
    }
  }
}
