import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final ApiService api = ApiService();
  final storage = const FlutterSecureStorage();

  String? token;
  bool loading = false;

  Future<bool> login(String email, String password) async {
    loading = true;
    notifyListeners();
    try {
      final res = await AuthService.login(email, password);
      final body = jsonDecode(res.body);
      loading = false;
      if (res.statusCode == 200 && body['state'] == 'success') {
        token = body['data']['token'];
        await storage.write(key: 'token', value: token);
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    loading = true;
    notifyListeners();
    try {
      final res = await AuthService.register(email, password);
      final body = jsonDecode(res.body);
      loading = false;
      return res.statusCode == 200 && body['state'] == 'success';
    } catch (e) {
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    token = null;
    await storage.delete(key: 'token');
    notifyListeners();
  }
}
