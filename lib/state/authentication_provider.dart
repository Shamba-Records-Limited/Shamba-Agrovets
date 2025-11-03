import 'package:flutter/foundation.dart';
import '../utils/api_client.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  UserModel? _currentUser;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  UserModel? get currentUser => _currentUser;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    final token = await ApiClient.getToken();

    if (token != null && token.isNotEmpty) {
      _currentUser = AuthenticationService.getLoggedInUser();
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Log in the user
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await AuthenticationService.login(email, password);

    _isLoading = false;
    if (response['success'] == true) {
      _currentUser = AuthenticationService.getLoggedInUser();
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } else {
      _isLoggedIn = false;
      notifyListeners();
      return false;
    }
  }

  /// Log out the user
  Future<void> logout() async {
    await AuthenticationService.logout();
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
