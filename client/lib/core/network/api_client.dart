import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String _baseUrl = 'http://localhost:8000';

  Future<http.Response> get(String endpoint, String? token) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return await http.get(url, headers: headers);
  }

  Future<http.Response> post(
      String endpoint, Map<String, dynamic> body, String? token) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    print(url);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return await http.post(url, headers: headers, body: jsonEncode(body));
  }
}
