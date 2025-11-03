import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  ApiClient._internal();

  // --- Secure storage instance ---
  static const _storage = FlutterSecureStorage();

  // --- Base URL loaded from .env ---
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  // --- Token key for storage ---
  static const String _tokenKey = 'access_token';

  // --- Save access token securely ---
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // --- Retrieve access token ---
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // --- Remove token (logout) ---
  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // --- Helper: make authenticated GET request ---
  static Future<http.Response> get(String endpoint) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl$endpoint');

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return http.get(url, headers: headers);
  }

  // --- Helper: make authenticated POST request ---
  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final token = await getToken();
    final url = Uri.parse('$baseUrl$endpoint');

    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return http.post(
      url,
      headers: headers,
      body: body != null ? http.Request('', url).body = body.toString() : null,
    );
  }
}
