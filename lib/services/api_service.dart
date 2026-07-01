import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api.alphafitness.com'; // Placeholder URL

  Future<bool> syncData(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sync'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
