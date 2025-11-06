import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';

class AuthService {
  static Future<http.Response> login(String email, String password) {
    final url = Uri.parse(ApiConfig.endpoint('/auth/login'));
    return http.post(
      url,
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<http.Response> register(String email, String password) {
    final url = Uri.parse(ApiConfig.endpoint('/auth/register'));
    return http.post(
      url,
      body: jsonEncode({
        'email': email,
        'password': password,
        'account_type': 'user',
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
