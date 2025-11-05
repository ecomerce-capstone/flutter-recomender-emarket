import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final ApiService api = ApiService();
  final storage = FlutterSecureStorage();

  String? token;
  bool loading = false;

  Future<bool> login(String email, String password) async {
    loading = true;
    notifyListeners();
    final res = await api.post('/auth/login', {
      'email': email,
      'password': password,
    });
    loading = false;
    if (res['state'] == 'success') {
      token = res['data']['token'];
      await storage.write(key: 'token', value: token);
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<bool> register(
    String email,
    String password,
    String accountType,
  ) async {
    loading = true;
    notifyListeners();
    final res = await api.post('/auth/register', {
      'email': email,
      'password': password,
      'account_type': accountType,
    });
    loading = false;
    return res['state'] == 'success';
  }

  Future<void> logout() async {
    token = null;
    await storage.delete(key: 'token');
    notifyListeners();
  }
}
