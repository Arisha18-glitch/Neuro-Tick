import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userName;
  int _loginCount = 0;

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  int get loginCount => _loginCount;

  // Simulate login
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    _isLoggedIn = true;
    _userName = email.split('@').first; // Extract name from email
    _loginCount++;

    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));

    _isLoggedIn = false;
    _userName = null;

    notifyListeners();
  }

  // Check login status
  Future<bool> checkLoginStatus() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _isLoggedIn;
  }
}