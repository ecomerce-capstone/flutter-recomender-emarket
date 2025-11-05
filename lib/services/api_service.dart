import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final storage = FlutterSecureStorage();
  Future<Map<String, dynamic>> post(
    String path,
    Map body, {
    bool auth = false,
  }) async {
    final url = '$API_BASE$path';
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await storage.read(key: 'token');
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    final res = await http.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: headers,
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? params,
    bool auth = false,
  }) async {
    var url = '$API_BASE$path';
    if (params != null && params.isNotEmpty) {
      final q = params.entries
          .map(
            (e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
          )
          .join('&');
      url = '$url?$q';
    }
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await storage.read(key: 'token');
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    final res = await http.get(Uri.parse(url), headers: headers);
    return jsonDecode(res.body);
  }
}
