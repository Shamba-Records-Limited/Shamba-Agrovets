import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_client.dart';
import '../models/user_model.dart';
import 'package:hive/hive.dart';

class AuthenticationService {
  static const String _userBox = 'user_box';
  static const String _currentUserKey = 'current_user';

  /// LOGIN USER
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = '${ApiClient.baseUrl}/v1/login';
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    // Log request
    // print('LOGIN REQUEST -> URL: $url');
    // print('LOGIN REQUEST -> Headers: $headers');
    // print('LOGIN REQUEST -> Body: $body');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Log raw response
      // print('LOGIN RESPONSE -> Status: ${response.statusCode}');
      // print('LOGIN RESPONSE -> Body: ${response.body}');

      if (response.statusCode != 200) {
        return {'success': false, 'message': 'Login failed. Please try again.'};
      }

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final token = data['data']?['token'];
        final userJson = data['data']?['user'];

        if (token == null || userJson == null) {
          return {'success': false, 'message': 'Invalid response from server.'};
        }

        //  Save token securely
        await ApiClient.saveToken(token);
        // print('LOGIN -> Token saved.');

        // Save user in Hive
        final user = UserModel.fromJson(userJson);
        await _saveUser(user);
        // print('LOGIN -> User saved: ${user.toString()}');

        return {
          'success': true,
          'message': data['message'] ?? 'Login successful',
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Login failed. Try again.',
      };
    } catch (e) {
      // print('LOGIN ERROR -> Exception: $e');
      // print('LOGIN ERROR -> Stack: $st');
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  /// LOGOUT USER 
  static Future<void> logout() async {
    await ApiClient.clearToken();
    await _clearUser();
  }

  ///  Save user in Hive
  static Future<void> _saveUser(UserModel user) async {
    final box = Hive.box<UserModel>(_userBox);
    await box.put(_currentUserKey, user);
  }

  ///  Clear user data
  static Future<void> _clearUser() async {
    final box = Hive.box<UserModel>(_userBox);
    await box.delete(_currentUserKey);
  }

  /// GET current logged-in user
  static UserModel? getLoggedInUser() {
    final box = Hive.box<UserModel>(_userBox);
    return box.get(_currentUserKey);
  }
}
