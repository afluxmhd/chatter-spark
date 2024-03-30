import 'dart:convert';
import 'package:http/http.dart' as http;

dynamic processResponse(http.Response response) {
  switch (response.statusCode) {
    case 200: // OK.
      return json.decode(response.body);
    case 400: // Bad Request.
      throw Exception('Request error. Please retry.');
    case 401: // Unauthorized.
      throw Exception('Login needed. Check your access.');
    case 403: // Forbidden.
      throw Exception('Access denied. Contact support.');
    case 404: // Not Found.
      throw Exception('Not found. Check URL or contact us.');
    case 500: // Internal Server Error.
      throw Exception('Server error. Please try later.');
    default:
      throw Exception('Connection issue. Try again or contact support.');
  }
}
