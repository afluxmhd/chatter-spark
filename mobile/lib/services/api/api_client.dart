import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_utils.dart';

class APIClient {
  APIClient({required this.apiKey}) {
    _headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };
  }
  final String apiKey;
  late Map<String, String> _headers;

  Future<dynamic> get(String url) async {
    final response = await http.get(Uri.parse(url), headers: _headers);
    return processResponse(response);
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(url),
      headers: _headers,
      body: json.encode(body),
    );

    return processResponse(response);
  }
}
