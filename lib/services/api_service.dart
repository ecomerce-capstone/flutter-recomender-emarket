import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> post(
    String path,
    Map body, {
    bool auth = false,
  }) async {
    final url = Uri.parse(ApiConfig.endpoint(path));
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await storage.read(key: 'token');
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    final res = await http.post(url, body: jsonEncode(body), headers: headers);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? params,
    bool auth = false,
  }) async {
    var urlStr = ApiConfig.endpoint(path);
    if (params != null && params.isNotEmpty) {
      final q = params.entries
          .map(
            (e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
          )
          .join('&');
      urlStr = '$urlStr?$q';
    }
    final url = Uri.parse(urlStr);
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await storage.read(key: 'token');
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    final res = await http.get(url, headers: headers);
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
