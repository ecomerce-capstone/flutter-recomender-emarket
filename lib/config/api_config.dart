import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static final String baseUrl =
      dotenv.env['API_BASE'] ?? 'http://10.0.2.2:4000/api/v1';
  static String endpoint(String path) => '$baseUrl$path';
}
