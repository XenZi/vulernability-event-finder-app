import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  // Private constructor
  ApiClient._internal();

  // Static instance of the class
  static final ApiClient _instance = ApiClient._internal();

  // Factory constructor to return the same instance
  factory ApiClient() {
    return _instance;
  }

  // Base URL for API
  final String _baseUrl = 'http://192.168.0.27:8000';

  // GET request
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

  // POST request
  Future<http.Response> post(
      String endpoint, Map<String, dynamic> body, String? token) async {
    final url = Uri.parse('$_baseUrl$endpoint');
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

  Future<http.Response> put(
      String endpoint, Map<String, dynamic> body, String? token) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    final response =
        await http.put(url, headers: headers, body: json.encode(body));
    print(response.body);
    if (response.statusCode >= 400) {
      throw HttpException(json.decode(response.body)['message']);
    }
    return response;
  }

  Future<http.Response> delete(String endpoint, String? token) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode >= 400) {
        throw HttpException(json.decode(response.body)['message']);
      }
      return response;
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }
}
