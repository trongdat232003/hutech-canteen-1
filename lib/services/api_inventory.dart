import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiInventory {
  String baseUrl = 'http://10.0.2.2:3000/v2/api/inventory';
  Future<dynamic> getInventoryByProductId(productID) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/getInventoryByProductId/$productID'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var inventory = data['metaData'];
        return inventory;
      } else {
        throw Exception('Failed to load Product');
      }
    } catch (e) {
      print('Error fetching Product: $e');
      return {};
    }
  }
}
