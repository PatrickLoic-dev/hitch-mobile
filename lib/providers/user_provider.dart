// lib/providers/user_provider.dart

import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isDriver = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isDriver => _isDriver;

  void login({required bool isDriver}) {
    _isLoggedIn = true;
    _isDriver = isDriver;
    notifyListeners();
  }

  // This is the key method we'll use
  void loginAsDriver() {
    _isLoggedIn = true;
    _isDriver = true;
    notifyListeners(); // Notify widgets to rebuild with the new state
  }

  void setDriverRole(bool isDriver) {
    if (_isDriver != isDriver) {
      _isDriver = isDriver;
      notifyListeners();
    }
  }

  void logout() {
    _isLoggedIn = false;
    _isDriver = false;
    notifyListeners();
  }
}
