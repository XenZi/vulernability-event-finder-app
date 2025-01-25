import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient._internal();

  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }

  final String _baseUrl = 'http://192.168.1.28:8000';

  Future<http.Response> get(String endpoint, String? token) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode >= 400) {
        throw HttpException(json.decode(response.body)['message']);
      }
      return response;
    } catch (e) {
      print(e.toString());
      throw Exception(e);
    }
  }

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
