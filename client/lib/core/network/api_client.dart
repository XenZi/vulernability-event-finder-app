import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  final String _baseUrl = 'http://192.168.0.27:8000';

  Future<http.Response> get(String endpoint, String? token) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    try {
      return await http.get(url, headers: headers);
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
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

    final response =
        await http.post(url, headers: headers, body: json.encode(body));

    if (response.statusCode >= 400) {
      throw HttpException(json.decode(response.body)['message']);
    }
    return response;
  }
}
